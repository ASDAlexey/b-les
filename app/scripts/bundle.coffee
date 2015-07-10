#vinilla.js
HTMLCollection::forEach = Array::forEach
NodeList::forEach = Array::forEach
NodeList::filter = Array::filter
HTMLElement::index = ->
  self = this
  parent = self.parentNode
  i = 0
  while self.previousElementSibling
    i++
    self = self.previousElementSibling
  if this == parent.children[i] then i else -1
if typeof document.body.closest != 'function'
# matches polyfill
  @Element and ((ElementPrototype) ->
    ElementPrototype.matches = ElementPrototype.matches or ElementPrototype.matchesSelector or ElementPrototype.webkitMatchesSelector or ElementPrototype.msMatchesSelector or (selector) ->
        node = this
        nodes = (node.parentNode or node.document).querySelectorAll(selector)
        i = -1
        while nodes[++i] and nodes[i] != node
          !!nodes[i]
    return)(Element.prototype)
  # closest polyfill
  @Element and ((ElementPrototype) ->
    ElementPrototype.closest = ElementPrototype.closest or (selector) ->
        el = this
        while el.matches and !el.matches(selector)
          el = el.parentNode
        if el.matches then el else null
    return)(Element.prototype)
#remove
Element::remove = ->
  @parentElement.removeChild this
  return
NodeList::remove =
  HTMLCollection::remove = ->
    i = 0
    len = @length
    while i < len
      if @[i] and @[i].parentElement
        @[i].parentElement.removeChild @[i]
      i++
#classList
if 'document' of self
# Full polyfill for browsers with no classList support
  if !('classList' of document.createElement('_'))
    ((view) ->
      'use strict'
      if !('Element' of view)
        return
      classListProp = 'classList'
      protoProp = 'prototype'
      elemCtrProto = view.Element[protoProp]
      objCtr = Object
      strTrim = String[protoProp].trim or ->
        @replace /^\s+|\s+$/g,''
      arrIndexOf = Array[protoProp].indexOf or (item) ->
        i = 0
        len = @length
        while i < len
          if i of this and @[i] == item
            return i
          i++
        -1

      DOMEx = (type,message) ->
        @name = type
        @code = DOMException[type]
        @message = message
        return

      checkTokenAndGetIndex = (classList,token) ->
        if token == ''
          throw new DOMEx('SYNTAX_ERR','An invalid or illegal string was specified')
        if /\s/.test(token)
          throw new DOMEx('INVALID_CHARACTER_ERR','String contains an invalid character')
        arrIndexOf.call classList,token

      ClassList = (elem) ->
        trimmedClasses = strTrim.call(elem.getAttribute('class') or '')
        classes = if trimmedClasses then trimmedClasses.split(/\s+/) else []
        i = 0
        len = classes.length
        while i < len
          @push classes[i]
          i++

        @_updateClassName = ->
          elem.setAttribute 'class',@toString()
          return

        return

      classListProto = ClassList[protoProp] = []

      classListGetter = ->
        new ClassList(this)

      # Most DOMException implementations don't allow calling DOMException's toString()
      # on non-DOMExceptions. Error's toString() is sufficient here.
      DOMEx[protoProp] = Error[protoProp]

      classListProto.item = (i) ->
        @[i] or null

      classListProto.contains = (token) ->
        token += ''
        checkTokenAndGetIndex(this,token) != -1

      classListProto.add = ->
        tokens = arguments
        i = 0
        l = tokens.length
        token = undefined
        updated = false
        loop
          token = tokens[i] + ''
          if checkTokenAndGetIndex(this,token) == -1
            @push token
            updated = true
          unless ++i < l
            break
        if updated
          @_updateClassName()
        return

      classListProto.remove = ->
        tokens = arguments
        i = 0
        l = tokens.length
        token = undefined
        updated = false
        index = undefined
        loop
          token = tokens[i] + ''
          index = checkTokenAndGetIndex(this,token)
          while index != -1
            @splice index,1
            updated = true
            index = checkTokenAndGetIndex(this,token)
          unless ++i < l
            break
        if updated
          @_updateClassName()
        return

      classListProto.toggle = (token,force) ->
        token += ''
        result = @contains(token)
        method = if result then force != true and 'remove' else force != false and 'add'
        if method
          @[method] token
        if force == true or force == false
          force
        else
          !result

      classListProto.toString = ->
        @join ' '

      if objCtr.defineProperty
        classListPropDesc =
          get : classListGetter
          enumerable : true
          configurable : true
        try
          objCtr.defineProperty elemCtrProto,classListProp,classListPropDesc
        catch ex
# IE 8 doesn't support enumerable:true
          if ex.number == -0x7FF5EC54
            classListPropDesc.enumerable = false
            objCtr.defineProperty elemCtrProto,classListProp,classListPropDesc
      else if objCtr[protoProp].__defineGetter__
        elemCtrProto.__defineGetter__ classListProp,classListGetter
      return) self
  else
# There is full or partial native classList support, so just check if we need
# to normalize the add/remove and toggle APIs.
    do ->
      'use strict'
      testElement = document.createElement('_')
      testElement.classList.add 'c1','c2'
      # Polyfill for IE 10/11 and Firefox <26, where classList.add and
      # classList.remove exist but support only one argument at a time.
      if !testElement.classList.contains('c2')

        createMethod = (method) ->
          original = DOMTokenList.prototype[method]

          DOMTokenList.prototype[method] = (token) ->
            i = undefined
            len = arguments.length
            i = 0
            while i < len
              token = arguments[i]
              original.call this,token
              i++
            return

          return

        createMethod 'add'
        createMethod 'remove'
      testElement.classList.toggle 'c3',false
      # Polyfill for IE 10 and Firefox <24, where classList.toggle does not
      # support the second argument.
      if testElement.classList.contains('c3')
        _toggle = DOMTokenList::toggle

        DOMTokenList::toggle = (token,force) ->
          if 1 of arguments and !@contains(token) == !force
            force
          else
            _toggle.call this,token

      testElement = null
      return
#preloader
window.onload = ->
  preloader = document.getElementById('container-preloader')
  preloader.classList.add('loaded')
  preloader.classList.add('full-loaded')
  setTimeout(->
    preloader.remove()
  ,1200)
#fade animation nav menu
class FadeAnimation
  options = {}
  constructor : (data) ->
    options = data
    @events()
  events : ->
    @getCollectionElements().forEach (el,index)=>
      el.parentNode.addEventListener 'mouseenter',(e)->
        e.currentTarget.getElementsByClassName('sub-menu')[0].classList.remove('dn')
        e.currentTarget.getElementsByClassName('sub-menu')[0].classList.add('active')
      @transitionEnd(el)
  transitionEnd : (el)->
    el.addEventListener 'transitionend',(e)->
      if e.target.classList.contains('sub-menu') or e.target.classList.contains('level-link')
        el.classList.add('dn')
        el.classList.remove('active')
  getCollectionElements : ->
    if options.elements
      document.querySelectorAll(options.elements)
navSubmenu = new FadeAnimation(
  elements : '.sub-menu'
  time : 700
)
#bg-slider
class BgSlider
  options = {}
  constructor : (data) ->
    options = data
    @getContainers().forEach (el,index)=>
      @initSliderPosition(el)
      @createTrimLists(el)
      @events(@getThumbs(el),'thumbs',el)
      @events(@getArrows(el),'arrows',el,@getThumbs(el))
  initSliderPosition : (container)->
    @move(options.startSliderIndex,container)
  createTrimLists : (container)->
    firstList = container.querySelector('.slider>li:first-child').cloneNode(true)
    firstList.classList.add('first','active')
    lastList = container.querySelector('.slider>li:last-child').cloneNode(true)
    lastList.classList.add('last','active')
    trimContainer = container.getElementsByClassName('trim-container')[0]
    trimContainer.appendChild(firstList)
    trimContainer.appendChild(lastList)
  getThumbs : (el)->
    el.querySelectorAll(options.thumbs)
  getArrows : (container,param = null)->
    unless param
      container.querySelectorAll(options.arrows)
    else if(param is 'prev')
      result = null
      container.querySelectorAll(options.arrows).forEach (el,index)->
        if el.classList.contains('prev')
          result = el
      result
    else if(param is 'next')
      result = null
      container.querySelectorAll(options.arrows).forEach (el,index)->
        if el.classList.contains('next')
          result = el
      result
  getContainers : ->
    if options.container
      document.querySelectorAll(options.container)
  move : (index,container)->
    pos = -index * 100
    container = container.getElementsByClassName('slider')[0]
    container.style.transform = "translate3d(#{pos}%, 0, 0)"
    container.style.OTransform = "translate3d(#{pos}%, 0, 0)"
    container.style.msTransform = "translate3d(#{pos}%, 0, 0)"
    container.style.MozTransform = "translate3d(#{pos}%, 0, 0)"
    container.style.WebkitTransform = "translate3d(#{pos}%, 0, 0)"
  getCurrentActiveThumbIndex : (collection)->
    currentActiveElIndex = null
    collection.forEach (el,index)->
      if el.classList.contains('active')
        currentActiveElIndex = index
    currentActiveElIndex
  setActiveThumb : (collection = null,index = null,ect = null)->
    if index isnt null
      activeEl = (
        collection.filter (el)->
          return el.classList.contains('active')
      )[0]
      if activeEl
        activeEl.classList.remove('active')
        collection[index].classList.add('active')
  moveTrimSlides : (countThumbs = null,container = null,sideSlide = null)->
    if sideSlide is 'prev'
      @move(-1,container)
      container.querySelector('.trim-container>li:last-child').classList.remove('active')
      setTimeout(=>
        container.getElementsByClassName('slider')[0].classList.add('actived')
        @move(countThumbs - 1,container)
        setTimeout(->
          container.getElementsByClassName('slider')[0].classList.remove('actived')
          container.querySelector('.trim-container>li:last-child').classList.add('active')
        ,50)
      ,800)
    if sideSlide is 'next'
      @move(countThumbs,container)
      container.querySelector('.trim-container>li:first-child').classList.remove('active')
      setTimeout(=>
        container.getElementsByClassName('slider')[0].classList.add('actived')
        @move(0,container)
        setTimeout(->
          container.getElementsByClassName('slider')[0].classList.remove('actived')
          container.querySelector('.trim-container>li:first-child').classList.add('active')
        ,50)
      ,800)
  events : (collection = [],name = "",container = "",thumbsForArrows = "")=>
    collection.forEach (el,index)=>
      if name is 'thumbs'
        el.addEventListener 'click',(e)=>
          e.preventDefault()
          index = e.currentTarget.parentNode.index()
          @setActiveThumb(collection,index)
          @move(index,container)
      if name is 'arrows'
        el.addEventListener 'click',(e)=>
          e.preventDefault()
          ect = e.currentTarget
          currentActiveElIndex = @getCurrentActiveThumbIndex(thumbsForArrows)
          countThumbs = thumbsForArrows.length
          if ect.classList.contains('prev')
            if currentActiveElIndex > 0
              currentActiveElIndex--
              @move(currentActiveElIndex,container)
            else
              currentActiveElIndex = countThumbs - 1
              @moveTrimSlides(countThumbs,container,'prev')
          else if ect.classList.contains('next')
            if currentActiveElIndex < countThumbs - 1
              currentActiveElIndex++
              @move(currentActiveElIndex,container)
            else
              currentActiveElIndex = 0
              @moveTrimSlides(countThumbs,container,'next')
          @setActiveThumb(thumbsForArrows,currentActiveElIndex)
bgSlider = new BgSlider(
  container : '.bg-slider-block'
  thumbs : '.thumb-menu>li>a'
  arrows : '.switchers .arrow'
  time : 700
  startSliderIndex : 5
)
#popup gallery
class PopupGallery
  options = {}
  dataGallery = []
  constructor : (data) ->
    options = data
    @getContainers().forEach (el,index)=>
      @fetchData(el)
      #@render(el)
#      @events(el,'')
  render : (container)->
    containerGallery = document.createElement('section')
    containerGallery.className = "wrapper-popup-gallery"
    console.log(containerGallery)
    container.parentNode.insertBefore(containerGallery,container)
  getContainers : ->
    if options.container
      document.querySelectorAll(options.container)
  fetchData : (container)->
    container.querySelectorAll('li>a').forEach (el,value)->
      dataGallery.push {
        src : el.getAttribute('href')
        thumbSrc : el.childNodes[0].getAttribute('src')
      }
#  events : (collection = [])=>
#    collection.forEach (el,index)=>
  open : ->

popupGallery = new PopupGallery(
  container : '.popup-gallery'
)

#map
class Map
  options = {}
  constructor : (data)->
    options = data
    options.data = []
    @getContainers().forEach (el,index)=>
      options.data.push @getData(el)
      ymaps.ready =>
        @initMap(@getData(el))
  getCeocoder : (city)->
    ymaps.geocode(city)
    myGeocoder = ymaps.geocode(city)
    myGeocoder.then (
      (res) ->
        center = res.geoObjects.get(0).geometry.getCoordinates()
        customEvent = new CustomEvent('geocode:loaded',detail : {center : center})
        document.dispatchEvent(customEvent);
    )
    myGeocoder
  initMap : (data)->
    console.log(data)
    @getCeocoder(data.nameTown)
    document.addEventListener("geocode:loaded",(e)->
      map = new (ymaps.Map) 'map',
        center : e.detail.center
        zoom : 16
      collection = new (ymaps.GeoObjectCollection)({},
        preset : 'twirl#blueIcon'
        draggable : false)
      i = 0
      while i < data.markers.length
        collection.add new (ymaps.Placemark)(data.markers[i].coordinates,iconContent : i + 1)
        i++
      map.geoObjects.add collection
      map.setBounds(collection.getBounds(),{
          checkZoomRange : true
          zoomMargin: 100
          callback : ->
            console.log('ss')
        }
      )
      map.behaviors.disable ['scrollZoom']
    )
  getContainers : ->
    if options.container
      document.querySelectorAll(options.container)
  getData : (el)->
    JSON.parse(el.dataset.info)
townMap = new Map(
  container : "#map"
)
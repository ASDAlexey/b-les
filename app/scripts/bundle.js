(function() {
  var BgSlider, FadeAnimation, Map, PopupGallery, bgSlider, navSubmenu, popupGallery, townMap,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  HTMLCollection.prototype.forEach = Array.prototype.forEach;

  NodeList.prototype.forEach = Array.prototype.forEach;

  NodeList.prototype.filter = Array.prototype.filter;

  HTMLElement.prototype.index = function() {
    var i, parent, self;
    self = this;
    parent = self.parentNode;
    i = 0;
    while (self.previousElementSibling) {
      i++;
      self = self.previousElementSibling;
    }
    if (this === parent.children[i]) {
      return i;
    } else {
      return -1;
    }
  };

  if (typeof document.body.closest !== 'function') {
    this.Element && (function(ElementPrototype) {
      ElementPrototype.matches = ElementPrototype.matches || ElementPrototype.matchesSelector || ElementPrototype.webkitMatchesSelector || ElementPrototype.msMatchesSelector || function(selector) {
        var i, node, nodes, results;
        node = this;
        nodes = (node.parentNode || node.document).querySelectorAll(selector);
        i = -1;
        results = [];
        while (nodes[++i] && nodes[i] !== node) {
          results.push(!!nodes[i]);
        }
        return results;
      };
    })(Element.prototype);
    this.Element && (function(ElementPrototype) {
      ElementPrototype.closest = ElementPrototype.closest || function(selector) {
        var el;
        el = this;
        while (el.matches && !el.matches(selector)) {
          el = el.parentNode;
        }
        if (el.matches) {
          return el;
        } else {
          return null;
        }
      };
    })(Element.prototype);
  }

  Element.prototype.remove = function() {
    this.parentElement.removeChild(this);
  };

  NodeList.prototype.remove = HTMLCollection.prototype.remove = function() {
    var i, len, results;
    i = 0;
    len = this.length;
    results = [];
    while (i < len) {
      if (this[i] && this[i].parentElement) {
        this[i].parentElement.removeChild(this[i]);
      }
      results.push(i++);
    }
    return results;
  };

  if ('document' in self) {
    if (!('classList' in document.createElement('_'))) {
      (function(view) {
        'use strict';
        var ClassList, DOMEx, arrIndexOf, checkTokenAndGetIndex, classListGetter, classListProp, classListPropDesc, classListProto, elemCtrProto, ex, objCtr, protoProp, strTrim;
        if (!('Element' in view)) {
          return;
        }
        classListProp = 'classList';
        protoProp = 'prototype';
        elemCtrProto = view.Element[protoProp];
        objCtr = Object;
        strTrim = String[protoProp].trim || function() {
          return this.replace(/^\s+|\s+$/g, '');
        };
        arrIndexOf = Array[protoProp].indexOf || function(item) {
          var i, len;
          i = 0;
          len = this.length;
          while (i < len) {
            if (i in this && this[i] === item) {
              return i;
            }
            i++;
          }
          return -1;
        };
        DOMEx = function(type, message) {
          this.name = type;
          this.code = DOMException[type];
          this.message = message;
        };
        checkTokenAndGetIndex = function(classList, token) {
          if (token === '') {
            throw new DOMEx('SYNTAX_ERR', 'An invalid or illegal string was specified');
          }
          if (/\s/.test(token)) {
            throw new DOMEx('INVALID_CHARACTER_ERR', 'String contains an invalid character');
          }
          return arrIndexOf.call(classList, token);
        };
        ClassList = function(elem) {
          var classes, i, len, trimmedClasses;
          trimmedClasses = strTrim.call(elem.getAttribute('class') || '');
          classes = trimmedClasses ? trimmedClasses.split(/\s+/) : [];
          i = 0;
          len = classes.length;
          while (i < len) {
            this.push(classes[i]);
            i++;
          }
          this._updateClassName = function() {
            elem.setAttribute('class', this.toString());
          };
        };
        classListProto = ClassList[protoProp] = [];
        classListGetter = function() {
          return new ClassList(this);
        };
        DOMEx[protoProp] = Error[protoProp];
        classListProto.item = function(i) {
          return this[i] || null;
        };
        classListProto.contains = function(token) {
          token += '';
          return checkTokenAndGetIndex(this, token) !== -1;
        };
        classListProto.add = function() {
          var i, l, token, tokens, updated;
          tokens = arguments;
          i = 0;
          l = tokens.length;
          token = void 0;
          updated = false;
          while (true) {
            token = tokens[i] + '';
            if (checkTokenAndGetIndex(this, token) === -1) {
              this.push(token);
              updated = true;
            }
            if (!(++i < l)) {
              break;
            }
          }
          if (updated) {
            this._updateClassName();
          }
        };
        classListProto.remove = function() {
          var i, index, l, token, tokens, updated;
          tokens = arguments;
          i = 0;
          l = tokens.length;
          token = void 0;
          updated = false;
          index = void 0;
          while (true) {
            token = tokens[i] + '';
            index = checkTokenAndGetIndex(this, token);
            while (index !== -1) {
              this.splice(index, 1);
              updated = true;
              index = checkTokenAndGetIndex(this, token);
            }
            if (!(++i < l)) {
              break;
            }
          }
          if (updated) {
            this._updateClassName();
          }
        };
        classListProto.toggle = function(token, force) {
          var method, result;
          token += '';
          result = this.contains(token);
          method = result ? force !== true && 'remove' : force !== false && 'add';
          if (method) {
            this[method](token);
          }
          if (force === true || force === false) {
            return force;
          } else {
            return !result;
          }
        };
        classListProto.toString = function() {
          return this.join(' ');
        };
        if (objCtr.defineProperty) {
          classListPropDesc = {
            get: classListGetter,
            enumerable: true,
            configurable: true
          };
          try {
            objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
          } catch (_error) {
            ex = _error;
            if (ex.number === -0x7FF5EC54) {
              classListPropDesc.enumerable = false;
              objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
            }
          }
        } else if (objCtr[protoProp].__defineGetter__) {
          elemCtrProto.__defineGetter__(classListProp, classListGetter);
        }
      })(self);
    } else {
      (function() {
        'use strict';
        var _toggle, createMethod, testElement;
        testElement = document.createElement('_');
        testElement.classList.add('c1', 'c2');
        if (!testElement.classList.contains('c2')) {
          createMethod = function(method) {
            var original;
            original = DOMTokenList.prototype[method];
            DOMTokenList.prototype[method] = function(token) {
              var i, len;
              i = void 0;
              len = arguments.length;
              i = 0;
              while (i < len) {
                token = arguments[i];
                original.call(this, token);
                i++;
              }
            };
          };
          createMethod('add');
          createMethod('remove');
        }
        testElement.classList.toggle('c3', false);
        if (testElement.classList.contains('c3')) {
          _toggle = DOMTokenList.prototype.toggle;
          DOMTokenList.prototype.toggle = function(token, force) {
            if (1 in arguments && !this.contains(token) === !force) {
              return force;
            } else {
              return _toggle.call(this, token);
            }
          };
        }
        testElement = null;
      })();
    }
  }

  window.onload = function() {
    var preloader;
    preloader = document.getElementById('container-preloader');
    preloader.classList.add('loaded');
    preloader.classList.add('full-loaded');
    return setTimeout(function() {
      return preloader.remove();
    }, 1200);
  };

  FadeAnimation = (function() {
    var options;

    options = {};

    function FadeAnimation(data) {
      options = data;
      this.events();
    }

    FadeAnimation.prototype.events = function() {
      return this.getCollectionElements().forEach((function(_this) {
        return function(el, index) {
          el.parentNode.addEventListener('mouseenter', function(e) {
            e.currentTarget.getElementsByClassName('sub-menu')[0].classList.remove('dn');
            return e.currentTarget.getElementsByClassName('sub-menu')[0].classList.add('active');
          });
          return _this.transitionEnd(el);
        };
      })(this));
    };

    FadeAnimation.prototype.transitionEnd = function(el) {
      return el.addEventListener('transitionend', function(e) {
        if (e.target.classList.contains('sub-menu') || e.target.classList.contains('level-link')) {
          el.classList.add('dn');
          return el.classList.remove('active');
        }
      });
    };

    FadeAnimation.prototype.getCollectionElements = function() {
      if (options.elements) {
        return document.querySelectorAll(options.elements);
      }
    };

    return FadeAnimation;

  })();

  navSubmenu = new FadeAnimation({
    elements: '.sub-menu',
    time: 700
  });

  BgSlider = (function() {
    var options;

    options = {};

    function BgSlider(data) {
      this.events = bind(this.events, this);
      options = data;
      this.getContainers().forEach((function(_this) {
        return function(el, index) {
          _this.initSliderPosition(el);
          _this.createTrimLists(el);
          _this.events(_this.getThumbs(el), 'thumbs', el);
          return _this.events(_this.getArrows(el), 'arrows', el, _this.getThumbs(el));
        };
      })(this));
    }

    BgSlider.prototype.initSliderPosition = function(container) {
      return this.move(options.startSliderIndex, container);
    };

    BgSlider.prototype.createTrimLists = function(container) {
      var firstList, lastList, trimContainer;
      firstList = container.querySelector('.slider>li:first-child').cloneNode(true);
      firstList.classList.add('first', 'active');
      lastList = container.querySelector('.slider>li:last-child').cloneNode(true);
      lastList.classList.add('last', 'active');
      trimContainer = container.getElementsByClassName('trim-container')[0];
      trimContainer.appendChild(firstList);
      return trimContainer.appendChild(lastList);
    };

    BgSlider.prototype.getThumbs = function(el) {
      return el.querySelectorAll(options.thumbs);
    };

    BgSlider.prototype.getArrows = function(container, param) {
      var result;
      if (param == null) {
        param = null;
      }
      if (!param) {
        return container.querySelectorAll(options.arrows);
      } else if (param === 'prev') {
        result = null;
        container.querySelectorAll(options.arrows).forEach(function(el, index) {
          if (el.classList.contains('prev')) {
            return result = el;
          }
        });
        return result;
      } else if (param === 'next') {
        result = null;
        container.querySelectorAll(options.arrows).forEach(function(el, index) {
          if (el.classList.contains('next')) {
            return result = el;
          }
        });
        return result;
      }
    };

    BgSlider.prototype.getContainers = function() {
      if (options.container) {
        return document.querySelectorAll(options.container);
      }
    };

    BgSlider.prototype.move = function(index, container) {
      var pos;
      pos = -index * 100;
      container = container.getElementsByClassName('slider')[0];
      container.style.transform = "translate3d(" + pos + "%, 0, 0)";
      container.style.OTransform = "translate3d(" + pos + "%, 0, 0)";
      container.style.msTransform = "translate3d(" + pos + "%, 0, 0)";
      container.style.MozTransform = "translate3d(" + pos + "%, 0, 0)";
      return container.style.WebkitTransform = "translate3d(" + pos + "%, 0, 0)";
    };

    BgSlider.prototype.getCurrentActiveThumbIndex = function(collection) {
      var currentActiveElIndex;
      currentActiveElIndex = null;
      collection.forEach(function(el, index) {
        if (el.classList.contains('active')) {
          return currentActiveElIndex = index;
        }
      });
      return currentActiveElIndex;
    };

    BgSlider.prototype.setActiveThumb = function(collection, index, ect) {
      var activeEl;
      if (collection == null) {
        collection = null;
      }
      if (index == null) {
        index = null;
      }
      if (ect == null) {
        ect = null;
      }
      if (index !== null) {
        activeEl = (collection.filter(function(el) {
          return el.classList.contains('active');
        }))[0];
        if (activeEl) {
          activeEl.classList.remove('active');
          return collection[index].classList.add('active');
        }
      }
    };

    BgSlider.prototype.moveTrimSlides = function(countThumbs, container, sideSlide) {
      if (countThumbs == null) {
        countThumbs = null;
      }
      if (container == null) {
        container = null;
      }
      if (sideSlide == null) {
        sideSlide = null;
      }
      if (sideSlide === 'prev') {
        this.move(-1, container);
        container.querySelector('.trim-container>li:last-child').classList.remove('active');
        setTimeout((function(_this) {
          return function() {
            container.getElementsByClassName('slider')[0].classList.add('actived');
            _this.move(countThumbs - 1, container);
            return setTimeout(function() {
              container.getElementsByClassName('slider')[0].classList.remove('actived');
              return container.querySelector('.trim-container>li:last-child').classList.add('active');
            }, 50);
          };
        })(this), 800);
      }
      if (sideSlide === 'next') {
        this.move(countThumbs, container);
        container.querySelector('.trim-container>li:first-child').classList.remove('active');
        return setTimeout((function(_this) {
          return function() {
            container.getElementsByClassName('slider')[0].classList.add('actived');
            _this.move(0, container);
            return setTimeout(function() {
              container.getElementsByClassName('slider')[0].classList.remove('actived');
              return container.querySelector('.trim-container>li:first-child').classList.add('active');
            }, 50);
          };
        })(this), 800);
      }
    };

    BgSlider.prototype.events = function(collection, name, container, thumbsForArrows) {
      if (collection == null) {
        collection = [];
      }
      if (name == null) {
        name = "";
      }
      if (container == null) {
        container = "";
      }
      if (thumbsForArrows == null) {
        thumbsForArrows = "";
      }
      return collection.forEach((function(_this) {
        return function(el, index) {
          if (name === 'thumbs') {
            el.addEventListener('click', function(e) {
              e.preventDefault();
              index = e.currentTarget.parentNode.index();
              _this.setActiveThumb(collection, index);
              return _this.move(index, container);
            });
          }
          if (name === 'arrows') {
            return el.addEventListener('click', function(e) {
              var countThumbs, currentActiveElIndex, ect;
              e.preventDefault();
              ect = e.currentTarget;
              currentActiveElIndex = _this.getCurrentActiveThumbIndex(thumbsForArrows);
              countThumbs = thumbsForArrows.length;
              if (ect.classList.contains('prev')) {
                if (currentActiveElIndex > 0) {
                  currentActiveElIndex--;
                  _this.move(currentActiveElIndex, container);
                } else {
                  currentActiveElIndex = countThumbs - 1;
                  _this.moveTrimSlides(countThumbs, container, 'prev');
                }
              } else if (ect.classList.contains('next')) {
                if (currentActiveElIndex < countThumbs - 1) {
                  currentActiveElIndex++;
                  _this.move(currentActiveElIndex, container);
                } else {
                  currentActiveElIndex = 0;
                  _this.moveTrimSlides(countThumbs, container, 'next');
                }
              }
              return _this.setActiveThumb(thumbsForArrows, currentActiveElIndex);
            });
          }
        };
      })(this));
    };

    return BgSlider;

  })();

  bgSlider = new BgSlider({
    container: '.bg-slider-block',
    thumbs: '.thumb-menu>li>a',
    arrows: '.switchers .arrow',
    time: 700,
    startSliderIndex: 5
  });

  PopupGallery = (function() {
    var dataGallery, options;

    options = {};

    dataGallery = [];

    function PopupGallery(data) {
      options = data;
      this.getContainers().forEach((function(_this) {
        return function(el, index) {
          return _this.fetchData(el);
        };
      })(this));
    }

    PopupGallery.prototype.render = function(container) {
      var containerGallery;
      containerGallery = document.createElement('section');
      containerGallery.className = "wrapper-popup-gallery";
      console.log(containerGallery);
      return container.parentNode.insertBefore(containerGallery, container);
    };

    PopupGallery.prototype.getContainers = function() {
      if (options.container) {
        return document.querySelectorAll(options.container);
      }
    };

    PopupGallery.prototype.fetchData = function(container) {
      return container.querySelectorAll('li>a').forEach(function(el, value) {
        return dataGallery.push({
          src: el.getAttribute('href'),
          thumbSrc: el.childNodes[0].getAttribute('src')
        });
      });
    };

    PopupGallery.prototype.open = function() {};

    return PopupGallery;

  })();

  popupGallery = new PopupGallery({
    container: '.popup-gallery'
  });

  Map = (function() {
    var options;

    options = {};

    function Map(data) {
      options = data;
      options.data = [];
      this.getContainers().forEach((function(_this) {
        return function(el, index) {
          options.data.push(_this.getData(el));
          return ymaps.ready(function() {
            return _this.initMap(_this.getData(el));
          });
        };
      })(this));
    }

    Map.prototype.getCeocoder = function(city) {
      var myGeocoder;
      ymaps.geocode(city);
      myGeocoder = ymaps.geocode(city);
      myGeocoder.then((function(res) {
        var center, customEvent;
        center = res.geoObjects.get(0).geometry.getCoordinates();
        customEvent = new CustomEvent('geocode:loaded', {
          detail: {
            center: center
          }
        });
        return document.dispatchEvent(customEvent);
      }));
      return myGeocoder;
    };

    Map.prototype.initMap = function(data) {
      console.log(data);
      this.getCeocoder(data.nameTown);
      return document.addEventListener("geocode:loaded", function(e) {
        var collection, i, map;
        map = new ymaps.Map('map', {
          center: e.detail.center,
          zoom: 16
        });
        collection = new ymaps.GeoObjectCollection({}, {
          preset: 'twirl#blueIcon',
          draggable: false
        });
        i = 0;
        while (i < data.markers.length) {
          collection.add(new ymaps.Placemark(data.markers[i].coordinates, {
            iconContent: i + 1
          }));
          i++;
        }
        map.geoObjects.add(collection);
        map.setBounds(collection.getBounds(), {
          checkZoomRange: true,
          zoomMargin: 100,
          callback: function() {
            return console.log('ss');
          }
        });
        return map.behaviors.disable(['scrollZoom']);
      });
    };

    Map.prototype.getContainers = function() {
      if (options.container) {
        return document.querySelectorAll(options.container);
      }
    };

    Map.prototype.getData = function(el) {
      return JSON.parse(el.dataset.info);
    };

    return Map;

  })();

  townMap = new Map({
    container: "#map"
  });

}).call(this);

//# sourceMappingURL=bundle.js.map
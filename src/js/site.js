// Generated by CoffeeScript 1.6.1
(function() {
  var _docReady;

  window.debug_enabled = true;

  window.send_scroll_complete = false;

  window.defaults = {
    globalJQEasing: 'easeOutCubic',
    mobileWidth: 480,
    iPadWidth: 768,
    largeScreenWidth: 1070,
    checkScreenSizeOn: 'resizeComplete',
    triggerResizeComplete: true
  };

  if (typeof TweenLite !== "undefined" && TweenLite !== null) {
    defaults.globalEasing = Cubic.easeOut;
  }

  $.ApplicationName = 'JiffyworksApplication';

  $.PageName = '';

  $.Body = $('body');

  $.Window = $(window);

  if (($.browser.mozilla != null) || ($.browser.msie != null)) {
    $.Scroll = $('html');
  } else {
    $.Scroll = $.Body;
  }

  $.MobileWebkit = $.Body.hasClass('webkit-mobile') || (navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)) || (navigator.userAgent.match(/iPad/i));

  $.MobileDevice = (navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)) || (navigator.userAgent.match(/Android/i));

  $.Tablet = navigator.userAgent.match(/iPad/i);

  $.MobileSize = false;

  $.iPadSize = false;

  $.LargeScreenSize = false;

  $.Events = {
    KEY_ESC: 'keyEscape',
    KEY_ENTER: 'keyEnter',
    KEY_SPACE: 'keySpace',
    KEY_UP: 'keyUp',
    KEY_DOWN: 'keyDown',
    KEY_RIGHT: 'keyRight',
    KEY_LEFT: 'keyLeft',
    RESIZE: 'resizeSite',
    RESIZE_COMPLETE: 'resizeSiteComplete',
    SCROLL_COMPLETE: 'scrollComplete',
    CLICK: 'click',
    CHANGE: 'change',
    SUBMIT: 'submit',
    FOCUS: 'focus',
    BLUR: 'blur',
    MOUSE_OVER: 'mouseover',
    MOUSE_OUT: 'mouseout',
    MOUSE_ENTER: 'mouseenter',
    MOUSE_LEAVE: 'mouseleave',
    MOUSE_DOWN: 'mousedown',
    MOUSE_UP: 'mouseup',
    SCROLL: 'scroll',
    SHOWN: 'shown',
    SHOW: 'show',
    HIDE: 'hide',
    HIDDEN: 'hidden',
    FRAMEWORK_INITIALIZED: 'frameworkInitialized',
    WIDTH_FORMAT_CHANGE: "width_format_change",
    INITIALIZE_DATASCRIPTS: "initialize_datascripts",
    SHOW_MESSAGE: 'show_message',
    VALIDATE_FORM: 'validate_form',
    FORM_IS_VALID: 'form_is_valid',
    LOADED: 'loaded'
  };

  $.Messages = {
    FILL_IN_ALL_REQUIRED_FIELDS: "Please fill in all required fields"
  };

  $(function() {
    $.fn.id = function(element_id) {
      if (element_id != null) {
        $(this).attr("id", element_id);
      }
      return $(this).attr("id");
    };
    $.fn.Instantiate = function(settings) {
      var config;
      config = settings;
      return this.each(function(index) {
        var $me, controller_name, controller_names, _i, _instantiateController, _len, _results;
        $me = $(this);
        _instantiateController = function(controller_name) {
          if ($me[controller_name] != null) {
            return $me[controller_name](controller_name, config);
          } else {
            return debug("Couldn't find controller: " + controller_name);
          }
        };
        controller_names = $me.data("script").split(",");
        _results = [];
        for (_i = 0, _len = controller_names.length; _i < _len; _i++) {
          controller_name = controller_names[_i];
          _results.push(_instantiateController(controller_name));
        }
        return _results;
      });
    };
    $.fn.Framework = function(name, defaults) {
      var config, _checkDeviceScreenSizeChange, _init, _initializeDataScripts, _lastLargeScreenSize, _lastMobileSize, _lastiPadSize, _resize, _resizeCallback, _resizeComplete, _scroll, _scrollTimeout, _triggerScrollComplete;
      config = {
        myName: name
      };
      if (defaults != null) {
        jQuery.extend(config, defaults);
      }
      _scrollTimeout = null;
      _lastMobileSize = '';
      _lastiPadSize = '';
      _lastLargeScreenSize = '';
      _init = function() {
        if (config.analyticsEnabled) {
          $.Body.GoogleAnalytics();
        }
        _resize(null, true);
        $(window).on('resize', _resize);
        _initializeDataScripts();
        return trigger($.Events.FRAMEWORK_INITIALIZED, defaults);
      };
      _initializeDataScripts = function(evt) {
        if ($('[data-script]').size() > 0) {
          return $('[data-script]').Instantiate(defaults);
        }
      };
      _resize = function(evt, forceCheckScreenSize) {
        if (forceCheckScreenSize == null) {
          forceCheckScreenSize = false;
        }
        $.Window.windowWidth = $.Window.width();
        $.Window.windowHeight = $.Window.height();
        $.Window.trigger($.Events.RESIZE);
        if (config.checkScreenSizeOn === 'resize' || forceCheckScreenSize) {
          _checkDeviceScreenSizeChange();
        }
        if (config.triggerResizeComplete) {
          clearTimeout(this.resizeTimer);
          return this.resizeTimer = setTimeout(_resizeCallback, 150);
        }
      };
      _checkDeviceScreenSizeChange = function() {
        _lastMobileSize = $.MobileSize;
        _lastiPadSize = $.iPadSize;
        _lastLargeScreenSize = $.LargeScreenSize;
        debug($.Window.windowWidth);
        debug(config.largeScreenWidth);
        if ($.Window.windowWidth >= config.largeScreenWidth) {
          $.MobileSize = false;
          $.iPadSize = false;
          $.LargeScreenSize = true;
        } else if ($.Window.windowWidth <= config.mobileWidth) {
          $.MobileSize = true;
          $.iPadSize = false;
          $.LargeScreenSize = false;
        } else if ($.Window.windowWidth <= config.iPadWidth) {
          $.iPadSize = true;
          $.MobileSize = false;
          $.LargeScreenSize = false;
        } else {
          $.MobileSize = false;
          $.iPadSize = false;
          $.LargeScreenSize = false;
        }
        if ($.MobileSize !== _lastMobileSize || $.iPadSize !== _lastiPadSize || $.LargeScreenSize !== _lastLargeScreenSize) {
          trigger($.Events.WIDTH_FORMAT_CHANGE);
        }
        return debug($.LargeScreenSize);
      };
      _resizeCallback = function() {
        clearTimeout(this.resizeTimer);
        return _resizeComplete();
      };
      _resizeComplete = function() {
        $.Window.windowWidth = $.Window.width();
        $.Window.windowHeight = $.Window.height();
        $.Window.triggerHandler($.Events.RESIZE_COMPLETE);
        if (config.checkScreenSizeOn === 'resizeComplete') {
          return _checkDeviceScreenSizeChange();
        }
      };
      _scroll = function(evt) {};
      _triggerScrollComplete = function() {
        clearTimeout(_scrollTimeout);
        if (send_scroll_complete) {
          return $.Window.triggerHandler($.Events.SCROLL_COMPLETE);
        }
      };
      return _init();
    };
    return $.fn.FormWithRequiredFields = function(objectName, settings) {
      var $parent, config;
      this.settings = settings;
      $parent = $(this);
      if (typeof config === "undefined" || config === null) {
        config = {};
      }
      config.myName = objectName;
      if (this.settings != null) {
        jQuery.extend(config, this.settings);
      }
      return this.each(function(index) {
        var $me, _a_required_field_is_blank, _check_complete, _init, _on_field_blur, _on_form_submit, _required_fields;
        $me = $(this);
        _required_fields = $me.find("input.required, select.required, textfield.required");
        _a_required_field_is_blank = false;
        _init = function() {
          if ($me.data('submitonvalid') === true) {
            register($.Events.SUBMIT, config.myName, _on_form_submit, $me);
          } else {
            register($.Events.VALIDATE_FORM, config.myName, _on_form_submit, $me);
          }
          return register($.Events.BLUR, config.myName, _on_field_blur, _required_fields);
        };
        _on_field_blur = function() {
          if ($(this).val() !== "") {
            return $(this).removeClass("invalid");
          }
        };
        _check_complete = function(field) {
          var the_field;
          the_field = $(field);
          if (the_field.val() === "") {
            _a_required_field_is_blank = true;
            return the_field.addClass("invalid");
          }
        };
        _on_form_submit = function(evt) {
          var field, _i, _len;
          if (evt) {
            evt.preventDefault();
          }
          _a_required_field_is_blank = false;
          for (_i = 0, _len = _required_fields.length; _i < _len; _i++) {
            field = _required_fields[_i];
            _check_complete(field);
          }
          if (_a_required_field_is_blank) {
            return trigger($.Events.SHOW_MESSAGE, $.Messages.FILL_IN_ALL_REQUIRED_FIELDS);
          } else {
            if ($me.data('submitonvalid')) {
              return $me.get(0).submit();
            } else {
              return trigger($.Events.FORM_IS_VALID, null, $me);
            }
          }
        };
        return _init();
      });
    };
  });

  window.debug = function(message, level) {
    if (level == null) {
      level = "debug";
    }
    try {
      if ((window.debug_enabled != null) && (window.console != null) && (console.log != null)) {
        switch (level) {
          case "warn":
            level = 2;
            return console.warn(message);
          case "error":
            level = 3;
            return console.error(message);
          default:
            level = 1;
            return console.log(message);
        }
      }
    } catch (err) {

    }
  };

  window.warn = function(message) {
    return debug(message, 'warn');
  };

  window.throw_error = function(message) {
    return debug(message, 'error');
  };

  window.register = function(eventName, namespace, handler, listenObj) {
    if (listenObj == null) {
      listenObj = jQuery.Window;
    }
    return listenObj.on(eventName + '.' + namespace, handler);
  };

  window.destroy = function(namespace, destroyObj) {
    if (destroyObj == null) {
      destroyObj = jQuery.Window;
    }
    return destroyObj.off('.' + namespace);
  };

  window.trigger = function(eventName, data, triggerObj) {
    if (triggerObj == null) {
      triggerObj = jQuery.Window;
    }
    if (data != null) {
      return triggerObj.triggerHandler(eventName, data);
    } else {
      return triggerObj.triggerHandler(eventName);
    }
  };

  window.px = function(css_pixel_value) {
    try {
      return parseFloat(css_pixel_value) + "px";
    } catch (error) {
      return css_pixel_value;
    }
  };

  /* --------------------------------------------
       Begin site.js.coffee
  --------------------------------------------
  */


  $.ApplicationName = 'JiffyworksApplication';

  window.debug_enabled = true;

  $.CustomEvents = {
    SITE_INITIALIZED: "site_initialized",
    ORDER_CREATED: 'order_created',
    ITEM_ADDED_TO_ORDER: 'item_added_to_order',
    SUBMIT_ORDER: 'submit_order',
    ORDER_ITEM_ADDED: 'order_item_added',
    ORDER_ITEM_UPDATED: 'order_item_updated',
    SAVE_ORDER: 'save_order',
    ORDER_ITEM_ROW_ADDED: 'order_item_row_added'
  };

  $.CustomMessages = window.custom_defaults = $(function() {
    return $.fn.Site = function(objectName, settings) {
      var $parent, config;
      this.settings = settings;
      $parent = $(this);
      if (typeof config === "undefined" || config === null) {
        config = {};
      }
      config.myName = objectName;
      if (this.settings != null) {
        jQuery.extend(config, this.settings);
      }
      return this.each(function(index) {
        var $me, _init, _init_external_jQuery_objects;
        $me = $(this);
        $me.Framework(objectName, defaults);
        _init_external_jQuery_objects = function() {};
        _init = function() {
          _init_external_jQuery_objects();
          return trigger($.Events.SITE_INITIALIZED);
        };
        return _init();
      });
    };
  });

  _docReady = function(evt) {
    var site;
    if ($.CustomEvents != null) {
      jQuery.extend($.Events, $.CustomEvents);
    }
    if ($.CustomMessages != null) {
      jQuery.extend($.Messages, $.CustomMessages);
    }
    if (window.custom_defaults != null) {
      jQuery.extend(window.defaults, window.custom_defaults);
    }
    return site = $('body').Site($.ApplicationName, defaults);
  };

  $(document).ready(_docReady);

}).call(this);

# JiffyWorks Framework Site JS
#
# Author: Pete Larson <plarson@jiffymedia.com>
# Version: 1.8.0
# Last Modified: 3.31.2014

window.debug_enabled = false
window.send_scroll_complete = false

window.defaults =
  globalJQEasing: 'easeOutCubic'
  mobileWidth: 640
  iPadWidth: 768

$ = jQuery

window.when_i_hear = (event_name,listen_obj,handler) ->
  listen_obj.on(event_name,handler)

window.when_i_feel = (event_name,listen_obj,handler) ->
  window.when_i_hear(event_name,listen_obj,handler)

window.when_i = (event_name,listen_obj,handler) ->
  window.when_i_hear(event_name,listen_obj,handler)

window.when_there_is = (event_name,handler) ->
  jQuery.Window.on(event_name,handler)

window.when_someone_has = (listen_obj,event_name,handler) ->
  listen_obj(event_name,handler)

window.when_someone = (listenObj,event_name,handler) ->
  window.when_someone_has(listenObj,event_name,handler)

# Utility Framework Functions
window.debug = (message,level = "debug") ->
  if window.debug_enabled and console? and console.log?
    if message is null
      console.warn "null"
    else
      switch level
        when "warn"
          console.warn message
        when "error"
          console.error message
        when "info"
          console.info message
        when "table"
          if console.table
            console.table message
          else
            console.log message
        when "dump"
          if console.dir
            console.dir message
          else
            console.log message
        else
          console.log message

debug = window.debug

window.puts = (message,level = "debug") ->
  window.debug(message,level)
        
window.register = (eventName,namespace,handler,listenObj = jQuery(window)) ->
  listenObj.on(eventName+'.'+namespace,handler)

window.listen_to = (eventName,namespace,handler,listenObj = jQuery(window)) ->
  listenObj.on(eventName+'.'+namespace,handler)

window.destroy = (namespace,destroyObj = jQuery.Window) ->
  destroyObj.off('.'+namespace)
  
window.trigger = (eventName,data,triggerObj = jQuery.Window) ->
  if data? then triggerObj.triggerHandler(eventName, data) else triggerObj.triggerHandler(eventName)

window.announce = (eventName,data,triggerObj = jQuery.Window) ->
  if data? then triggerObj.triggerHandler(eventName, data) else triggerObj.triggerHandler(eventName)

window.px = (css_pixel_value) ->
  try 
    return parseFloat(css_pixel_value) + "px"
  catch error
    return css_pixel_value

# Define the events namespace which is "_a"
window._a =
  ESC_PRESS: 'keyEscape'
  ENTER_KEY_PRESS: 'keyEnter'
  ENTER_KEY_PRESSED: 'keyEnter'
  SPACE_KEY_PRESS: 'keySpace'
  SPACE_KEY_PRESSED: 'keySpace'
  UP_KEY_PRESS: 'keyUp'
  UP_KEY_PRESSED: 'keyUp'
  DOWN_KEY_PRESS: 'keyDown'
  DOWN_KEY_PRESSED: 'keyDown'
  RIGHT_KEY_PRESS: 'keyRight'
  RIGHT_KEY_PRESSED: 'keyRight'
  LEFT_KEY_PRESS: 'keyLeft'
  LEFT_KEY_PRESSED: 'keyLeft'
  RESIZE: 'resizeSite'
  RESIZED: 'resizeSite'
  RESIZE_COMPLETION: 'resizeSiteComplete'
  RESIZE_COMPLETED: 'resizeSiteComplete'
  SCROLL_COMPLETION: 'scrollComplete'
  SCROLL_COMPLETED: 'scrollComplete'
  CLICK: 'click'
  CLICKED: 'click'
  TOUCH_START: 'touchstart'
  TOUCH_STARTED: 'touchstart'
  TOUCH_MOVE: "touchmove"
  TOUCH_MOVED: "touchmove"
  TOUCH_END: "touchend"
  TOUCH_ENDED: "touchend"
  CHANGE: 'change'
  CHANGED: 'change'
  SUBMIT: 'submit'
  SUBMITED: 'submit'
  FOCUS: 'focus'
  FOCUSED: 'focus'
  BLUR: 'blur'
  BLURED: 'blur'
  MOUSE_OVER: 'mouseover'
  MOUSED_OVER: 'mouseover'
  MOUSE_OUT: 'mouseout'
  MOUSED_OUT: 'mouseout'
  MOUSE_ENTER: 'mouseenter'
  MOUSED_ENTER: 'mouseenter'
  MOUSE_LEAVE: 'mouseleave'
  MOUSE_LEFT: 'mouseleave'
  MOUSE_DOWN: 'mousedown'
  MOUSED_DOWN: 'mousedown'
  MOUSE_UP: 'mouseup'
  MOUSED_UP: 'mouseup'
  SCROLL: 'scroll'
  SCROLLED: 'scroll'
  SHOWN: 'shown'
  SHOW: 'show'
  HIDE: 'hide'
  HIDDEN: 'hidden'
  INSTANTIATED_FRAMEWORK: 'frameworkInstantiated'
  WIDTH_FORMAT_CHANGE: "width_format_change"
  WIDTH_FORMAT_CHANGED: "width_format_change"
  INITIALIZE_DATASCRIPTS: "initialize_datascripts"
  DATASCRIPTS_INITIALIZED: "initialize_datascripts"
  SHOW_MESSAGE: 'show_message'
  MESSAGE_SHOWN: 'show_message'
  VALIDATE_FORM: 'validate_form'
  FORM_VALIDATED: 'validate_form'
  VALID_FORM: 'form_is_valid'

# Map the new events collection to the legacy namespace
$.Events = window._a

if TweenLite?
  defaults.globalEasing = Cubic.easeOut

$.Body = $('body')
debug "dollar sign"
debug $
if $(window)
  $.Window = $(window)
else
  $.Window = $(document)
# if ($.browser.mozilla? or $.browser.msie?) then $.Scroll = $('html') else $.Scroll = $.Body
$.Scroll = $.Body

$.MobileWebkit = ($.Body.hasClass('webkit-mobile') or (navigator.userAgent.match(/iPhone/i)) or (navigator.userAgent.match(/iPod/i)) or (navigator.userAgent.match(/iPad/i)))
$.MobileDevice = ((navigator.userAgent.match(/iPhone/i)) or (navigator.userAgent.match(/iPod/i)) or (navigator.userAgent.match(/Android/i)))
$.Tablet = ((navigator.userAgent.match(/iPad/i)))

$.Messages = 
  FILL_IN_ALL_REQUIRED_FIELDS: "Please fill in all required fields"

$ ->
  #shortcut to setting the id of an element
  $.fn.id = (element_id) ->
    if element_id? then $(this).attr("id",element_id)
    return $(this).attr("id")

  #You can use the data-script attribute to instantiate an object
  #  If you want multiple objects on the same html element, you can separate
  #  the controller names by commas
  $.fn.Instantiate = (settings) ->
    config = settings

    this.each (index) ->
      $me = $(this)
      _instantiateController = (controller_name) ->
        if $me[controller_name]?
          $me[controller_name](controller_name,config) 
        else
          debug "Couldn't find controller: " + controller_name

        
      controller_names = $me.data("script").split(",")
      _instantiateController controller_name for controller_name in controller_names
  
  $.fn.Framework = (name,defaults) ->
    #Initialize
    config = 
        myName: name
      if defaults? then jQuery.extend(config, defaults)
    
    #Private Functions
    _scrollTimeout = null
    _init = () ->
      register(_a.INITIALIZE_DATASCRIPTS,config.myName,_initializeDataScripts)
      #set up the google analytics class. This call needs to be reworked
      if config.analyticsEnabled then $.Body.GoogleAnalytics()
      _resize()
      # register(_a.SCROLL,name,_scroll)
      $(window).on('resize',_resize)
      # send out the event that the framework has been instantiated
      trigger(_a.INSTANTIATED_FRAMEWORK,defaults)
    _initializeDataScripts = (evt) ->
      #Instantiate any objects with the "data-script" attribute
      if $('[data-script]').size() > 0 then $('[data-script]').Instantiate(defaults)
    _resize = (evt) ->
      try
        $.Window.windowWidth = $.Window.width()
        $.Window.windowHeight = $.Window.height()
      catch err
        debug "try catch error"
        alert("couldn't get window width")
        alert($.Window)
      finally
        debug "finally portion"
      
      $.Window.trigger(_a.RESIZE)
      clearTimeout(resizeTimer)
      resizeTimer = setTimeout(_resizeCallback,150);
      
    _resizeCallback = ->
      clearTimeout(@resizeTimer);
      _resizeComplete();
      
    _resizeComplete = ->
      $.Window.windowWidth = $.Window.width()
      $.Window.windowHeight = $.Window.height()
      $.Window.triggerHandler(_a.RESIZE_COMPLETION)

    _init()

  $.fn.announce = (event_name,data) ->
    if data? then $(this).triggerHandler(event_name, data) else $(this).triggerHandler(event_name)

  $.fn.respond_to = (event_name,handler) ->
    $(this).on(event_name,handler)

  $.fn.hear = (event_name,handler) ->
    $(this).on(event_name,handler)

  $.fn.hears = (event_name,handler) ->
    $(this).on(event_name,handler)

  $.fn.FormWithRequiredFields = (objectName,@settings) ->
    $parent = $(this)

    if not config? then config = {}
    config.myName = objectName
    if @settings? then jQuery.extend(config, @settings)

    this.each (index) ->
      $me = $(this)
      _required_fields = $me.find("input.required, select.required, textfield.required")
      _a_required_field_is_blank = false

      _init = () ->
        if $me.data('submitonvalid') == true
          register(_a.SUBMIT,config.myName,_on_form_submit,$me)
        else
          register(_a.VALIDATE_FORM,config.myName,_on_form_submit,$me)

        register(_a.BLUR,config.myName,_on_field_blur,_required_fields)
        # register(_a.SUBMIT,config.myName,_on_form_submit,$me)

      _on_field_blur = () ->
        if $(this).val() != ""
          $(this).removeClass("invalid")

      _check_complete = (field) ->
        the_field = $(field)
        if the_field.val() is ""
          _a_required_field_is_blank = true
          the_field.addClass("invalid")
        
      _on_form_submit = (evt) ->
        if evt then evt.preventDefault()
        
        _a_required_field_is_blank = false
        
        _check_complete field for field in _required_fields

        if _a_required_field_is_blank
          trigger(_a.SHOW_MESSAGE,$.Messages.FILL_IN_ALL_REQUIRED_FIELDS)
        else
          if $me.data('submitonvalid')
            $me.get(0).submit()
          else
            trigger(_a.FORM_IS_VALID,null,$me)

      _init()
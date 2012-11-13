$ = jQuery

sendScrollComplete = true

window.debug_enabled = true

root = this

# DEFAULT CONFIG VALUES
defaults =
  globalEasing: Cubic.easeOut
  globalJQEasing: 'easeOutCubic'
  analyticsEnabled: false
  fadeInDuration: .4
  fullAnimation: true
  dashboardIntroEasing: Cubic.easeOut
  timescale: .5
  updateRemoteFormOnBlur: false
  flashNoticeSlideDownDuration: .5
  flashNoticeOpenDuration: 4
  flashNoticeOpenDelay: 1
  flashNoticeSlideDownEasing: Cubic.easeOut
  
# The JiffyWorks Framework: A total ripoff from Ian Coyle
# 
# Author: Pete Larson <plarson@jiffymedia.com>
# Version: 1.0.0
# Last Modified: 06.17.2012

# UI Objects 
$.Body = $('body')
$.Window = $(window)
if ($.browser.mozilla? or $.browser.msie?) then $.Scroll = $('html') else $.Scroll = $.Body;

$.MobileWebkit = ($.Body.hasClass('webkit-mobile') or (navigator.userAgent.match(/iPhone/i)) or (navigator.userAgent.match(/iPod/i)) or (navigator.userAgent.match(/iPad/i)))
$.MobileDevice = ((navigator.userAgent.match(/iPhone/i)) or (navigator.userAgent.match(/iPod/i)) or (navigator.userAgent.match(/Android/i)))
$.Tablet = ((navigator.userAgent.match(/iPad/i)))

$.Events = 
    KEY_ESC: 'keyEscape'
    KEY_ENTER: 'keyEnter'
    KEY_SPACE: 'keySpace'
    KEY_UP: 'keyUp'
    KEY_DOWN: 'keyDown'
    KEY_RIGHT: 'keyRight'
    KEY_LEFT: 'keyLeft'
    RESIZE: 'resizeSite'
    RESIZE_COMPLETE: 'resizeSiteComplete'
    SCROLL_COMPLETE: 'scrollComplete'
    CLICK: 'click'
    CHANGE: 'change'
    SUBMIT: 'submit'
    FOCUS: 'focus'
    BLUR: 'blur'
    BEFORE_SUBMIT: 'beforeSubmit'
    MOUSE_OVER: 'mouseover'
    MOUSE_OUT: 'mouseout'
    MOUSE_ENTER: 'mouseenter'
    MOUSE_LEAVE: 'mouseleave'
    MOUSE_DOWN: 'mousedown'
    MOUSE_UP: 'mouseup'
    SCROLL: 'scroll'
    SHOW_OVERLAY: 'showOverlay'
    REMOVE: 'remove'
    REMOVE_CONFIRM: 'removeConfirm'
    REMOTE_DATA_RETURNED: 'remoteDataReturned'
    ACTIVATE_GROUP_ELEMENT: 'activateGroupElement'
    SHOW_HIDE: 'showHide'
    EXPANDED: 'expanded'
    EXPAND_ALL: 'expandAll'
    CONTRACT_ALL: 'contractAll'
    NEXT_PAGE: 'nextPage'
    PREV_PAGE: 'prevPage'
    HEIGHT_CHANGE: 'heightChange'
    GROW_ANIMATION_COMPLETE: 'growAnimationComplete'
    REMOTE_FORM_VALUE_UPDATED: 'yourNumberUpdated'
    FORM_SUBMISSION_SUCCESSFUL: 'formSubmissionSuccessful'
    YOUR_BOOK_UPDATED: 'yourbookupdated'
    LARGE_BAR_ANIMATED: 'largeBarAnimated'
    OPEN_YOUR_BOOK: 'openYourBook'
$ ->
  #You can use the data-script attribute to instantiate an object
  #  If you want multiple objects on the same html element, you can separate
  #  the controller names by commas
  $.fn.Instantiate = (settings) ->
    config = settings

    this.each (index) ->
      $me = $(this)
      _instantiateController = (controller_name) ->
        $me[controller_name](controller_name,config) if $me[controller_name]?
        
      controller_names = $me.data("script").split(",")
      _instantiateController controller_name for controller_name in controller_names
      
  $.fn.ObjBase = ->
  
  #shortcut to setting the id of an element
  $.fn.id = (element_id) ->
    if element_id? then $(this).attr("id",element_id)
    return $(this).attr("id")
  
  $.fn.Site = (@name,defaults) ->
    #Initialize
    config = 
        parentName: @name
    $(this).ObjBase()
    
    #Private Functions
    _scrollTimeout = null
    _init = () ->
      #Instantiate any objects with the "data-script" attribute
      if $('[data-script]').size() > 0 then $('[data-script]').Instantiate(defaults)
      
      #set up the google analytics class. This call needs to be reworked
      if config.analyticsEnabled then $.Body.GoogleAnalytics()
      
      register($.Events.SCROLL,@name,_scroll)
      $(window).on('resize',_resize)
      #Dropkick Select Styling initialization
      $('select').dropkick({
        theme : 'gray',
        startSpeed: 0
      })
    _resize = (evt) ->
      $.Window.windowWidth = $.Window.width()
      $.Window.windowHeight = $.Window.height()
      $.Window.trigger($.Events.RESIZE)
      clearTimeout(@resizeTimer)
      _resizeCallback = ->
        clearTimeout(@resizeTimer);
        _resizeComplete();
      @resizeTimer = setTimeout(_resizeCallback,150);
      
    _resizeComplete = ->
      $.Window.windowWidth = $.Window.width()
      $.Window.windowHeight = $.Window.height()
      $.Window.triggerHandler($.Events.RESIZE_COMPLETE)
    
    _scroll = (evt) ->
      if($.MobileDevice or $.Tablet) then return
      if(not sendScrollComplete?) then evt.preventDefault();
      scrollDistance = Math.abs($.Window.scrollTop() - lastScrollTop)
      scrollSpeed = (scrollDistance/$.Body.height())*50000
      if (lastScrollTop < $.Window.scrollTop()) then scrollDirection = 1 else scrollDirection = -1
      if(lastScrollTop is $.Window.scrollTop()) then scrollDirection = 0
      lastScrollTop = $.Window.scrollTop()
      clearTimeout(_scrollTimeout)
      _scrollTimeout = setTimeout(_triggerScrollComplete,300)
      
    _triggerScrollComplete = ->
      clearTimeout(_scrollTimeout)
      if(sendScrollComplete) then $.Window.triggerHandler($.Events.SCROLL_COMPLETE)
      
    # responds to "SHOW_OVERLAY" creating an overlay
    #   the overlay template needs to be defined in the form
    #   a hidden div with an id of "overlay-template" 
    _createOverlay = (evt,message,unique_name) ->
      _overlayElement = $('#overlay-template').clone()
      _overlayElement.id(name)
      $.Body.append(_overlayElement)

    _init()

  $.fn.FlashNotice = (objectName,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
  
    if not config? then config = {}
    config.myName = objectName
    if @settings? then jQuery.extend(config, @settings)
  
    this.each (index) ->
      $me = $(this)
      _init = () ->
        timeline = new TimelineLite()
        #add the timeline animations
        timeline.append( TweenLite.to($me,config.flashNoticeSlideDownDuration,{ease:config.flashNoticeSlideDownEasing,css:{top:0}}), config.flashNoticeOpenDelay )
        timeline.append( TweenLite.to($me,config.flashNoticeSlideDownDuration,{ease:config.flashNoticeSlideDownEasing,css:{top:'-55px'}}), config.flashNoticeOpenDuration )

      _init()
    
  $.fn.Popover = (@name,@settings) ->
    #add the object base functionality
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _init = () ->
        #$me.on($.Events.MOUSE_OVER,_onRollover)
        $me.popover();
        #$me.on($.Events.MOUSE_OUT,_onRollout)
      _onRollover = () ->
        #$me.popover('show');
      _onRollout = () ->
        #$me.popover('hide');
      _init();
      
  # Any remove button (has a class "remove") dispatches a
  # REMOVE_CONFIRM event on click
  $.fn.RemoveButton = (@name,@settings) ->
    #add the object base functionality
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      message = $me.attr("data-message");
      
      #Functions
      _init = ->
        register($.Events.CLICK,@name,_onClick,$me);
        
      _onClick = ->
        trigger($.Events.REMOVE_CONFIRM,[message]);
        
      _init()
      
  # Souped-up input Object
  $.fn.NumberInput = (@name,@settings) ->
    #add the object base functionality
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _dataType = $me.attr("data-format")
      _label = ""
      
      #Functions  
      _onFocus = () ->
        $me.val( Math.floor(cleanNumber($me.val())) )
        
      _onBlur = () ->
        if _dataType == "currency"
          $me.val( _label + formatCurrency( cleanNumber($me.val()),false ) )
        else
          $me.val( _label + Math.floor(cleanNumber($me.val())) )
      _beforeSubmit = () ->
          $me.val( Math.floor(cleanNumber($me.val())) )
        
      _init = ->
        if($me.attr("placeholder")) then _label = $me.attr("placeholder") + " : "
        $me.on($.Events.BLUR,_onBlur)
        $me.on($.Events.FOCUS,_onFocus)
        $me.on($.Events.BEFORE_SUBMIT,_beforeSubmit)
        _onBlur()
      _init()
      
  $.fn.YourScoreForm = (@name,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _onSubmitSuccess = (data) ->
        debug("_onSubmitSuccess")
        $me.find("input[data-format=currency]").each () ->
          $(this).val( formatCurrency($(this).val()) )
        $me.find(".answer").html(formatCurrency(data,false))
        $('#your-number-modal').modal('hide')
      _onSubmitError = () ->
        debug("submit error")
        evt.preventDefault()
        evt.stopPropagation()
      _onSubmit = (evt) ->
        evt.preventDefault()
        evt.stopPropagation()
        debug("onsubmit")
        $me.find("input[type=text]").each () ->
          $(this).val( cleanNumber($(this).val()) )
        $.ajax({  
          type: "POST"
          data: $me.serialize()
          url: $me.attr("action")
          success: _onSubmitSuccess
          error: _onSubmitError
        })
      _onCalculateSuccess = (data) ->
        $me.find("input[data-format=currency]").each () ->
          $(this).val( formatCurrency($(this).val()) )
        $me.find(".answer").html(formatCurrency(data,false))
      _onCalculateError = () ->
        debug("error")
      _calculateYourNumber = () ->
        $me.find("input[type=text]").each () ->
          $(this).val( cleanNumber($(this).val()) )
        $.ajax({  
          type: "POST"
          data: $me.serialize()
          url: $me.attr("data-update-action")
          success: _onCalculateSuccess
          error: _onCalculateError
        })
      _updateValues = () ->
        debug("updating values")
        $me.find('.live-value').each () ->
          newValue = cleanNumber($("#"+$(this).attr("rel")).val())
          if newValue == '' then newValue = '&nbsp;'
          $(this).html(newValue)
        _calculateYourNumber()
      $me.find("input[type=text]").on($.Events.BLUR,_updateValues)
      $me.on($.Events.SUBMIT,_onSubmit)
      $me.find('input[type=submit]').on($.Events.CLICK,_onSubmit)

  $.fn.CompanyNumber = (objectName,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
  
    if not config? then config = {}
    config.myName = objectName
    if @settings? then jQuery.extend(config, @settings)
  
    this.each (index) ->
      $me = $(this)
      _associatedForm = $me.attr("rel")

      _init = () ->
        register($.Events.YOUR_BOOK_UPDATED,config.myName,_valueUpdated)

      _valueUpdated = (evt,calcs) ->
        if calcs['your_number']
          $me.html(formatCurrency(calcs['your_number'].toString(),false))

      _init()

  $.fn.CompanyValue = (objectName,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
  
    if not config? then config = {}
    config.myName = objectName
    if @settings? then jQuery.extend(config, @settings)
  
    this.each (index) ->
      $me = $(this)
      _associatedForm = $me.attr("rel")

      _init = () ->
        register($.Events.YOUR_BOOK_UPDATED,config.myName,_valueUpdated)

      _valueUpdated = (evt,calcs) ->
        #$me.html(formatCurrency(calcs['your_number'].toString(),false))

      _init()

  $.fn.BBIScore = (objectName,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
  
    if not config? then config = {}
    config.myName = objectName
    if @settings? then jQuery.extend(config, @settings)
  
    this.each (index) ->
      $me = $(this)
      _associatedForm = $me.attr("rel")

      _init = () ->
        register($.Events.YOUR_BOOK_UPDATED,config.myName,_valueUpdated)

      _valueUpdated = (evt,calcs) ->
        #$me.html(formatCurrency(calcs['your_number'].toString(),false))

      _init()
      
  $.fn.RemoteForm = (myName,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _init = () ->
        debug("RemoteForm: "+$me.attr("id"))
        $me.on($.Events.SUBMIT,_onSubmit)
      _onSuccess = (data) ->
        $me.triggerHandler($.Events.FORM_SUBMISSION_SUCCESSFUL,data)
        if $me.attr("data-close-overlay-onsubmit") 
          #trigger($.Events.CLOSE_OVERLAY,$me.attr("data-close-overlay-onsubmit"))
          $me.parents('.modal').eq(0).modal('hide')
      _onError = () ->
        debug("error submitting the form")
      _onSubmit = (evt) ->
        evt.preventDefault()
        $.ajax({  
          type: "POST"
          url: $me.attr("action")
          data: $me.serialize()
          dataType: "html"
          success: _onSuccess
          error: _onError
        })
      _init()
      
  $.fn.RemoteCalculateForm = (@name,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    config.myName = @name
    
    this.each (index) ->
      $me = $(this)
      _textInputFields = $me.find('input[type=text]')
      _submitButton = $me.find('input[type=submit]')
      _valueName = $me.attr("id")
      _valueData = 0
      _onSubmitSuccess = (data) ->
        trigger($.Events.YOUR_BOOK_UPDATED,data)
        $me.find(".answer").html(formatCurrency(data,false))
        $me.parents('.modal').eq(0).modal('hide')
      _onSubmitError = (evt, jqXHR, ajaxSettings, thrownError) ->
        debug("submit error")
        debug(thrownError)
      _onSubmit = (evt) ->
        evt.preventDefault()
        evt.stopPropagation()
        myDataType = "json"

        $.ajax({  
          type: "POST"
          data: $me.serialize()
          dataType: "json"
          url: $me.attr("action")
          success: _onSubmitSuccess
          error: _onSubmitError
        })
      _onCalculateSuccess = (data) ->
        _valueData = data
        data = formatValue(data,$me.find(".answer").data('format'),false)
        $me.find(".answer").html(data)
      _onCalculateError = () ->
        debug("error")
      _calculate = () ->
        $.ajax({  
          type: "POST"
          data: $me.serialize()
          url: $me.attr("data-update-action")
          success: _onCalculateSuccess
          error: _onCalculateError
        })
      _updateValues = (evt) ->
        $me.find('.live-value').each () ->
          inputElement = $("#"+$me.attr('id')+" #"+$(this).attr("rel"))
          inputValue = inputElement.val()
          if $("#"+$(this).attr("rel")).attr("data-format") == "currency"
            inputValue = formatCurrency(inputValue)
          newValue = inputValue.replace($("#"+$(this).attr("rel")).attr("placeholder")+" : ","")
          if newValue == '' then newValue = '&nbsp;'
          $(this).html( newValue )
        if(evt != null) then _calculate()
      _init = () ->
        register($.Events.SUBMIT,config.myName,_onSubmit,$me)
        register($.Events.CLICK,config.myName,_onSubmit,_submitButton)
        register($.Events.BLUR,config.myName,_updateValues,_textInputFields)
        #_textInputFields.NumberInput("NumberInput",config)

        #Save form values on each form blur: Depends on the config var set
        #if config.updateRemoteFormOnBlur
        #  register($.Events.BLUR,config.myName,_updateValues,_textInputFields)

        _updateValues(null)
      _init()
      
  $.fn.SelectGroupDropdown = (@name,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    config.myName = @name
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _open = false
      _init = () ->
        register($.Events.CLICK,config.myName,_onClick,$me)
        register($.Events.CLICK,config.myName,_onClickOutside)
      _onClick = (evt) ->
        evt.preventDefault()
        evt.stopPropagation()
        if _open and $(evt.target).eq(0).attr('id') == 'select-group-dropdown'
          _close()
        else
          $('#select-group-dropdown').show()
          _open = true
      _close = () ->
        $('#select-group-dropdown').hide()
        _open = false
      _onClickOutside = (evt) ->
        if($me.css("display") != "none")
          if _open and $me.has($(evt.target)).size() == 0 and $(evt.target).attr('id') != 'my-groups-nav'
            _close()
      _init()

  $.fn.YourBook = (@name,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    config.myName = @name

    this.each (index) ->
      $me = $(this)
      _open = false
      _init = () ->
        register($.Events.SUBMIT,config.myName,_onSubmit,$me.find("form"))
        register($.Events.CLICK,config.myName,_onClick,$me)
        register($.Events.CLICK,config.myName,_onClickOutside)
        register($.Events.CLICK,config.myName,_close,$('#your-book-dropdown .close-dropdown'))
        register($.Events.OPEN_YOUR_BOOK,config.myName,_openDropdown)
      _onClick = (evt) ->
        evt.stopPropagation()
        if _open and $(evt.target).eq(0).attr('id') == 'your-book-dropdown'
          _close()
        else
          _openDropdown()
      _openDropdown = () ->
        if _open then return
        debug("opening book")
        debug($('#your-book-dropdown'))
        $('#your-book-dropdown').show();
        _open = true;
      _close = () ->
        $('#your-book-dropdown').hide()
        _open = false
      _onClickOutside = (evt) ->
        if($me.css("display") != "none")
          if _open and $me.has($(evt.target)).size() == 0
            _close()
      _onSuccess = (data) ->
        $me.triggerHandler($.Events.FORM_SUBMISSION_SUCCESSFUL,data)
        trigger($.Events.YOUR_BOOK_UPDATED,data)
        _close()

      _onError = () ->
        debug("error submitting the form")
      _onSubmit = (evt) ->
        evt.preventDefault()
        
        $.ajax({  
          type: "POST"
          url: $me.find("form").attr("action")
          data: $me.find("form").serialize()
          dataType: "json"
          success: _onSuccess
          error: _onError
        })

      _init()
      
  $.fn.InputSaveForm = (@name,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _onSuccess = (data) ->
        trigger($.Events.REMOTE_DATA_RETURNED,data,@name)
      _onError = () ->
        debug("on error")
      _saveForm = () ->
        $.ajax({  
          type: "POST"
          url: $me.attr("action")
          data: $me.serialize()
          success: _onSuccess
          error: _onError
        })
      _onInputBlur = () ->
        _saveForm()
      _onSubmit = (evt) ->
        evt.preventDefault()
        evt.stopPropagation()
        _onInputBlur()
      _init = () ->
        $me.find("input").blur(_onInputBlur)
        $me.find("input[data-format=currency]").NumberInput("NumberInput",config)
        $me.find("input[data-format=number]").NumberInput("NumberInput",config)
        $me.find("input[data-format=percentage]").NumberInput("NumberInput",config)
        $me.on($.Events.SUBMIT,_onSubmit)
      _init()
      
  $.fn.ForgotPasswordForm = (@name,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _onSuccess = (data) ->
        debug("_onSuccess")
        $('#forgot-password-modal').modal('hide')
        trigger($.Events.REMOTE_DATA_RETURNED,data,$me)
      _onError = () ->
        debug("on error")
      _onSubmit = (evt) ->
        evt.preventDefault()
        evt.stopPropagation()
        debug(evt)
        $.ajax({  
          type: "POST"
          url: $(this).attr("action")
          data: $(this).serialize()
          success: _onSuccess
          error: _onError
        })
        
      $(this).on($.Events.SUBMIT,_onSubmit)
      
  $.fn.ForgotPasswordResponse = (@name,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _onDataResponse = (evt,message) ->
        $me.find('#forgot-password-message').html(message)
        $me.modal()
      register($.Events.REMOTE_DATA_RETURNED,@name,_onDataResponse,$("#reset_password_form"))
      
  $.fn.HowThisWorks = (objectName,@settings) ->
      $(this).ObjBase()
      $parent = $(this)
    
      if not config? then config = {}
      config.myName = objectName
      config.howThisWorksOpenDuration = .2
      if @settings? then jQuery.extend(config, @settings)
    
      this.each (index) ->
        $me = $(this)
        _fullHeight = $me.height()
        _expandedView = $me.find(".expanded-view")
        _hiddenStepsComplete = $me.find(".steps-complete-expanded")
        _init = () ->
          $me.find(".container").on($.Events.CLICK,_onClick)
          $me.find(".show-hide").on($.Events.SHOW_HIDE,_onShowHide)
          $me.css({overflow:"hidden",height:px(_fullHeight)})
          _expandedView.css({overflow:"hidden",height:px(_fullHeight)})
          hideMe = $.cookie('how_this_works_hidden')
          if(hideMe == 'true') then _initializeHidden()
        _initializeHidden = () ->
          _hiddenStepsComplete.css("display","block")
          _expandedView.css({height:"0px"})
          $me.css({height:"50px"})
          debug($('.show-hide[rel='+$me.attr("id")+']'))
          show_hide_button = $('.show-hide[rel='+$me.attr("id")+']')
          show_hide_button.addClass("hidden")
          show_hide_button.html("SHOW")
          _onHideComplete()
        _onShowHide = (evt,shown) ->
          if shown
            $.cookie('how_this_works_hidden','false')
            $me.addClass("expanded")
            _expandedView.height(_fullHeight)
            _hiddenStepsComplete.css("display","none")
            TweenLite.to(_expandedView,config.howThisWorksOpenDuration,{css:{height:px(_fullHeight)}})
            TweenLite.to($me,config.howThisWorksOpenDuration,{css:{height:px(_fullHeight)},ease:config.globalEasing})
          else
            $.cookie('how_this_works_hidden','true')
            _hiddenStepsComplete.css("display","block")
            TweenLite.to(_expandedView,config.howThisWorksOpenDuration,{css:{height:"0px"},ease:config.globalEasing})
            TweenLite.to($me,config.howThisWorksOpenDuration,{css:{height:"50px"},ease:config.globalEasing,onComplete:_onHideComplete})
          
        _onHideComplete = () ->
          $me.removeClass("expanded")
        _onClick = (evt) ->
          if $('#your-book-dropdown').css("display") == "none"
            evt.preventDefault()
            evt.stopPropagation()
          if !$(evt.target).hasClass("show-hide")
            trigger($.Events.OPEN_YOUR_BOOK)
        _init()
      
  $.fn.ShowHideButton = (@name,@settings) ->
    $(this).ObjBase()
    $parent = $(this)
    
    if not config? then config = {}
    if @settings? then jQuery.extend(config, @settings)
    
    this.each (index) ->
      $me = $(this)
      _relatedContainer = $me.attr("rel")
      
      _init = () ->
        $me.on($.Events.CLICK,_click)

      _click = (evt) ->
        if $me.html() == "HIDE"
          $me.html("SHOW")
        else
          $me.html("HIDE")
          
        $me.toggleClass("hidden")
        trigger($.Events.SHOW_HIDE,!$me.hasClass("hidden"),$me)
        
      _init()

  
      
  
  #Instantiate the site
  site = $('body').Site("Site",defaults) 

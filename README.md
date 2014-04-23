JiffyWorks
==========
##Pete Larson's javascript framework.
This is a port of an original framework developed by Ian Coyle which I have developed further. The aim of this framework is to provide a structure for javascript (coffeescript) on a web site that is event-based, simple, and flexible.

##The core concepts of the framework are:

* JS code is always associated with a DOM element. This has a very loose MVC concept that keeps thing organized so you don't have to hunt all around your code saying "who's making that thing disappear?"
* Everything is a jQuery plugin. This just makes it easy to associate with a DOM element.
* Communication and control is done largely through events. Most of what you will be doing with this framework is setting up broadcasts and responses. Here are a few examples:

        $I.respond_to _a.CLICK, hide_the_navbar

        hide_the_navbar = (evt) ->
          announce _a.NAVBAR_WAS_HIDDEN

To add an event listener (an object gets notified when an event happens):

        responding_object.respond_to EVENT_NAME, handler_function

To announce or broadcast an event, you can either announce the event in general (to everyone) or you can announce it just on a particular object:

        announce EVENT_NAME, data_passed_with_the_announcement (data can be any type: string, object, number)
        announcing_object.announce EVENT_NAME, data_passed_with_the_announcement

Event Names:
        Event names should be stored as constants in the _a object. Some of these are built into the framework. Others you can add to by adding them to the $.CustomEvents namespace. These will be incorporated into the _a namespace.

Built-In Event Names (note, some of these are repeated but are named in the past tense if you'd like your code to be more semantic):

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

##How to use it:
Included in this repository is the core framework file: jiffyworks.coffee.js. YOU MUST prepend this framework to your coffeescript file. If appended, it won't work. Also included is a site.coffee.js file which you can use as an empty template for setting up the framework. Sublime snippets are also provided to make developing with this framework much faster

##Your site.coffee file
Your site.coffee should have the following at the beginning of the file:
        &#35Set this to false for production
        window.debug_enabled = true

        $.CustomEvents =
	    CUSTOM_EVENT_NAME: "custom_event_string"

Make sure to have a Site object with the following:
        $.fn.Site = (objectName,@settings) ->
		$parent = $(this)

		if not config? then config = {}
		config.myName = objectName
		if @settings? then jQuery.extend(config, @settings)

		this.each (index) ->
			$me = $(this)
			
			_init = () ->
				register($.Events.RESIZE,config.myName,_resize)
				_resize()
				trigger($.Events.INITIALIZE_DATASCRIPTS)
                                debug("Initiating: " + config.myName)
				debug("Defaults:")
				debug(config)

                                _initialize_plugins()

                        _initialize_plugins = () ->
                                Initialize external jquery plugins here

                        _init()

Your site.coffee should have the following at the end of the file:

        _docReady = (evt) ->
	    if $.CustomEvents? then jQuery.extend($.Events, $.CustomEvents)
	    if $.CustomMessages? then jQuery.extend($.Messages, $.CustomMessages)
	    if window.custom_defaults? then jQuery.extend(window.defaults, window.custom_defaults)

	    framework = $('body').Framework("Add A Name For Your Site",defaults) 
	    site = $('body').Site("Add a Name For Your Site",defaults)

        $(document).ready(_docReady)



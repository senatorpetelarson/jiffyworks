# OVERWRITE THIS!
$.ApplicationName = 'JiffyworksApplication'

# Turns debugging on. Turn this off for a deployed application.
# To use debugging, use the debug function:
# debug "my string" or debug my_variable
# you can also use 'warn' to display a warning or 'throw_error' to
# display an error. i.e. throw_error "oh my word, this things gonna blow!"
window.debug_enabled = true

# Add your own custom events here. These will be added to $.Events by the framework
# Do not access $.CustomEvents directly
$.CustomEvents =
	SITE_INITIALIZED: "site_initialized"
	ORDER_CREATED: 'order_created'
	ITEM_ADDED_TO_ORDER: 'item_added_to_order'
	SUBMIT_ORDER: 'submit_order'
	ORDER_ITEM_ADDED: 'order_item_added'
	ORDER_ITEM_UPDATED: 'order_item_updated'
	SAVE_ORDER: 'save_order'
	ORDER_ITEM_ROW_ADDED: 'order_item_row_added'

# Use this to override or add custom messages to the system. The framework will
# automatically add this to $.Messages so don't call $.CustomMessages directly
$.CustomMessages = 

# Use this to add custom defaults which end up in the config object passed down to
# all the objects in the system (that are called with the data-script method). To
# make sure these defaults get in objects that you call via Javascript, you'll need
# to make sure to pass in config from the parent you are calling from. Again, do not
# call custom_defaults directly. When the site object is instantiated, these get
# added to the object's config object so make sure to use that
window.custom_defaults =
	

$ ->
	$.fn.Site = (objectName,@settings) ->
		$parent = $(this)

		if not config? then config = {}
		config.myName = objectName
		if @settings? then jQuery.extend(config, @settings)

		this.each (index) ->
			$me = $(this)
			$me.Framework(objectName,defaults)

			# instantiate any external jQuery plugins here
			_init_external_jQuery_objects = () ->
			
			_init = () ->
				_init_external_jQuery_objects()
				trigger($.Events.SITE_INITIALIZED)

			_init()

	# Following is a sample framework object. This is usually
	# called by putting a data-script="ObjectName" attribute on 
	# the tag of the dom element you'd like to call this on. I
	# recommend making yourself a snippet to out of this.
	# 
	# You pass in an objectName and the settings object from
	# the parent if you're going to instantiate this in javascript.
	# "Why the name" you say? It has to do with registering and
	# de-registering objects. You can use the object name to 
	# deregister a whole set of events from an object. I need to
	# add destroy capabilities into the framework in the future.
	# 
	# BTW: You can add multiple objects to a dom element by 
	#      using multiple object names separated by commas. (i.e.
	# 	   data-script="ObjectName,AnotherObjectName"

	#######################################################	
	# $.fn.ObjectName = (objectName,settings) ->
	# 	$parent = $(this)
	
	# 	if not config? then config = {}
	# 	config.myName = objectName
	# 	if @settings? then jQuery.extend(config, settings)
	
	# 	this.each (index) ->
	#   	$me = $(this)
	
	#   	_init = () ->
	  		
	#   	_init()
	#######################################################

# This is what kicks everything off. The only thing you need to make
# sure is that you've set the application name in $.ApplicationName above
_docReady = (evt) ->
	if $.CustomEvents? then jQuery.extend($.Events, $.CustomEvents)
	if $.CustomMessages? then jQuery.extend($.Messages, $.CustomMessages)
	if window.custom_defaults? then jQuery.extend(window.defaults, window.custom_defaults)

	site = $('body').Site($.ApplicationName,defaults)

$(document).ready(_docReady)
window.debug = (message,level = "debug") ->
	if console.log? and window.debug_enabled
  	switch level
  		when "warn"
  			level = 2
  			console.warn message
  		when "error"
  			level = 3
  			console.error message
  		else
  			level = 1
  			console.log message
  			
window.register = (eventName,namespace,handler,listenObj = jQuery.Window) ->
  listenObj.on(eventName+'.'+namespace,handler);
  
window.trigger = (eventName,data,triggerObj = jQuery.Window) ->
  if data? then triggerObj.triggerHandler(eventName, data) else triggerObj.triggerHandler(eventName)

$ -> 
  #overwrite jquery fadeIn function to use TweenLite    
  $.fn.fadeIn = (duration,easing=Power1.easeOut,completeFunction=null) ->
    TweenLite.to($(this),0,{css:{autoAlpha:0}})
    if($(this).css("display")=="none")
      $(this).css("display","block")
    tweenObj = {css:{autoAlpha:1},ease:easing}
    if completeFunction != null
      tweenObj.onComplete = completeFunction
    return TweenLite.to($(this),duration,tweenObj)
    
  $.fn.fadeTo = (duration,toAlpha,easing=Power1.easeOut,completeFunction=null) ->
    $el = $(this)
    _onFadeOutComplete = () ->
      $el.css("display","none")
      if completeFunction != null then completeFunction.call(this)
    if $(this).css("display")=="none"
      TweenLite.to($(this),0,{css:{autoAlpha:0}})
      $(this).css("display","block")
    tweenObj = {css:{autoAlpha:toAlpha},ease:easing}
    if toAlpha == 0
      tweenObj.onComplete = _onFadeOutComplete
    else 
      if completeFunction != null then tweenObj.onComplete = completeFunction
    TweenLite.to($(this),duration,tweenObj)
    
  #overwrite jquery fadeOut function to use TweenLite  
  $.fn.fadeOut = (duration,easing=Power1.easeOut) ->
    $el = $(this)
    _onFadeOutComplete = () ->
      $el.css("display","none")
    TweenLite.to($el,duration,{css:{autoAlpha:1},ease:easing,onComplete:_onFadeOutComplete})
    
  #utility function to grow an object to a certain length (width)  
  $.fn.growWidth = (duration,growWidth,easing=Power1.easeOut,completeFunction=null) ->
    tweenObj = {css:{autoAlpha:1,width:growWidth},ease:easing}
    if completeFunction != null
      tweenObj.onComplete = completeFunction
    TweenLite.to($(this),duration,tweenObj)
    
  $.fn.growDown = (duration,easing=Power1.easeOut,completeFunction=null) ->
    $el = $(this)
    if($el.css("display")=="none")
      $el.height(0)
      $el.css("display","block")
    tweenObj = {css:{autoAlpha:1,height:"100%"},ease:easing}
    if completeFunction != null
      tweenObj.onComplete = completeFunction
    TweenLite.to($(this),duration,tweenObj)

JiffyWorks
==========
##Pete Larson's javascript framework.
This is a port of an original framework developed by Ian Coyle which I have developed further. The aim of this framework is to provide a structure for javascript (coffeescript) on a web site that is event-based, simple, and flexible.

The core concepts of the framework are:
* JS code is always associated with a DOM element. This has a very loose MVC concept that keeps thing organized so you don't have to hunt all around your code saying "who's making that thing disappear?"
* Everything is a jQuery plugin. This just makes it easy to associate with a DOM element.
* Communication and control is done largely through events. Most of what you will be doing with this framework is setting up broadcasts and responses. Here are a few examples:
        $I respond_to _a.CLICK, hide_the_navbar
        hide_the_navbar = (evt) ->
          broadcast _a.NAVBAR_WAS_HIDDEN
* Code writing makes heavy use of sublime snippets

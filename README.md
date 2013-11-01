# PhoneGap iOS ExternalScreen Plugin

This plugin is originally by [Andrew Trice](http://www.tricedesigns.com/) and has been ported/enhanced for PhoneGap 3.0 plugman by [pearj](https://github.com/pearj) and [mxparajuli](https://github.com/mxparajuli).

## 1. Description

This plugin allows you to use an external screen on iOS devices using either AirPlay or VGA cable adapter.
	
The external screen is an UIWebView, that is controlled via Javascript APIs.

## 2. Installation and Usage

See Andrew Trice's [original blog post](http://www.tricedesigns.com/2012/01/12/multi-screen-ios-apps-with-phonegap/) to find out how to use this plugin.

His [original samples](https://github.com/triceam/phonegap-plugins/tree/master/iPhone/ExternalScreen/samples) can be used by replacing;

```html
<script type="text/javascript" charset="utf-8" src="phonegap-1.3.0.js"></script>
<script type="text/javascript" src="ExternalScreen/ExternalScreen.js"></script>
```

with:

```html
<script type="text/javascript" charset="utf-8" src="cordova.js"></script>
<script type="text/javascript" src="js/plugins/ExternalScreen.js"></script>
```
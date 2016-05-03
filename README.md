# PhoneGap iOS ExternalScreen Plugin

This plugin is originally by [Andrew Trice](http://www.tricedesigns.com/) and has been ported/enhanced for PhoneGap 3.0 plugman by [pearj](https://github.com/pearj) and [mxparajuli](https://github.com/mxparajuli).
It was updated for Cordova 6.x by [Matthijs Bierman](https://github.com/matthijsbierman) / [Geckotech](http://www.geckotech.nl).

## 1. Description

This plugin allows you to use an external screen on iOS devices using either AirPlay or VGA cable adapter.
	
The external screen is an UIWebView, that is controlled via Javascript APIs.

## 2. Installation and Usage

Install the plugin:

```
cordova plugin add https://github.com/matthijsbierman/ExternalScreen-iOS
```

The plugin is available under the global ```ExternalScreen``` object.

##### Initialize screen

To create a second screen, you need to listen for when a screen becomes available.

Note that you **cannot** programmatically start the second screen, but need to rely on the user to manually connect AirPlay or the adapter.

When the user chooses to connect an adapter, or mirror using AirPlay you can receive an event:

```javascript
ExternalScreen.addEventListener(function(status) {
    switch(status) {
        case 'connected':
            ExternalScreen.loadHTMLResource('yourpage.html');
            break;
        case 'disconnected':
            // maybe do something
            break;
    }
});
```

When a screen is connected, you load a page using:

```
ExternalScreen.loadHTMLResource('yourpage.html');
```

##### Execute script

It is also possible to communicate with the external page by sending scripts which will be evaluated:

```
ExternalScreen.invokeJavaScript("document.getElementById('customElement').textContent = 'example';");
```

Remember that the script needs to be serialized to a string. Any values you pass should also be serialized before calling ```invokeJavaScript()```.

##### Show screen

```
ExternalScreen.show();
```

##### Hide screen


```
ExternalScreen.hide();
```

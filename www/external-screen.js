var exec = cordova.require('cordova/exec');

var ExternalScreen = {
    
    setupScreenConnectionNotificationHandlers: function (success, fail) {
        return exec(success, fail, "CDVExternalScreen", "setupScreenConnectionNotificationHandlers", []);
    },
    
    loadHTMLResource: function (url, success, fail) {
        return exec(success, fail, "CDVExternalScreen", "loadHTMLResource", [url]);
    },
    
    loadHTML: function (url, success, fail) {
        return exec(success, fail, "CDVExternalScreen", "loadHTML", [url]);
    },
    
    invokeJavaScript: function (scriptString, success, fail) {
        return exec(success, fail, "CDVExternalScreen", "invokeJavaScript", [scriptString]);
    },
    
    checkExternalScreenAvailable: function (success, fail) {
        return exec(success, fail, "CDVExternalScreen", "checkExternalScreenAvailable", []);
    },

    registerForNotifications: function (success, fail) {
        return exec(success, fail, "CDVExternalScreen", "registerForNotifications", []);
    },

    showSecondScreen: function (success, fail) {
        return exec(success, fail, "CDVExternalScreen", "showSecondScreen", []);
    },

    hideSecondScreen: function (success, fail) {
        return exec(success, fail, "CDVExternalScreen", "hideSecondScreen", []);
    }
};

module.exports = ExternalScreen
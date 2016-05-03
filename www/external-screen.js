var exec = cordova.require('cordova/exec');

var ExternalScreen = {
    
    addEventListener: function (success, fail) {
        return exec(success, fail, "CDVExternalScreen", "addEventListener", []);
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

    showSecondScreen: function (success, fail) {
        return exec(success, fail, "CDVExternalScreen", "showSecondScreen", []);
    },

    hideSecondScreen: function (success, fail) {
        return exec(success, fail, "CDVExternalScreen", "hideSecondScreen", []);
    }
};

module.exports = ExternalScreen
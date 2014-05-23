/**
 * Created by wreid on 5/22/14.
 */
cordova.define("com.razorfish.proximityPlugin", function(require, exports, module) { var Proximity = function() {
};


// Call this to register for push notifications. Content of [options] depends on whether we are working with APNS (iOS) or GCM (Android)
    Proximity.prototype.register = function(successCallback, errorCallback, msg) {
        if (errorCallback == null) { errorCallback = function() {}}

        if (typeof errorCallback != "function")  {
            console.log("Proximity.register failure: failure parameter not a function");
            return
        }

        if (typeof successCallback != "function") {
            console.log("Proximity.register failure: success callback parameter must be a function");
            return
        }

        cordova.exec(successCallback, errorCallback, "PushPlugin", "register", [{"msg":msg}]);
    };

//-------------------------------------------------------------------

    if(!window.plugins) {
        window.plugins = {};
    }
    if (!window.plugins.pushNotification) {
        window.plugins.pushNotification = new Proximity();
    }

    if (module.exports) {
        module.exports = Proximity;
    }
});

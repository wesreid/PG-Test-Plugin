cordova.define("com.razorfish.proximityPlugin", function(require, exports, module) { var Proximity = function() {
};


// Call this to register for push notifications. Content of [options] depends on whether we are working with APNS (iOS) or GCM (Android)
    Proximity.prototype.saySomething = function(successCallback, errorCallback, msg) {
        if (errorCallback == null) { errorCallback = function() {}}

        if (typeof errorCallback != "function")  {
            console.log("Proximity.register failure: failure parameter not a function");
            return
        }

        if (typeof successCallback != "function") {
            console.log("Proximity.register failure: success callback parameter must be a function");
            return
        }

        cordova.exec(successCallback, errorCallback, "proximityPlugin", "saySomething", [{"msg":msg}]);
    };

//-------------------------------------------------------------------

    if(!window.plugins) {
        window.plugins = {};
    }
    if (!window.plugins.proximity) {
        window.plugins.proximity = new Proximity();
    }

    if (module.exports) {
        module.exports = Proximity;
    }
});
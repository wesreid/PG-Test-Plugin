var Proximity = function() {
    }
    , _nativePluginReference = 'proximityPlugin'
    , _fnCheckCallbacks = function (success, fail) {
        if (typeof fail != "function")  {
            console.log("Proximity.register failure: failure parameter not a function");
            return false;
        }

        if (typeof success != "function") {
            console.log("Proximity.register failure: success callback parameter must be a function");
            return false;
        }
        return true;
    };


// Plugin Javascript Interface

Proximity.prototype.initCallbacks = function (success, fail, proximityCallbacks) {
    if (fail == null) { fail = function() {}; }
    var fnPlaceholder = function(){};
    if (typeof proximityCallbacks !== 'object')
        return;
    proximityCallbacks.cbDidEnterRegion = proximityCallbacks.cbDidEnterRegion || fnPlaceholder;
    proximityCallbacks.cbDidDetermineStateForRegion = proximityCallbacks.cbDidDetermineStateForRegion || fnPlaceholder;
    proximityCallbacks.cbDidExitRegion = proximityCallbacks.cbDidExitRegion || fnPlaceholder;
    proximityCallbacks.cbDidFailWithError = proximityCallbacks.cbDidFailWithError || fnPlaceholder;
    proximityCallbacks.cbDidRangeBeaconsInRegion = proximityCallbacks.cbDidRangeBeaconsInRegion || fnPlaceholder;

    if (_fnCheckCallbacks(success, fail)) {
        cordova.exec(success, fail, _nativePluginReference, "initCallbacks", [proximityCallbacks]);
    }
}


// Expose plugin to app via global namespace
if(!window.plugins) {
    window.plugins = {};
}
if (!window.plugins.proximity) {
    window.plugins.proximity = new Proximity();
}

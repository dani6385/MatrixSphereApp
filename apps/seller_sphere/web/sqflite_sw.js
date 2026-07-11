// sqflite ffi web service worker
//
// When not using a shared worker, this file is simply loaded as a worker
// to load the sqlite3 wasm file.
//
// When using a shared worker, it is loaded as a shared worker, and it
// simply forwards messages to the various regular workers.
// The main goal is to keep a single sqlite3 wasm loaded and a single
// database opened.

// The version should match the wasm and dart code
// We don't really use it for now...
var version = "0.4.1";

// Let's not output anything on the console to avoid confusion
var log = console.log;
var error = console.error;
var debug = false;
var sw;
var sharedWorker;
if (typeof self.importScripts === "function") {
    sw = self;
    sharedWorker = false;

} else if (typeof SharedWorkerGlobalScope !== 'undefined' && self instanceof SharedWorkerGlobalScope) {
    sw = self;
    sharedWorker = true;
} else {
    error("Unsupported worker type");
}

var ports = [];

function postMessage(port, message) {
    // log("posting ", message, " to ", port);
    try {
        port.postMessage(message);
    } catch (e) {
        error("error posting ", message, " to ", port, " error ", e);
    }
}
function broadcast(message) {
    // log("broadcasting ", message, " to ", ports.length, " ports");
    for (var i = 0; i < ports.length; i++) {
        var port = ports[i];
        postMessage(port, message);
    }
}

// Dev only
function devLog(msg) {
    if (debug) {
        log(msg);
    }
}
function onNewConnection(port) {
    devLog("New connection");
    ports.push(port);
    port.onmessage = function (e) {
        var message = e.data;
        devLog("onmessage ", message, " from ", port);

        // Handle debug
        if (message.type == 'debug') {
            debug = message.debug;
            return;
        } else if (message.type == 'close') {
            devLog("closing ", port);
            var index = ports.indexOf(port);
            if (index > -1) {
                ports.splice(index, 1);
            }
            return
        }
        // When using a shared worker, simply broadcast to other ports
        if (sharedWorker) {
            broadcast(message);
        } else {
            // When using a regular worker, we can only handle sqlite3 wasm loading
            if (message.type == 'load') {
                var options = message.options;
                var sqlite3WasmUrl = options.sqlite3WasmUrl;
                devLog("Loading " + sqlite3WasmUrl);
                try {
                    // Load wasm
                    sw.importScripts(sqlite3WasmUrl);
                    devLog("Loaded " + sqlite3WasmUrl);
                    postMessage(port, {
                        type: 'loaded'
                    });

                } catch (e) {
                    error("Error loading " + sqlite3WasmUrl, e);
                    postMessage(port, {
                        type: 'error',
                        error: e.toString()
                    });
                }
            }
        }
    }
}

if (sharedWorker) {
    sw.onconnect = function (e) {
        var port = e.ports[0];
        onNewConnection(port);
        // Let the other end know we are connected
        postMessage(port, {type: "connected" });
    }
} else {
    onNewConnection(sw)
}

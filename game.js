
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'font', true, true);
Module['FS_createPath']('/', 'img', true, true);
Module['FS_createPath']('/', 'lang', true, true);
Module['FS_createPath']('/', 'lib', true, true);
Module['FS_createPath']('/', 'map', true, true);
Module['FS_createPath']('/', 'state', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 4495, "filename": "/character.lua"}, {"audio": 0, "start": 4495, "crunched": 0, "end": 4966, "filename": "/conf.lua"}, {"audio": 0, "start": 4966, "crunched": 0, "end": 5576, "filename": "/counter.lua"}, {"audio": 0, "start": 5576, "crunched": 0, "end": 5676, "filename": "/hud.lua"}, {"audio": 0, "start": 5676, "crunched": 0, "end": 7040, "filename": "/inventory.lua"}, {"audio": 0, "start": 7040, "crunched": 0, "end": 7507, "filename": "/lang.lua"}, {"audio": 0, "start": 7507, "crunched": 0, "end": 9782, "filename": "/main.lua"}, {"audio": 0, "start": 9782, "crunched": 0, "end": 10698, "filename": "/mainmenu.lua"}, {"audio": 0, "start": 10698, "crunched": 0, "end": 15213, "filename": "/maps.lua"}, {"audio": 0, "start": 15213, "crunched": 0, "end": 17484, "filename": "/menu.lua"}, {"audio": 0, "start": 17484, "crunched": 0, "end": 17981, "filename": "/npc.lua"}, {"audio": 0, "start": 17981, "crunched": 0, "end": 18079, "filename": "/player.lua"}, {"audio": 0, "start": 18079, "crunched": 0, "end": 19479, "filename": "/storage.lua"}, {"audio": 0, "start": 19479, "crunched": 0, "end": 21088, "filename": "/util.lua"}, {"audio": 0, "start": 21088, "crunched": 0, "end": 22920, "filename": "/world.lua"}, {"audio": 0, "start": 22920, "crunched": 0, "end": 150328, "filename": "/font/Bohemian typewriter.ttf"}, {"audio": 0, "start": 150328, "crunched": 0, "end": 150684, "filename": "/img/berry.png"}, {"audio": 0, "start": 150684, "crunched": 0, "end": 206068, "filename": "/img/bg.png"}, {"audio": 0, "start": 206068, "crunched": 0, "end": 213823, "filename": "/img/chars-naked.png"}, {"audio": 0, "start": 213823, "crunched": 0, "end": 221916, "filename": "/img/chars.png"}, {"audio": 0, "start": 221916, "crunched": 0, "end": 374828, "filename": "/img/free_tileset_version_10.png"}, {"audio": 0, "start": 374828, "crunched": 0, "end": 382480, "filename": "/img/npc1.png"}, {"audio": 0, "start": 382480, "crunched": 0, "end": 382913, "filename": "/lang/cs.lua"}, {"audio": 0, "start": 382913, "crunched": 0, "end": 383257, "filename": "/lang/en.lua"}, {"audio": 0, "start": 383257, "crunched": 0, "end": 384672, "filename": "/lib/require.lua"}, {"audio": 0, "start": 384672, "crunched": 0, "end": 393195, "filename": "/lib/tiledmap.lua"}, {"audio": 0, "start": 393195, "crunched": 0, "end": 393487, "filename": "/map/free_tileset_version_10.tsx"}, {"audio": 0, "start": 393487, "crunched": 0, "end": 412145, "filename": "/map/map01.tmx"}, {"audio": 0, "start": 412145, "crunched": 0, "end": 430036, "filename": "/map/map03.tmx"}, {"audio": 0, "start": 430036, "crunched": 0, "end": 448055, "filename": "/map/map04.tmx"}, {"audio": 0, "start": 448055, "crunched": 0, "end": 449283, "filename": "/state/state_inventory.lua"}, {"audio": 0, "start": 449283, "crunched": 0, "end": 449725, "filename": "/state/state_menu.lua"}, {"audio": 0, "start": 449725, "crunched": 0, "end": 450288, "filename": "/state/state_paused.lua"}, {"audio": 0, "start": 450288, "crunched": 0, "end": 453458, "filename": "/state/state_picking_mouse.lua"}, {"audio": 0, "start": 453458, "crunched": 0, "end": 454530, "filename": "/state/state_playing.lua"}, {"audio": 0, "start": 454530, "crunched": 0, "end": 455500, "filename": "/state/state_sleeping.lua"}], "remote_package_size": 455500, "package_uuid": "b977504c-6703-434a-b5e0-e95807dab013"});

})();

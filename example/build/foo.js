// Generated by CommonJS Everywhere 0.7.0
(function (global) {
  function require(file, parentModule) {
    if ({}.hasOwnProperty.call(require.cache, file))
      return require.cache[file];
    var resolved = require.resolve(file);
    if (!resolved)
      throw new Error('Failed to resolve module ' + file);
    var module$ = {
        id: file,
        require: require,
        filename: file,
        exports: {},
        loaded: false,
        parent: parentModule,
        children: []
      };
    if (parentModule)
      parentModule.children.push(module$);
    var dirname = file.slice(0, file.lastIndexOf('/') + 1);
    require.cache[file] = module$.exports;
    resolved.call(module$.exports, module$, module$.exports, dirname, file);
    module$.loaded = true;
    return require.cache[file] = module$.exports;
  }
  require.modules = {};
  require.cache = {};
  require.resolve = function (file) {
    return {}.hasOwnProperty.call(require.modules, file) ? require.modules[file] : void 0;
  };
  require.define = function (file, fn) {
    require.modules[file] = fn;
  };
  var process = function () {
      var cwd = '/';
      return {
        title: 'browser',
        version: 'v0.10.5',
        browser: true,
        env: {},
        argv: [],
        nextTick: global.setImmediate || function (fn) {
          setTimeout(fn, 0);
        },
        cwd: function () {
          return cwd;
        },
        chdir: function (dir) {
          cwd = dir;
        }
      };
    }();
  require.define('/foo.js', function (module, exports, __dirname, __filename) {
    var log = require('/log.coffee', module);
    module.exports = function (bar) {
      log('foo' + (bar || 'bar'));
    };
  });
  require.define('/time.coffee', function (module, exports, __dirname, __filename) {
    var zeropad;
    zeropad = function (number, pad) {
      var rv;
      rv = number.toString();
      if (rv.length <= 1)
        rv = '0' + rv;
      return rv;
    };
    module.exports = function (date) {
      var parts;
      if (null == date)
        date = new Date;
      parts = [
        zeropad(date.getHours()),
        zeropad(date.getMinutes()),
        zeropad(date.getSeconds())
      ];
      return parts.join(':');
    };
  });
  require.define('/log.coffee', function (module, exports, __dirname, __filename) {
    var el, time;
    time = require('/time.coffee', module);
    el = null;
    module.exports = function (message) {
      var msg;
      if (null != el)
        el;
      else
        el = document.getElementById('log');
      msg = document.createTextNode('[' + time() + '] ' + message + '\n');
      return el.appendChild(msg);
    };
  });
  require('/foo.js');
}.call(this, this));
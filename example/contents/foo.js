var log = require('./log');

module.exports = function(bar) {
  log('foo' + (bar || 'bar'));
};

function periodicMessage(message, callback) {
  setInterval(function() {
    callback(message);
  }, 5000);
}

module.exports = periodicMessage;

zeropad = (number, pad) ->
  rv = number.toString()
  rv = '0' + rv if rv.length <= 1
  return rv

module.exports = (date=new Date) ->
  parts = [
    zeropad date.getHours()
    zeropad date.getMinutes()
    zeropad date.getSeconds()
  ]
  return parts.join ':'

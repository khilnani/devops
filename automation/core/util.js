
var util = exports;

util.pad = function pad(n, width, z) {
  var neg = '';
  if(n < 0) {
    neg = '-';
    n = -1 * n;
  }
  z = z || '0';
  width = width || 2;
  n = n + '';
  return n.length >= width ? n : neg + '' + new Array(width - n.length + 1).join(z) + n;
}

var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
              'Oct', 'Nov', 'Dec'];

util.timestamp = function () {
  var d = new Date();
  var time = [this.pad(d.getHours()),
            this.pad(d.getMinutes()),
            this.pad(d.getSeconds()),
            this.pad(d.getMilliseconds(),3)].join(':');
  var offset =  this.pad( -1 * d.getTimezoneOffset()/60 ) + '' + this.pad( d.getTimezoneOffset() % 60 );
  return '[' + d.getDate() + '/' +  months[d.getMonth()] + '/' + d.getFullYear() + ' ' + time + ' ' + offset + ']';
}

// 26 Feb 16:19:34
util.nodejs_timestamp = function () {
  var d = new Date();
  var time = [this.pad(d.getHours()),
              this.pad(d.getMinutes()),
              this.pad(d.getSeconds())].join(':');
  return [d.getDate(), months[d.getMonth()], time].join(' ');
}

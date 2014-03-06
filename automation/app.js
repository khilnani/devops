#!/usr/bin/env phantomjs

//--------------------------------------------------------
// https://github.com/ariya/phantomjs/wiki/API-Reference
//--------------------------------------------------------

var page = require('webpage').create(),
    system = require('system'),
    fs = require('fs'),
    config = require('./core/config'),
    log = require('./core/logger'),
    action = null;

//--------------------------------------------------------

work = function (data) {

  if(action == null) {
    action = config.data().action;
  }

  log.event( 'ACTION: ' + action.m + ', ' + action.a + ' on URL: ' + page.url);
  
  var m = null;
  
  try {
    m = require('./modules/' +  action.m);
  } catch(e) {
    log.error ('Unabled to load module: ' + action.m);
    phantom.exit();
  }

  if( m ) {
    if( m[action.a] ) {
      action = m[action.a].call(this, page);
      log.info ('Executed ACTION');
    } else {
      log.error ('Unabled to find module method: ' + action.m + '.' +  action.a);
      phantom.exit();
    }
  } else {
    log.error ('Unabled to find module: ' + action.m);
    phantom.exit();
  }
}


page.onLoadFinished = function(status) {
  log.debug('Status: ' + status);
  if(status == 'success') {
    work.call(this);
  } else {
    log.error('Connection failed.');
    phantom.exit();
  }
}

page.onConsoleMessage = function(msg){ 
  log.info('  PAGE console.log: ' + msg);
}

page.onResourceRequested = function(requestData, networkRequest) {
  log.trace('  Request (#' + requestData.id + '): ' + requestData.url);
}

page.onResourceReceived = function (response) {
  if(response.stage == "end")
    log.info('  Response (#' + response.id + ', status ' + response.status + '"): ' + response.url);
}

page.onUrlChanged = function(url) {
  log.event('URL: ' + url);
}

//window.callPhantom invokes this
page.onCallback = function (data) {
  log.debug('onCallback: ' + data);
}

page.onError = function(msg, trace) {
    var msgStack = ['ERROR: ' + msg];
    if (trace && trace.length) {
        msgStack.push('TRACE:');
        trace.forEach(function(t) {
            msgStack.push(' -> ' + t.file + ': ' + t.line + (t.function ? ' (in function "' + t.function + '")' : ''));
        });
    }
    console.error(msgStack.join('\n'));
}

page.onNavigationRequested = function(url, type, willNavigate, main) {
  log.debug('page.onNavigationRequested: ' + willNavigate + ', main: ' + main + ', type: ' + type + ', url: ' + url);
}

page.onAlert = function (msg) {
  log.debug("page.onAlert: " + msg);
}

//--------------------------------------------------------

config.start(page);

//--------------------------------------------------------


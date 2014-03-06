var _config = require('../config/config'),
    log = require('./logger');

var config = exports;

config.start = function(page) {

  if( _config['logLevel'] ) {
    log.setLogLevel( _config['logLevel'] );
  }

  if( _config['userAgent'] ) {
    page.settings.userAgent = _config['userAgent'];
    log.info('Useragent: ' + page.settings.userAgent);
  }

  if( _config['resourceTimeout'] ) {
    page.settings.resourceTimeout = _config['resourceTimeout'];
    log.info('page.settings.resourceTimeout:' + page.settings.resourceTimeout ); 
  }

  if( _config['libraryPath'] ) {
    page.libraryPath = _config['libraryPath'];
    log.info('page.libraryPath:' + page.libraryPath );
  }

  if( _config['url'] ) {
    page.open( _config['url']);
  } else {
    log.error('config.json is missing url');
    phantom.exit(1);
  }
}

config.data = function () {
  return _config;
}


var config = require('../config/google'),
    log = require('../core/logger');

var google = exports;

google.search = function (page) {
  log.info('google: search()');
  
  var q = config.q;

  page.injectJs('jquery-1.8.2.min.js');

  page.evaluate( function(q) {
    $('input[name="q"]').val( q );
    console.log( 'google: Query: ' + $('input[name="q"]')[0].value );
    $('form[action="/search"]').submit();
  }, q); 

  // Set a little delay to wait for the page to refresh
  window.setTimeout( function () {
    page.render('images/search.png');
    log.info('google: Saved screenshot: search.png');
  }, 100);

  return { m: 'google', a: 'results'};
}

google.results = function (page) {
  log.info('google: results()');
 
  page.injectJs('jquery-1.8.2.min.js');

  page.evaluate( function() {
    var link = $('h3[class="r"] a')[0];
    console.log ( 'google: Navigating to: ' + link ); 
    document.location.href = link;
  });

  page.render('images/results.png');
  log.info('google: Saved screenshot: results.png');
  
  return { m: 'google', a: 'link'};
}

google.link = function (page) {
  log.info('google: link()');

  page.injectJs('jquery-1.8.2.min.js');

  page.evaluate( function() {
    var docLink = $("a:contains('Documentation')")[0];
    console.log("Doc Link: " + docLink);
    document.location.href = docLink;
  });

  page.render('images/link.png');
  log.info('google: Saved screenshot: link.png');

  return { m: 'google', a: 'docLink'};
}

google.docLink = function (page) {
  log.info('google: docLink()');

  page.render('images/docLink.png');
  log.info('google: Saved screenshot: docLink.png');

  phantom.exit();
}


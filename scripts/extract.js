var page = require('webpage').create(),
  system = require('system'),
  fs = require('fs'),
  path;

if (system.args.length === 1) {
  console.log('Usage: extract.js <FILE>');
  phantom.exit();
}

path = system.args[1];

if (!fs.isFile(path)) {
  console.log('Unknown file : ' + path);
  phantom.exit();
}

page.settings.javascriptEnabled = false;
page.content = fs.read(path);
page.evaluate(function() {

  console.log("OK");
  var getElementsByAttribute = function (attr) {
    var match = [];
    var elements = document.getElementsByTagName("*");
    console.log(elements.length);
    for (var ii = 0, ln = elements.length; ii < ln; ii++) {
      if (elements[ii].hasAttribute(attr)) {
         match.push(elements[ii]);
      }
    }
    return match;
  };

  var baz = getElementsByAttribute('data-tess-label');
  console.log(baz.length);
  for (var xx = 0, ln = baz.length; xx < ln; xx++) {
    console.log(baz[xx].getAttribute('data-tess-label'));
  }
  
  phantom.exit();
});

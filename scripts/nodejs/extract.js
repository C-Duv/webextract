var cheerio = require('cheerio'), // DEPENDENCY : cheerio
  fs = require('fs'),
  path, $;

if (process.argv.length != 3) {
  console.log('Usage: extract.js <FILE>');
  process.exit();
}

path = process.argv[2];

fs.stat(path, function(err, stats) {
    if (!stats.isFile()) {
      console.log('Unknown file : ' + path);
      process.exit();
    }

    $ = cheerio.load(fs.readFileSync(path));

    var elements = $("*");
    for (var ii = 0, ln = elements.length; ii < ln; ii++) {
      if ($(elements[ii]).attr('data-tess-label') !== undefined) {
        console.log($(elements[ii]).attr('data-tess-label'));
      }
    }

});

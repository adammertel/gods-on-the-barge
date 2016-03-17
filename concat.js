// http://stackoverflow.com/questions/29697182/concat-in-npm-using-a-glob-input-no-grunt-or-gulp

var fs = require('fs'),
    glob = require('glob'),
    args = process.argv.splice(2);

if(args.length !== 2)
    return console.log('Incorrect usage. "node concat [glob] [output file]"');

if(fs.exists(args[1]))
    fs.unlinkSync(args[1]);
glob.sync(args[0]).forEach(function(file) {
    fs.appendFileSync(args[1], fs.readFileSync(file, 'utf-8'));
});


var fs = require('fs');
var jison = require('jison');


var bnf = fs.readFileSync("expr.jison", "utf8");

var compilador = new jison.Parser(bnf);

var result = compilador.parse(`
  print "hello"
`);



console.log("Arvore Sintatica =");
console.log(result);


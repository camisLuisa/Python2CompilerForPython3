var fs = require('fs');
var jison = require('jison');


var bnf = fs.readFileSync("expr.jison", "utf8");

var compilador = new jison.Parser(bnf);

var result = compilador.parse(`
   raiseIOError , º a º ;

  `);



console.log("Arvore Sintatica =");
console.log(result);
//console.log("Arvore Sintatica =");
//console.log(JSON.stringify(result,null,2));

console.log("codigo gerado: ");
console.log(result.geraCodigo());
/*
var fs = require('fs');
var jison = require('jison');


var bnf = fs.readFileSync("expr.jison", "utf8");

var compilador = new jison.Parser(bnf);

var valores = { x : 4 , y : 5 };
var result = compilador.parse(`
  x = x * y;
`)
;



console.log("Arvore Sintatica =");
console.log(result);
console.log("\n\nvalores antes = ");
console.log(valores);
console.log("\n\nvalor = " + result.avalie(valores));
console.log("valores depois = ");
console.log(valores);*/

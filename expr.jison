%{
var tree = require("tree");
%}

%lex
%%
(" "|\n)+                   /* skip whitespace */
"print"               return 'print'
[0-9]+                return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"="                   return '='
";"                   return ';'
","                   return ','
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"("                   return '('
")"                   return ')'
"{"                   return '{'
"}"                   return '}'
"=="                  return '=='
"<"                   return '<'
">"                   return '>'
">="                  return '>='
"<="                  return '<='
"!="                  return '!='
"and"                 return 'and'
"or"                  return 'or'
"str"                 return 'str'
"list"                return 'list'
"int"                 return 'int'
"bool"                return 'bool'
"type"                return 'type'
"if"                  return 'if'
"Class"               return 'Class'
"def"                 return 'def' 
<<EOF>>               return 'EOF'
[a-z]+                return 'ID'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left '^'

%left '>' '<' '<=' '>=' '==' '!=' 'and' or'
%start inicio
%% /* language grammar */
inicio : comando EOF { return $1; }
       ;

comandoClasse
    : "Class" ID "{" comando "}" ";"  {$$ = new tree.Classe($2,$4);}
   ;

comando
    : "def" ID "("p1 "," p2 ")" "{" comando "}" ";" {$$ = new tree.Metodo($2,$4,$6,$9);}
    | ID "=" e ";" {$$ = new tree.Atrib($1,$3);}
    | "type" "(" ID "=" t ")" ";"{$$ = new tree.Type($1,$3);}
    | "print" e ";" {$$ = new tree.Print($2);}
    |"if" e "{" e "}" ";" {$$ = new tree.Compare($2,$4);}
    |"if" e "{" e "}" "else" "{" e "}" ";" {$$ = new tree.Compare ($2,$4,$8);}
    |"for" ID "in" "range()"
    ;
  e
    : e "+" e {$$ = new tree.Op("+",$1,$3);}
    | e "-" e {$$ = new tree.Op("-",$1,$3);}
    | e "*" e {$$ = new tree.Op("*",$1,$3);}
    | e "/" e {$$ = new tree.Op("/",$1,$3);}
    | e "^" e {$$ = new tree.Op("^",$1,$3);}
    | e ">" e {$$ = new tree.Op(">",$1,$3);}
    | e "<" e {$$ = new tree.Op("<",$1,$3);}
    | e ">=" e {$$ = new tree.Op(">=",$1,$3);}
    | e "<=" e {$$ = new tree.Op("<=",$1,$3);}
    | e "==" e {$$ = new tree.Op("==",$1,$3);}
    | e "!=" e {$$ = new tree.Op("!=",$1,$3);}
    | e "and" e {$$ = new tree.Op("and",$1,$3);}
    | e "or" e {$$ = new tree.Op("or",$1,$3);}
    | "(" e ")" {$$ = $2;}
    | NUMBER {$$ = new tree.Num(Number(yytext));}
    | ID {$$ = new tree.Id(yytext); }
    ;
  decl
    : Type Id
    ;
  type
    : Int | Bool | String
    ;
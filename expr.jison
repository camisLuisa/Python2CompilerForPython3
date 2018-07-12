%{
var tree = require("tree");
%}

%lex
%%
(" "|\n)+                   /* skip whitespace */
"class"               return 'class'
"print"               return 'print'
"raiseIOError"        return 'RE'
"try"                 return 'try'
"err"                 return 'err'
"exception ErrorName" return 'eE'
"Raw_input"           return 'Ri'
"input"               return 'input'
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
"def"                 return 'def' 
<<EOF>>               return 'EOF'
"º"                   return 'ASPAS'
[a-z | _]+                return 'ID'
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
       |comandoClasse EOF {return $1;}
       ;

comandoClasse
    : "class" ID "{" comando "}" ";"  {$$ = new tree.Classe($2,$4);}
   ;

comando
    : "def" ID"("ID","ID")" "{" comando "}" ";" {$$ = new tree.Metodo($2,$4,$6,$9);}
    | ID "=" e ";" {$$ = new tree.Atrib($1,$3);}
    | "type" "(" ID "=" t ")" ";"{$$ = new tree.Type($1,$3);}
    | "print" ASPAS ID  ASPAS ";"  {$$ = new tree.Print($3);}
    | "RE" "," ASPAS ID ASPAS ";"  {$$ = new tree.Error($4);}
    | "int" ID ";" {$$ = new tree.Num($2);}
    | ID "=" type "(" input "(" ID ")" ")" ";" {$$ = new tree.RI($1,$3,$7,$5);}
    | "try" ":" "{" ID "}" "{" eE "," err ":"  "}" print err ";" {$$ = new tree.Excecao($4);}
    |"if" e "{" e "}" ";" {$$ = new tree.ComparaIf($2,$4);}
    |"if" e "{" e "}" "else" "{" e "}" ";" {$$ = new tree.ComparaIfElse ($2,$4,$8);}
    |"for" ID "in" "range()"
    |{ $$ = null; }  
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
    | NUMBER {$$ = new tree.Num(yytext);}
    | ID {$$ = new tree.Id(yytext); }
    ;
  decl
    : Type Id
    ;
  type
    : int | bool | str
    ;
%{
var tree = require("tree");

%}

%lex
%%
(" "|\n)+                   /* skip whitespace */
[a-z]+                return 'ID'
[0-9]+                return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"="                   return '='
";"                   return ';'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"("                   return '('
")"                   return ')'
"{"                   return '{'
"}"                   return '}'
"print"               return 'print'
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

<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left '^'

%left '>' '<' '<=' '>=' '==' '!=' 'and' or'

%start inicio

%% /* language grammar */

inicio : comando EOF { return 1; }
       ;

comando
    : ID '=' e ';' {return new tree.Atrib($1,$3);}
    ;

comando
    :'type' '(' ID '=' t ')' ';'{return new tree.Type($1,$3);}
    ;

comando
    :'print' e ';' {return new tree.Print($2);}
    ;

commando
    :'if' e '{' e '}' ';' {$$ = new tree.Compare($2,$4);}
    |'if' e '{' e '}' 'else' '{' e '}' ';' {$$ = new tree.Compare($2,$4,$8);}
    ;

comando
    :'for' ID 'in' 'range()'

e
    : e '+' e {$$ = new tree.Op('+',$1,$3);}
    | e '-' e {$$ = new tree.Op('-',$1,$3);}
    | e '*' e {$$ = new tree.Op('*',$1,$3);}
    | e '/' e {$$ = new tree.Op('/',$1,$3);}
    | e '^' e {$$ = new tree.Op('^',$1,$3);}
    | e '>' e {$$ = new tree.Op('>',$1,$3);}
    | e '<' e {$$ = new tree.Op('<',$1,$3);}
    | e '>=' e {$$ = new tree.Op('>=',$1,$3);}
    | e '<=' e {$$ = new tree.Op('<=',$1,$3);}
    | e '==' e {$$ = new tree.Op('==',$1,$3);}
    | e '!=' e {$$ = new tree.Op('!=',$1,$3);}
    | e 'and' e {$$ = new tree.Op('and',$1,$3);}
    | e 'or' e {$$ = new tree.Op('or',$1,$3);}
    | '(' e ')' {$$ = $2;}
    | NUMBER {$$ = new tree.Num(Number(yytext));}
    | ID {$$ = new tree.Id(yytext); }
    ;

decl
    : Type Id
    ;

type
    : 'Int'|'Bool'|'String'
    ;

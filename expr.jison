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
"print"               return 'print'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left '^'

%start inicio

%% /* language grammar */

inicio : comando EOF { return 1; }
       ;
comando
    : ID '=' e ';' {return new tree.Atrib($1,$3);}
    ;

e
    : e '+' e {$$ = new tree.Op('+',$1,$3);}
    | e '-' e {$$ = new tree.Op('-',$1,$3);}
    | e '*' e {$$ = new tree.Op('*',$1,$3);}
    | e '/' e {$$ = new tree.Op('/',$1,$3);}
    | e '^' e {$$ = new tree.Op('^',$1,$3);}
    | print e {$$ = new tree.Print($2);}
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

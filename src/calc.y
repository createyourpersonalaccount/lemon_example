/* This Lemon calculator is taken from the example in
   <https://souptonuts.sourceforge.net/readme_lemon_tutorial.html>.
*/
%token_type {int}

%left PLUS MINUS.
%left DIVIDE TIMES.

%include {
#include <stdio.h>
#include <stdlib.h>
#include <calc.h>
}

%syntax_error {
  printf("syntax error\n");
}

program ::= expr(A).   { printf("Result=%d\n", A); }

expr(A) ::= expr(B) MINUS  expr(C).  { A = B - C; }
expr(A) ::= expr(B) PLUS   expr(C).  { A = B + C; }
expr(A) ::= expr(B) TIMES  expr(C).  { A = B * C; }
expr(A) ::= expr(B) DIVIDE expr(C).  {
  if(C != 0) {
    A = B / C;
  } else {
    printf("divide by zero\n");
  }
}
expr(A) ::= INTEGER(B). { A = B; }

%code {
  int main() {
    void* pParser = ParseAlloc (malloc);
    /* First input:
       15 / 5
    */
    Parse (pParser, INTEGER, 15);
    Parse (pParser, DIVIDE, 0);
    Parse (pParser, INTEGER, 5);
    Parse (pParser, 0, 0);
    /*  Second input:
        50 + 125
    */
    Parse (pParser, INTEGER, 50);
    Parse (pParser, PLUS, 0);
    Parse (pParser, INTEGER, 125);
    Parse (pParser, 0, 0);
    /*  Third input:
        50 * 125 + 125
    */
    Parse (pParser, INTEGER, 50);
    Parse (pParser, TIMES, 0);
    Parse (pParser, INTEGER, 125);
    Parse (pParser, PLUS, 0);
    Parse (pParser, INTEGER, 125);
    Parse (pParser, 0, 0);
    ParseFree(pParser, free );
    return 0;
  }
}

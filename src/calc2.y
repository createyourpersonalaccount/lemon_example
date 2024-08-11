%token_type {int}

%left PLUS MINUS.
%left DIVIDE TIMES.

%include {
#include <stdio.h>
#include <stdlib.h>
#include <readline/readline.h>
#include <calc2.h>
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
expr(A) ::= LPAR expr(B) RPAR. { A = B; }

%code {
  void lex(void *parser, const char *str) {
    const char *YYCURSOR = str;
    const char *b;
    int n;
    /*!stags:re2c format = 'const char *@@;\n'; */
    for (;;) {
      /*!re2c
        re2c:define:YYCTYPE = "unsigned char";
        re2c:yyfill:enable = 0;
        re2c:tags = 1;

        number = ([-] | [+])?[1-9][0-9]*;
        lpar = "(";
        rpar = ")";
        minus = "-";
        plus = "+";
        mul = "*";
        div = "/";

        * { Parse(parser, 0, 0); return; }
        @b number { n = (int)strtol(b, NULL, 10); Parse(parser, INTEGER, n); continue; }
        lpar { Parse(parser, LPAR, 0); continue; }
        rpar { Parse(parser, RPAR, 0); continue; }
        plus { Parse(parser, PLUS, 0); continue; }
        minus { Parse(parser, MINUS, 0); continue; }
        mul { Parse(parser, TIMES, 0); continue; }
        div { Parse(parser, DIVIDE, 0); continue; }
        [ ]+ { continue; }
      */
    }
  }

  int main(void) {
    char *line;
    void* parser = ParseAlloc (malloc);
    while((line = readline("calc> ")) != NULL) {
      lex(parser, line);
      free(line);
    }
    ParseFree(parser, free);
    return 0;
  }
}

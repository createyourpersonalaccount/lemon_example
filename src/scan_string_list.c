#include <stdio.h>
#include <stdint.h>
#include <arpa/inet.h>

enum TokenType {
  TOKENTYPE_STR = 258,
};

void write_token(FILE *fp, const char *b, const char *e, uint32_t token_type) {
  uint32_t length = htonl((uint32_t)(e - b));
  uint32_t type = htonl(token_type);
  fwrite(&type, 1, 4, fp);
  fwrite(&length, 1, 4, fp);
  fwrite(b, 1, e - b, fp);
}

void lex(const char *str) {
  const char *YYCURSOR = str;
  const char *b, *e;
  /*!stags:re2c format = 'const char *@@;\n'; */
  for (;;) {
    /*!re2c
      re2c:define:YYCTYPE = "unsigned char";
      re2c:yyfill:enable = 0;
      re2c:tags = 1;

      str = ['] ([^'\\] | [\\][^])* ['];
      comma = [,];

      *    { return; }
      @b str @e { write_token(stdout, b, e, TOKENTYPE_STR); continue; }
      comma { continue; }
      [ ]+ { continue; }
    */
  }
}

int main(void) {
  char buf[BUFSIZ];
  if(fgets(buf, BUFSIZ, stdin)) {
    lex(buf);
  }
  return 0;
}

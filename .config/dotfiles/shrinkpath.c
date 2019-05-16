#include <ctype.h>
#include <libgen.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ST_SEG_START 0
#define ST_AFTER_LC 1
#define ST_AFTER_OTHER 2

struct token {
  char sep;
  char *word;
};

int split(char *path, struct token *buf)
{
  int tok = 0;
  if (buf != NULL) {
    buf[0].sep = '\0';
    buf[0].word = path;
  }

  for (char *p = path; *p != '\0'; p++) {
    if (!isalnum(*p) || !islower(*p)) {
      tok++;
      if (buf != NULL) {
        buf[tok].sep = *p;
        *p = '\0';
        buf[tok].word = p+1;
      }
    }
  }

  return tok+1;
}

int is_vowel(int c)
{
  return
    c == 'a' || c == 'e' || c == 'i' || c == 'o' ||
    c == 'u' || c == 'w' || c == 'y';
}

void print_condensed(struct token *tok)
{
  char sep[2] = {tok->sep, 0};

  size_t tok_len = strlen(tok->word);
  if (tok_len < 4UL - (isalpha(tok->sep) ? 1UL : 0UL)) {
    printf("%s%s", sep, tok->word);
    return;
  }

  char buf[4] = {0};

  char *c = tok->word;
  if (!isalpha(tok->sep)) {
    printf("%s", sep);
    buf[0] = *(c++);
  } else {
    buf[0] = tok->sep;
  }

  while (*(c+1) != '\0') {
    if (!is_vowel(*c)) {
      buf[1] = *c;
      break;
    }
    c++;
  }

  if (buf[1] != 0) {
    buf[2] = tok->word[tok_len - 1];
  } else {
    buf[1] = tok->word[tok_len - 1];
  }
  printf("%s", buf);
}

int main(int argc, char **argv)
{
  if (argc != 2) {
    fprintf(stderr, "usage: %s path\n", argv[0]);
    return 1;
  }

  char *bpath = strdup(argv[1]);
  char *bn = basename(bpath);

  char *dpath = strdup(argv[1]);
  char *dn = dirname(dpath);

  if (strlen(dn) == 1 && dn[0] == '.') {
    printf("%s", bn);
    return 0;
  }

  if (strlen(dn) == 1 && dn[0] == '/') {
    printf("/%s", bn);
    return 0;
  }

  int tok_count = split(dn, NULL);
  struct token *toks = calloc(tok_count, sizeof(struct token));
  split(dn, toks);

  for (int k = 0; k < tok_count; k++) {
    print_condensed(toks + k);
  }
  putchar('/');
  printf("%s", bn);

  return 0;
}

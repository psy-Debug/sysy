%option noyywrap
%option yylineno

%{
#include "sysy.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void lex_error(char* msg, int line);
extern int error_occurred;
%}

/* 正则定义 */
DIGIT       [0-9]
OCT_DIGIT   [0-7]
HEX_DIGIT   [0-9a-fA-F]
ID          [a-zA-Z_][a-zA-Z0-9_]*
WS          [ \t\n\r]+

%%

"int"       { return INT; }
"void"      { return VOID; }
"float"     { return FLOAT; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"break"     { return BREAK; }
"continue"  { return CONTINUE; }
"return"    { return RETURN; }

"("         { return LP; }
")"         { return RP; }
"["         { return LB; }
"]"         { return RB; }
"{"         { return LC; }
"}"         { return RC; }
";"         { return SEMI; }
","         { return COMMA; }

"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"%"         { return MOD; }
"="         { return ASSIGN; }
"!"         { return NOT; }
"&&"        { return AND; }
"||"        { return OR; }
"=="        { return EQ; }
"!="        { return NE; }
"<"         { return LT; }
"<="        { return LE; }
">"         { return GT; }
">="        { return GE; }

0[xX]{HEX_DIGIT}+  { yylval.int_val = (int)strtol(yytext, NULL, 16); return INTCON; }
0{OCT_DIGIT}+      { yylval.int_val = (int)strtol(yytext, NULL, 8);  return INTCON; }
0|[1-9]{DIGIT}*    { yylval.int_val = atoi(yytext); return INTCON; }

    /* 新增：浮点数常量 */
{DIGIT}+\.{DIGIT}+ { yylval.float_val = atof(yytext); return FLOATCON; }

"//".*             { /* 忽略单行注释 */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* 忽略多行注释 */ }

{WS}               { /* 忽略空白 */ }

{ID}               { yylval.str_val = strdup(yytext); return ID; }

0[0-9]+ {
    char msg[64]; sprintf(msg, "Illegal octal number '%s'", yytext);
    lex_error(msg, yylineno);
    yylval.int_val = 0; return INTCON;
}

0[xX][0-9a-zA-Z]+ {
    char msg[64]; sprintf(msg, "Illegal hexadecimal number '%s'", yytext);
    lex_error(msg, yylineno);
    yylval.int_val = 0; return INTCON;
}

. {
    char msg[64]; sprintf(msg, "Invalid character \"%s\"", yytext);
    lex_error(msg, yylineno);
}

%%

void lex_error(char* msg, int line) {
    printf("Error type A at Line %d: %s\n", line, msg);
    error_occurred = 1;
}
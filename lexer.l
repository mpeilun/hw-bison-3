%{
#include <stdio.h>
#include <string.h>
#include "parser.h"

int yyerror(char *);

char identifier[50][50];
int total_id = 0;
extern YYSTYPE yylval;
int lineNum = 0;

%}

%option noyywrap
DIGIT  [0-9]
LETTER [a-zA-Z]
MULOP	[*/%]
ADDOP	[+-]

%%

"if" { return IF;}
"else" { return ELSE; }
"while" { return WHILE; }
"for" { yyerror("Reserved Word for");}
"repeat" { yyerror("Reserved Word repeat");}
"until" { yyerror("Reserved Word until");}
"return" { yyerror("Reserved Word return");}
"main" { yyerror("Reserved Word main");}
{LETTER}({LETTER}|{DIGIT}|"_")?({LETTER}|{DIGIT}|"_")?({LETTER}|{DIGIT}|"_")?({LETTER}|{DIGIT}|"_")? {
	int i;
    int flag=0; 
    for (i = 0; i<total_id; i++) {
		if (strcmp(identifier[i], yytext)==0) {
			flag=1;
			break;
		}
    }
	strcpy(yylval.STRING, yytext);
	if(flag==0) {
		if(total_id==0) puts("");
		strcpy(identifier[total_id++],yylval.STRING);
    }
	return ID;
}
{DIGIT}+|({DIGIT}+("."){DIGIT}+) 	{ yylval.VALUE = atof(yytext); return NUM; } 
"=="|">="|"<="|">"|"<"|"!="	     	{ strcpy(yylval.STRING, yytext); return RELOP; }
{ADDOP}|("||") 						{ strcpy(yylval.STRING, yytext); return ADDOP; }
{MULOP}|("&&") 						{ strncpy(yylval.STRING, yytext, strlen(yytext)); return MULOP; }
"="									{ return ASSIGN; }
";"									{ return END; }
"!"									{ return NOT; }
"["									{ return SQRBO; }
"]"									{ return SQRBC; }
"("									{ return STRBO; }
")"									{ return STRBC; }
"{"									{ return CURBO; }
"}"									{ return CURBC; }
"\n"								{ lineNum++; }
[._]+								{ yyerror("Invalid character"); }
[ \t]+			                    {/* 忽略空白和 tab */} 

%%
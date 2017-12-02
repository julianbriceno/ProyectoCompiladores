%option noyywrap

%{
	#include <iostream>
	#include <cstdio>
	#include "parser.tab.h"
	using namespace std;
	int lineas=1;
	int a=-1;
%}
%x SEC
%x SEC2

%%
"/*" {BEGIN(SEC);}
<SEC>"*/" {BEGIN(INITIAL);}
<SEC>\n {lineas++;}
<SEC>. {}

"//"	{BEGIN(SEC2);}
<SEC2>\n {lineas++; BEGIN(INITIAL);}
<SEC2>.		{}

"printf"					{cout<<"pritf"<<endl;return PRINTF;}
"scanf"						{cout<<"scanf"<<endl;return SCANF;}
"int"						{cout<<"int"<<endl;return INT;}
"float"						{cout<<"float"<<endl;return FLOAT;}
"char"						{cout<<"char"<<endl;return CHAR;}
"main"						{cout<<"main"<<endl;return MAIN;}
"if"						{cout<<"Inicio if"<<endl;return IF;}
"do"						{cout<<"do"<<endl;return DO;}
"while"						{cout<<"while"<<endl;return WHILE;}
"for"						{cout<<"for"<<endl;return FOR;}
[_A-Za-z][_a-zA-Z0-9]*				{cout<<"ID"<<endl;return ID;}
"."       					{cout<<"punto"<<endl;return PUNTO;}
";"						{cout<<"ptcoma"<<endl;return PTOCOMA;}
"{"						{cout<<"llaveabr"<<endl;return LLAVEABR;}
"}"						{cout<<"llavecerr"<<endl;return LLAVECERR;}
"("						{cout<<"parentesis abriendo"<<endl; return PARENTESISABR;}
")"						{cout<<"parentesis cerrando"<<endl; return PARENTESISCERR;}
[0-9]+ 						{cout<<"num"<<endl;return NUM;}
"="						{cout<<"igual"<<endl;return IGUAL;}
"+"						{cout<<"suma"<<endl;return SUMA;}
"-"						{cout<<"menos"<<endl;return MENOS;}
"*"						{cout<<"multi"<<endl;return MULTI;}
"^"						{cout<<"poten"<<endl;return POTEN;}
":"						{cout<<"dosptos"<<endl;return DOSPTOS;}
"#"						{cout<<"numeral"<<endl;return NUMERAL;}
\" 						{cout<<"comillas"<<endl;return COMILLAS;}
\%						{cout<<"porcentaje"<<endl;return PORCENTAJE;}
","						{cout<<"coma"<<endl;return COMA;}
[ \t]						{}
\n 							{lineas++;}
.
%%

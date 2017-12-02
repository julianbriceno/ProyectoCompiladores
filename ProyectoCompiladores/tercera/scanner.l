%option noyywrap

%{

#include<cstdio>
#include<iostream>
#include<list>
#include"parser.tab.h"
using namespace std;
int lineas=1;

list<char *> reserved;

void load_reserved();
bool is_reserved(char *f);
void print_reserved();
void delete_reserved();


%}

DIGITO	[0-9]
NUMERO	{DIGITO}+
%%




[a-zA-Z_][a-zA-Z_0-9]* {

	yylval.sval=strdup(yytext);
	if(is_reserved(yytext))
	{
		return TYPE;
	}
	return ID;

}

{NUMERO} {yylval.ival=atoi(yytext); return NUM;}

";" {return SEMICOLON;}

"{"	{return LLAVEIZQ;}

"}"	{return LLAVEDER;}

"["	{return CORIZQ;}

"]"	{return CORDER;}
[ \t]  {}
"\n" lineas++;
.	{cout << "Error lexico linea "<<lineas<< endl; exit(0);}


%%

void load_reserved()
{
	char *p1=(char *)malloc(strlen("int"));
	strcpy(p1,"int");
	reserved.push_back(p1);
	char *p2=(char *)malloc(strlen("float"));
	strcpy(p2,"float");
	reserved.push_back(p2);
	char *p3=(char *)malloc(strlen("char"));
	strcpy(p3,"char");
	reserved.push_back(p3);
}

bool is_reserved(char *f)
{
	list<char *>::iterator it=reserved.begin();
	for(it;it!=reserved.end();++it)
	{
		if(!strcmp(f,*it))
		{
			return true;
		}
	}
	return false;
}

void print_reserved()
{
	list<char *>::iterator it=reserved.begin();
	for(it;it!=reserved.end();++it)
	{
		cout<<*it<<endl;
	}
}


void delete_reserved()
{
	list<char *>::iterator it=reserved.begin();
	for(it;it!=reserved.end();++it)
	{
		free(*it);
	}
}

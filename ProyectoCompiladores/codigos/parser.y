%{
	#include<cstdio>
	#include<iostream>
	using namespace std;

	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	extern int lineas;
	void yyerror(const char *);

%}

%union
{
	char *strval;
	float fval;
	char a;
}
%token COMENTARIOUNO
%token COMENTARIODOS
%token PRINTF
%token SCANF
%token INT
%token FLOAT
%token CHAR
%token ID
%token PUNTO
%token PTOCOMA
%token LLAVEABR
%token LLAVECERR
%token PARENTESISABR
%token PARENTESISCERR
%token NUM
%token IGUAL
%token SUMA
%token MENOS
%token MULTI
%token POTEN
%token DOSPTOS
%token NUMERAL
%token COMILLAS
%token MAIN
%token IF
%token DO
%token WHILE
%token FOR
%token PORCENTAJE
%token COMA

%right IGUAL
%left SUMA MENOS
%left MULTI
%left POTEN
%left COMILLAS
%left PARENTESISABR

%start programa

%%

programa: 
	cabecera main 
	;
cabecera: 
	NUMERAL ID COMILLAS ID PUNTO ID COMILLAS
	|
	cabecera NUMERAL ID COMILLAS ID PUNTO ID COMILLAS
	;
main:
	INT MAIN PARENTESISABR parametros PARENTESISCERR llaves
	;
parametros:
	INT ID COMA CHAR MULTI MULTI ID
	|
	%empty
	;
llaves:
	LLAVEABR cuerpo LLAVECERR
	;
cuerpo:
	cuerpo declaracion
	|
	cuerpo estructura
	|
	cuerpo asignacion
	|
	%empty
	;
declaracion:
	INT ID IGUAL NUM PTOCOMA
	|
	FLOAT ID IGUAL NUM PTOCOMA
	|
	CHAR ID IGUAL ID PTOCOMA
	;
estructura:
	IF PARENTESISABR ID IGUAL IGUAL NUM PARENTESISCERR llaves 
	|
	IF PARENTESISABR ID IGUAL IGUAL CHAR PARENTESISCERR llaves
	|
	IF PARENTESISABR ID IGUAL IGUAL NUM PARENTESISCERR ID IGUAL NUM PTOCOMA
	|
	IF PARENTESISABR ID IGUAL IGUAL CHAR PARENTESISCERR ID IGUAL NUM PTOCOMA
	|
	IF PARENTESISABR ID IGUAL IGUAL NUM PARENTESISCERR ID IGUAL CHAR PTOCOMA
	|
	IF PARENTESISABR ID IGUAL IGUAL CHAR PARENTESISCERR ID IGUAL CHAR PTOCOMA
	;
asignacion:
	ID IGUAL NUM PTOCOMA
	|
	ID IGUAL CHAR PTOCOMA
	;
%%

int main(int argc, char **argv)
{
	if(argc != 2)
	{
		cout<<"ERROR: Archivo invalido"<<endl;
		return -1;
	}
	FILE *archivo = fopen(argv[1],"r");
	if(!archivo)
	{
		printf("ERROR: No se puedo abrir el archivo");
		return -1;
	}
	yyin = archivo;
	yyparse();
	cout<<"EXITO: Parsing Correcto."<<endl;
}

void yyerror(const char *s)
{
	cout<<"***ERROR: Mensaje: "<<s<<". Linea: "<<lineas<<"***"<<endl;
	exit(-1);
}

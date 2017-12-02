%{
#include<iostream>
#include<cstring>
#include<list>
using namespace std;
#include<cstdlib>
#include<cstdio>


list<list<char *> > TS;
int cantErrores=0;
extern int lineas;
extern int yyparse();
extern int yylex();
extern FILE *yyin;
extern list<char *> reserved; 
void yyerror(const char *);
extern bool is_reserved(char *);
extern void load_reserved();
extern void delete_reserved();
void add_scope();
void print_TS();
void delete_scope();
bool in_TS(char *p);
bool insert_TS(char *p);
void release_TS();
void get_scope();
int get_scope_size();
int total = 0;
int acum = 1;
int indice = -1;
int tamano[100];
int ambito = 0;
int parcial = 0;


%}

%union{
	char *sval;
	int ival;
}

%token<sval> ID
%token<sval> TYPE
%token<ival> NUM

%token SEMICOLON
%token LLAVEIZQ
%token LLAVEDER
%token CORIZQ
%token CORDER


%%

program:
	conjunto {
		if(cantErrores>0)
			cout<<endl<<endl<<"***ERROR: tipo - Semantico***"<<endl;
		else
			cout<<endl<<endl<<"Exito!"<<endl;
	}
	;

conjunto:
	LLAVEIZQ { add_scope(); } conjunto1  LLAVEDER { delete_scope(); }
	;
conjunto1:
	conjunto1 LLAVEIZQ { add_scope(); } conjunto1 LLAVEDER { delete_scope(); } 
	|
	conjunto1 decl SEMICOLON 
	|
	decl SEMICOLON
	;

decl:
	TYPE ID vector  {
		if(in_TS($2))
		{
		
			cout<<"*ERROR: variable ->"<<$2<<"<- YA declarada. Linea: "<<lineas<<"*"<<endl;
			cantErrores++;
		}
		else
		{
			if(!strcmp($1,"int")){
				tamano[indice] += 5 * acum;
				total += 5 * acum;
				parcial += 5 * acum;
			}
			else
			{
				if(!strcmp($1,"float")){
					tamano[indice] += 10 * acum;
					total += 10 *acum;
					parcial += 10 * acum;
				}
				else
				{
					if(!strcmp($1,"char")){
						tamano[indice] += 1 *acum;
						total += 1 *acum;
						parcial += 1 * acum;
					}
				}
			}	
			insert_TS($2);

		}
		acum = 1;
		free($1);
		free($2);

	}
	|
	TYPE ID {
		if(in_TS($2))
		{		
			cout<<"*ERROR: variable ->"<<$2<<"<- YA declarada. Linea: "<<lineas<<"*"<<endl;
			cantErrores++;
		}
		else
		{
			if(!strcmp($1,"int")){
				tamano[indice] += 5;
				total += 5;
				parcial += 5;
			}
			else
			{
				if(!strcmp($1,"float")){
					tamano[indice] += 10;
					total += 10;
					parcial += 10;
				}
				else
				{
					if(!strcmp($1,"char")){
						tamano[indice] += 1;
						total += 1;
						parcial += 1;
					}
				}
			}	
			insert_TS($2);
		
		}
		free($1);
		free($2);
	}
	;

vector:
	vector CORIZQ NUM CORDER{
		acum *= $3;		
	}
	|
	CORIZQ NUM CORDER {
		acum *= $2;
	}
	; 

%%

void add_scope()
{
	indice++;
	tamano[indice] = 0;
	list<char *> scope_list;
	TS.push_back(scope_list);
}

void delete_scope()
{
	if(parcial > ambito){
		ambito = parcial;
	}

	parcial -= tamano[indice];	
	indice--;
	
	cout <<"Ambitos antes de eliminar "; 
	print_TS();
	list<list<char *> >::iterator it;
	it=TS.end();
	it--;
	list<char *>::iterator it2;
	it2=(*it).begin();
	
	for(it2;it2!=(*it).end();it2++)
		free(*it2);
	TS.pop_back();

	cout <<endl<<"Ambitos despues de eliminar "; 
	print_TS();
}

bool in_TS(char *p)
{
	list<list<char *> >::iterator it;
	it=TS.end();
	it--;
	
	list<char *>::iterator it2;
	it2=(*it).begin();
	for(it2;it2!=(*it).end();it2++)
	{
		if(!strcmp(*it2,p))
		{
			return true;
		}
	}

	return false;	
}

void print_TS()
{
	list<list<char *> >::iterator it;
	it=TS.end();
	it--;
	
	for(int i=0;i<TS.size();i++)
	{
		cout<<"\nEn lista "<<i<<": ";
		list<char *>::iterator it2;
		it2=(*it).begin();
		for(it2;it2!=(*it).end();it2++)
			cout<<*it2<<" ";
		it--;
	}
	cout<<endl;
}


bool insert_TS(char *p)
{
	char *aux=strdup(p);
	if(in_TS(aux))
		return false;
	list<list<char *> >::iterator it;
	it=TS.end();
	it--;
	(*it).push_back(aux);

	return true;
}

void release_TS()
{
	for(int i=0;i<TS.size();i++)
	{
		list<list<char *> >::iterator it;
		it=TS.end();
		it--;
		list<char *>::iterator it2;
		it2=(*it).begin();
		
		for(it2;it2!=(*it).end();it2++)
			free(*it2);
		TS.pop_back();
	}
}

void get_scope()
{
	list<list<char *> >::iterator it;
	it=TS.end();
	it--;
	list<char *>::iterator it2;
	for(it2=(*it).begin();it2!=(*it).end();it2++)
		cout<<*it2<<endl;
}

int get_scope_size()
{
	list<list<char *> >::iterator it;
	it=TS.end();
	it--;
	return (*it).size();
}


void yyerror(const char *s)
{
    cout<<"parse error "<<s<<" "<<"linea:"<<lineas<<endl<<endl;
    delete_reserved();
}


int main(int argc,char **argv)
{
    if(argc!=2)
    {
        return -1;
    }
    FILE *f=fopen(argv[1],"r");
    yyin=f;
    load_reserved();
    
    yyparse();
    
		cout<<"ambito " <<ambito <<endl; 
    cout << "total "<<total <<endl; 
 		 
    delete_reserved();
    release_TS();
    return 0;
}

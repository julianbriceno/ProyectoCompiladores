/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Ejercicio 3
-- Practica 0
-- Br. Julian Briceño
-- 19895266
-- Sistemas Operativos , A2016
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
#include <stdio.h>		
#include <stdlib.h>		

int main(int argc, char **argv)
{

	// Declaracion de las variables
	FILE* fichero;
	char buffer[300];
	
	// Operaciones
	fichero = fopen(argv[1], "r");
	if (fichero == NULL){
 		return 1;
 	}
	while (feof(fichero) == 0)
 	{
 		if(fgets(buffer,300,fichero) !=NULL){
			printf("%s",buffer);
		}
 	}
    fclose(fichero);
	
	return 0;
}

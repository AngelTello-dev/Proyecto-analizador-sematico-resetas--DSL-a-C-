#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct simbolo{
	char *nombre;
	int tipo;
	struct simbolo *siguiente;
};

typedef struct simbolo simbolo;
simbolo *ts = NULL;

struct simbolo *crea_simbolo(char *nombre, int tipo, struct simbolo *siguiente);
int esta_vacia(struct simbolo *primer_simbolo);
struct simbolo *inserta_simbolo(struct simbolo *primer_simbolo, char *nombre, int tipo);
int esta_en_tabla(struct simbolo *primer_simbolo, char *nombre);
int es_constante(struct simbolo *primer_simbolo, char *nombre); 
void imprimir_tabla(struct simbolo *primer_simbolo);


struct simbolo *crea_simbolo(char *nombre, int tipo, struct simbolo *siguiente){
	struct simbolo *nuevo_simbolo = (struct simbolo*) malloc(sizeof(struct simbolo));
	if(nuevo_simbolo == NULL){
		printf("\nProblema al crear el nuevo nodo");
		exit(0);
	}
	
	nuevo_simbolo->nombre = (char *) malloc(strlen(nombre)+1);
	if(nuevo_simbolo->nombre == NULL){
		printf("\nNo se pudo asignar memoria para el nombre");
		free(nuevo_simbolo);
		return NULL;
	}
	strcpy(nuevo_simbolo->nombre, nombre);
	nuevo_simbolo->tipo = tipo; 
	nuevo_simbolo->siguiente = siguiente;
	
	return nuevo_simbolo;
}

int esta_vacia(struct simbolo *primer_simbolo){
	return primer_simbolo == NULL;
}

struct simbolo *inserta_simbolo(struct simbolo *primer_simbolo, char *nombre, int tipo){
	return crea_simbolo(nombre, tipo, primer_simbolo);
}

int esta_en_tabla(struct simbolo *primer_simbolo, char *nombre){
	struct simbolo *aux = primer_simbolo;
	while(aux != NULL){
		if(strcmp(aux->nombre, nombre) == 0)
		    return 1;
        aux = aux->siguiente;
	}
	return 0;
}

int es_constante(struct simbolo *primer_simbolo, char *nombre){
	struct simbolo *aux = primer_simbolo;
	while(aux != NULL){
		if(strcmp(aux->nombre, nombre) == 0)
		    return aux->tipo; 
        aux = aux->siguiente;
	}
	return 0;
}

void imprimir_tabla(struct simbolo *primer_simbolo){
	if(esta_vacia(primer_simbolo)){
		printf("\nLa tabla no tiene simbolos");
		return;
	}
	struct simbolo *aux = primer_simbolo;
	printf("\n--- TABLA DE SIMBOLOS ---\n");
	while(aux != NULL){
		printf("Nombre: %-15s | Tipo: %s\n", aux->nombre, aux->tipo == 1 ? "CONSTANTE" : "VARIABLE");
		aux = aux->siguiente;
	}
	printf("-------------------------\n");
}

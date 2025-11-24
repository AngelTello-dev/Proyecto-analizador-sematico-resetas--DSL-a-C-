# Proyecto analizador-sematico-resetas (DSL a C)

![Badge C](https://img.shields.io/badge/Lenguaje-C-blue)
![Badge Flex](https://img.shields.io/badge/Herramienta-Flex-green)
![Badge Bison](https://img.shields.io/badge/Herramienta-Bison-red)
![Badge UACM](https://img.shields.io/badge/Universidad-UACM(SLT)-orange)

Este proyecto es un compilador funcional para un Lenguaje de Dominio Específico (DSL) con temática culinaria. El sistema analiza recetas escritas en un lenguaje propio, valida su lógica semántica y genera automáticamente código C estándar listo para compilarse y ejecutarse.

Desarrollado para la asignatura de **Programación de Sistemas** en la **Universidad Autónoma de la Ciudad de México (UACM)**.

## Características del Compilador

El sistema realiza un proceso completo de traducción que incluye:

1.  **Análisis Léxico:** Identificación de tokens (ingredientes, recetas, acciones).
2.  **Análisis Sintáctico:** Validación de la estructura gramatical de la receta.
3.  **Análisis Semántico (Tabla de Símbolos):**
    * **Detección de Duplicados:** Evita declarar el mismo ingrediente dos veces.
    * **Variables No Declaradas:** Bloquea el uso de ingredientes que no existen.
    * **Protección de Constantes:** Impide modificar valores declarados como `receta` (constantes).
    * **Validación de Ciclos:** Asegura que las variables de iteración existan.
4.  **Generación de Código:** Produce un archivo `salida.c` con la lógica equivalente en C.

## Capturas de Pantalla

A continuación se muestra el funcionamiento del compilador:

### 1. Compilación Exitosa
*Se muestra el proceso de `make` y la generación de la tabla de símbolos.*

<img width="653" height="608" alt="miproyecto1" src="https://github.com/user-attachments/assets/1f8ebd56-54e2-47fb-9c1d-e18ef45effbf" />

### 2. Ejecución del Programa Generado
*Ejecución de la receta final (`./ejecutable`) con interacción de usuario.*

<img width="669" height="370" alt="miproyecto1" src="https://github.com/user-attachments/assets/ce54ca6a-be0e-43e0-a9bd-b90cc4691aba" />

### 3. Detección de Errores Semánticos
*El compilador detectando variables duplicadas y constantes modificadas.*

<img width="1758" height="758" alt="error" src="https://github.com/user-attachments/assets/dc89905e-cd5b-48f5-8507-f736c70aad24" />

<img width="1233" height="354" alt="error" src="https://github.com/user-attachments/assets/136e783c-a7dc-4f29-99d6-031639f19171" />

<img width="1424" height="462" alt="error" src="https://github.com/user-attachments/assets/00b1bf6e-08ae-48d5-a2a1-65da477655c1" />


## Requisitos de Instalación

Para ejecutar este proyecto necesitas un entorno Linux con las siguientes herramientas:

* **GCC** (GNU Compiler Collection)
* **Flex**
* **Bison**
* **Make**

**Instalación en Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install build-essential flex bison
```
**Autor:**
Angel Antonio Tello Montes De Oca - Desarrollo, Lógica y Documentación

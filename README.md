# El3310-Proy2-2s2025

Este repositorio contiene la implementación de un procesador uniciclo basado en la arquitectura RISC-V (rv32i) para el curso EL3310 - Diseño de Sistemas Digitales, TEC.

## Descripción General

Este proyecto consiste en diseñar, implementar y simular un procesador RISC-V uniciclo capaz de ejecutar un set de instrucciones del conjunto rv32i.
Las siguientes imagenes muestran tanto el diagrama de flujo como el diagrama de bloques de la propuesta implementada del procesador.

Diagrama de Flujo
![Diagrama de Flujo] (./Diagrama_Flujo.png)

Diagrama de Bloques
![Diagrama de Bloques] (./Diagrama_Bloques.png)

## Módulos

El diseño del procesador se realizó con HDL (Hardware Description Language) por medio de SystemVerilog con una configuración modular para una implementación más sencilla y reutilizable.

### Módulo "top.sv"

Este módulo realiza la conexión de las memorias de instrucción y datos con el resto de bloques del  procesador.

### Módulo "RISCVunicycle.sv"

Este módulo maneja las conexiones entre la unidad de control y el datapath.

### Módulo "control_unit.sv"

Este módulo maneja las señales entre el decodificador de instrucciones y el de la ALU.

### Módulo "datapath.sv"

Este módulo se encarga de la ruta de datos controlando la lógica de PC, el archivo de registros, la ALU, el extensor del inmediato, el adder y los MUX.

### Módulo "maindeco.sv"

Este módulo se encarga de decodificar la instrucción y habilitar o deshabilitar las señales de control, según el tipo de instrucción.

### Módulo "aludeco.sv"

Este módulo decodifica la señal de control proveniente de "maindeco.sv" junto a la instrucción para enviar producir una señal de control para la ALU.

### Módulo "alu.sv"

Este módulo controla la lógica de la ALU.

### Módulo "imm_ext"

Este módulo toma la instrucción y según su tipo maneja la lógica para extender el valor del inmediato del mismo.

### Módulo "register_file.sv"

Este módulo maneja la lógico del archivo de registros tomando las direcciones de lainstrucción y cargando los registros.

### Módulo "pc_register"

Este módulo se encarga de la lógica de proóximo PC.

### Módulos "mux4.sv" y "mux21.sv"

Estos módulos son un MUX 4:1 y un MUX 2:1. El primero se encarga de elegir el valor de resultado y 
el segundo se utliza para escoger el valor de "PCNext" y la señal de la segunda entreda de la ALU.

### Módulo "adder.sv"

Un "adder" simple que modifica el valor de "PCNext".

### Módulos "instr_mem.sv" y "data_mem.sv"

Módulos que se encargan de la memoria. El "instr_mem.sv" inicializa los registros y carga el programa, "data_mem.sv" controla la lectura y escritura en la memoria de datos.

## Programas de Prueba

## Resultados

## Referencias
Sarah Harris and David Harris. Digital Design and Computer Architecture: RISC-V Edition. Morgan
Kaufmann, Cambridge, MA, 1st edition, 2021.
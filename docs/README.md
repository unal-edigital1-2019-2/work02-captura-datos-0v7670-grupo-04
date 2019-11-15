##  ELECTRÓNICA DIGITAL 1 2019 -2 UNIVERSIDAD NACIONAL DE COLOMBIA 

## TRABAJO 02- diseño y prueba del HDL para la cámara OV7670

## Integrantes

1. Miguel Angel Martinez Fernandez 1024566585
1. David Ricardo Lugo Venegas 1075872618

## Desarrollo

### Diseñar el sistema digital de captura de los pixeles de la cámara.

	Al diseñar este modulo se tuvo en cuenta que al capturar los datos se esta capturando datos de la camara en formato RGB 565, dado que para el correcto funcionamiento e implementacion de los demas modulos, se realizara un muestreo de estos 16 bits a un formato RGB 332 con 8 bits, para realizar eso primero se tuvo en cuenta el diagrama de tiempo que maneja la camara OV7670 que se puede ver a continuacion

	
![CAPTURADATOS1](https://github.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-04/blob/master/docs/figs/imagen1.PNG)

teniendo en cuenta el diagrama estructural de los modulos, vemos que recibiremos 4 inputs de la camara, los cuales hemos llamado Href (El cual nos dara la señal de cuando la camara este transmitiendo un pixel),Vsync (sincronizacion vertical),Pclk (reloj de la camara para realizar el proceso sincronamente) y datos_in (Es donde guardamos los datos del byte del pixel que esta transmitiendo en ese instante)

	![CAPTURADATOS2](https://github.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-04/blob/master/docs/figs/imagen2.png)

### Diseñar el downsampler y transmitir la información al buffer de memoria.

Para realizar la captura de datos usaremos un registro que lo llamamos f_data_in565 [7:0] donde guardaremos el primer byte del formato 565 y acontinuacion en el siguiente ciclo de Pclk concatenaremos en otro registro el cual llamamos s_data_in565 [15:0] el primer byte obtenido con el siguiente que esta por venir, asi tendremos guardados los 16 bits en nuestro registro s_data_in565.A continuacion para realizar el muestro a formato RGB 332 usaremos solo los bits mas significativos s_data_in565[14:12] para el rojo, s_data_in565[9:7] para el verde y s_data_in565[4:3] para el azul y se envia directamente a la ram desarrollada en el trabajo anterior como se aprecia en la siguiente imagen, para analizar mas detalladamente el procedimiento realizado interno referirse a /src/test_cam.v.

	![CAPTURADATOS3](https://github.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-04/blob/master/docs/figs/imagen3.PNG)

### Generar dos señales de reloj de 25Mhz y 24 Mhz para la pantalla VGA y la Cámara respectivamente.

	Para realizar este modulo se utilizo el siguiente archivo generado por la funcionalidad del ISE clock wizard hdl/src/PLL/clk_100MHZ_to_25M_24M, en donde por debido a problemas con la licencia no fue posible generarse en nuestro entorno de trabajo sino en el del profesor de taller, el proceso se describe a continuacion 

1. Teniendo el proyecto de la camara abierto en el ISE, vamos a la paleta de opciones en la parte superior y buscamos Tools-> Core generator
1. En la parte izquierda de la ventana que se abre buscamos Clocking Wizard
1. Se abrira una nueva pestaña en donde configuraremos la fuente de reloj, que en nuestro caso es de 100 Mhz el cual es el reloj dela Nexys 4, y seleccionaremos Global Buffer.
1. en la siguiente pestaña configuraremos las salidas en donde dejaremos en 24000 y 25000 respectivamente a CLK-OUT1 y CLK-OUT2 en output Freq.
1. Paso seguido dejamos el resto de configuración predeterminadamente y damos click en generate.




## Implementación 

Al culminar los hitos anteriores deben:

1. Crear el archivo UCF.

El ucf se creo satisfactoriamente agregando las entradas que provienen de la cámara Href, Vsync, Pclk, [DW-1:0] datos_in. Fue necesario agregar el siguiente comando “NET "Pclk" CLOCK_DEDICATED_ROUTE = FALSE;” para el correcto funcionamiento. Esto nos permitió generar el archivo .bit.

2. Realizar el test de la pantalla. Programar la FPGA con el bitstream del proyecto y no conectar la cámara. ¿Qué espera visualizar?, ¿Es correcto este resultado ?

Al realizar el test en la pantalla se observo una franja horizontal verde con puntos grises, una franja horizontal  blanca, una franja horizontal negra con puntos grises y una franja horizontal blanca; resultado esperado debido a los valores que se introdujeron en el archivo image.men.

3. Configure la cámara en test por medio del bus I2C con ayuda de Arduino. ¿Es correcto el resultado? ¿Cada cuánto se refresca el buffer de memoria ?

Debido a que no se logro adquirir el arduino a tiempo, la configuración de la camara sera pospuesta para la siguiente semana, para realizar esto nos basaremos en un paso a paso que se puede encontrar en este video "https://www.youtube.com/watch?v=6bfY9JXOppI&t=295s" y donde realizaremos la siguiente conexion entre la camara y el arduino.

![CAPTURADATOS](https://github.com/unal-edigital1-2019-2/work02-captura-datos-0v7670-grupo-04/blob/master/docs/figs/imagen4.png)

El buffer de memoria de la camara se refresca cada 33,3 ms.

4. ¿Qué falta implementar para tener el control de la toma de fotos ?

Lo unico faltante para tener el control de la toma de fotos es una señal de entrada la cual la podemos asociar a un pulsador de la FPGA para poder decidir el momento en que deje de capturar datos o en otras palabras tomar la foto.




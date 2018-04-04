# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo;
2. Implementar un algoritmo de anti-aliasing para sus aristas; y,
3. Hacer shading sobre su superficie.

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/framesjs/releases).

## Integrantes

Máximo 3.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|Omar Roa|[oeroaq](https://oeroaq.github.io/)|
|Fernando Vargas|[fevargasmo](https://fevargasmo.github.io/)|

## Discusión
Describa los resultados obtenidos. Qué técnicas de anti-aliasing y shading se exploraron? Adjunte las referencias. Discuta las dificultades encontradas.
- Resultados obtenidos:

Triangulo en cuadricula
<p align="center">
<img src="https://github.com/fevargasmo/Raster_ws/blob/master/images/triangulo%20en%20cuadriculada.png" alt="triangulo en cuadriculada" height="500" width="540"/>
  </p>
  
 Anti-aliasing con contorno
  <p align="center">
<img src="https://github.com/fevargasmo/Raster_ws/blob/master/images/antialiasing%20contorno.png" alt="antialiasing contorno" height="500" width="540"/>
  </p>
  
Anti-aliasing sin contorno
  <p align="center">
<img src="https://github.com/fevargasmo/Raster_ws/blob/master/images/antialiasing%20sin%20contorno.png" alt="antialiasing sin contorno" height="500" width="540"/>
  </p>
  
Grilla media
  <p align="center">
<img src="https://github.com/fevargasmo/Raster_ws/blob/master/images/cuadricula%20media.png" alt="Grilla media" height="500" width="540"/>
  </p>
    
Grilla grande
  <p align="center">
<img src="https://github.com/fevargasmo/Raster_ws/blob/master/images/cuadricula%20alejada.png" alt="Grilla grande" height="500" width="540"/>
  </p>

- Anti-aliasing:
 Subsampling: subdividir cada píxel en n zonas. La intensidad del color es proporcional al numero de zonas que pertenecen al triangulo.

- Shading:
Interpolación: cada nodo del triangulo tiene un color inicial. Los puntos dentro del triangulo tienen una proporción de cada color dado su distancia a cada nodo.

- Referencias:
  - [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
  - [Triangle rasterization in practice](https://fgiesen.wordpress.com/2013/02/08/triangle-rasterization-in-practice/)
- Dificultades:

    - La librería [frames](https://github.com/VisualComputing/framesjs/releases) aunque intuitiva no cuenta con asignar escalares a un vector de clase ```Vector```  de 2 dimensiones, solo de 3 y un vector completo.
    - Se intenta realizar Shading dependiendo de si es raster o no de manera unificada en una sola función pues el código fuente de las funciones ```antialiasing``` y ```noAntialiasig``` se repite pero no se puede implementar.
    - En el momento de hacer antialiasin el color tiende a blanco por ende este debe ser dividido por la cantidad de la malla de calculo para poder conservar la proporcion del color y que este no se vea afectado por las 2^n iteraciones del antialiasing y solo se tome su proporcionalidad.

## Entrega

* Modo de entrega: [Fork](https://help.github.com/articles/fork-a-repo/) la plantilla en las cuentas de los integrantes (de las que se tomará una al azar).
* Plazo: 1/4/18 a las 24h.

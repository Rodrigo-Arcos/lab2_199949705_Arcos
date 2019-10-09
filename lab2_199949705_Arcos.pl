%----------------------------------------REPRESENTACION-----------------------------------------------------------
%Los siguientes cuatro TDAs son representados en una lista, en la cual cada posicion de esta tiene las siguientes caracteristicas
%1.- Enemigos
%	->number identificador (0)
%	->number numero del gusano
%	->number x
%	->number y

%2.- Jugador
%	->number identificador (1)
%	->number numero del gusano
%	->number x
%	->number y

%3.- Disparos
%	->number identificador (2)
%	->number angulo
%	->number velocidad
%	->number x
%	->number y

%4.- Obstaculos
%	->number identificador (3)
%	->number x
%	->number y

%5.- Suelo
%	->number x
%	->number y

%Estos TDAs seran almacenados en una lista, el cual sera la representacion del escenario, los primeros elementos de esta lista seran
%las dimensiones del escenario, luego el suelo, obstaculos y finalmente los gusanos y proyectiles.
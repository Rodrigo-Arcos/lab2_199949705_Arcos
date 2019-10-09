%-------------------------------------------------REPRESENTACION-----------------------------------------------------------------
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

%-------------------------------------------------CONSTRUCTORES-----------------------------------------------------------------
gusano(Id, IdGusano, PosX, PosY, Tda):- (Id == 0; Id == 1), IdGusano > 0, PosX > 0, PosY > 0, Tda = [Id, IdGusano, PosX, PosY], !.
disparo(Id, Angulo, Velocidad, PosX, PosY, Tda):- Id == 2, (Angulo >= 0; Angulo =< 360), Velocidad > 0, PosX > 0, PosY > 0, 
												Tda = [Id, Angulo, Velocidad, PosX, PosY], !.
obstaculo(Id, PosX, PosY, Tda):- Id == 3, PosX > 0, PosY > 0, Tda = [Id, PosX, PosY], !.
suelo(PosX, PosY, Tda):- PosX > 0, PosY > 0, Tda = [PosX, PosY], !.

%-------------------------------------------PREDICADOS DE PERTENENCIA------------------------------------------------------------
esGusano(ListGusano):- length(ListGusano, Len), Len == 4, verificarGusano(ListGusano), !.
verificarGusano([Id, IdGusano, PosX, PosY]):- gusano(Id, IdGusano, PosX, PosY, _), !.

esDisparo(ListDisparo):- length(ListDisparo, Len), Len == 5, verificarDisparo(ListDisparo), !.
verificarDisparo([Id, Angulo, Velocidad, PosX, PosY]):- disparo(Id, Angulo, Velocidad, PosX, PosY, _), !.

esObstaculo(ListObst):- length(ListObst, Len), Len == 3, verificarObstaculo(ListObst), !.
verificarObstaculo([Id, PosX, PosY]):- obstaculo(Id, PosX, PosY, _), !.

esSuelo(ListSuelo):- length(ListSuelo, Len), Len == 2, verificarSuelo(ListSuelo), !.
verificarSuelo([PosX, PosY]):- suelo(PosX, PosY, _), !.

%----------------------------------------------------SELECTORES------------------------------------------------------------------
%GUSANO
gusano_getId(ListGusano, Id):- esGusano(ListGusano), obtenerPosicion(ListGusano, 0, Id).
gusano_getIdGusano(ListGusano, IdGusano):- esGusano(ListGusano), obtenerPosicion(ListGusano, 1, IdGusano).
gusano_getPosX(ListGusano, PosX):- esGusano(ListGusano), obtenerPosicion(ListGusano, 2, PosX).
gusano_getPosY(ListGusano, PosY):- esGusano(ListGusano), obtenerPosicion(ListGusano, 3, PosY).

%DISPARO
disparo_getPosX(ListDisparo, PosX):- esDisparo(ListDisparo), obtenerPosicion(ListDisparo, 3, PosX).
disparo_getPosY(ListDisparo, PosY):- esDisparo(ListDisparo), obtenerPosicion(ListDisparo, 4, PosY).

%OBSTACULO
obstaculo_getPosX(ListObst, PosX):- esObstaculo(ListObst), obtenerPosicion(ListObst, 1, PosX).
obstaculo_getPosY(ListObst, PosY):- esObstaculo(ListObst), obtenerPosicion(ListObst, 2, PosY).

%SUELO
suelo_getPosX(ListSuelo, PosX):- esSuelo(ListSuelo), obtenerPosicion(ListSuelo, 0, PosX).
suelo_getPosY(ListSuelo, PosY):- esSuelo(ListSuelo), obtenerPosicion(ListSuelo, 1, PosY).

%Predicado que retorna una posicion de la lista
%Entrada: -Lista TDA 
%		  -Posicion a retornar
%Salida: Dato de la posicion buscada
obtenerPosicion([Car|_], 0, Salida):- Salida is Car, !.
obtenerPosicion([_|Cdr], Cant, Salida):- Cant1 is Cant - 1, obtenerPosicion(Cdr, Cant1, Salida), !.
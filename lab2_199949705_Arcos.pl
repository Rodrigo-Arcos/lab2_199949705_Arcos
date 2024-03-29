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

%-------------------------------------------------CONSTRUCTORES------------------------------------------------------------------
gusano(Id, IdGusano, PosX, PosY, Tda):- (Id == 0; Id == 1), IdGusano > 0, PosX > 0, PosY > 0, Tda = [Id, IdGusano, PosX, PosY], !.
disparo(Id, Angulo, Velocidad, PosX, PosY, Tda):- Id == 2, (Angulo >= 0, Angulo =< 360), Velocidad > 0, PosX > 0, PosY > 0, 
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
disparo_getAngulo(ListDisparo, Angulo):- esDisparo(ListDisparo), obtenerPosicion(ListDisparo, 1, Angulo).
disparo_getVelo(ListDisparo, Velo):- esDisparo(ListDisparo), obtenerPosicion(ListDisparo, 2, Velo).
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

%----------------------------------------------------MODIFICADORES---------------------------------------------------------------
%GUSANO
gusano_setPosX(ListGusano, PosX, NewListGusano):- esGusano(ListGusano), number(PosX), PosX > 0, gusano_getId(ListGusano, Id), gusano_getIdGusano(ListGusano, Member), 
												gusano_getPosY(ListGusano, PosY), NewListGusano = [Id, Member, PosX, PosY].
gusano_setPosY(ListGusano, PosY, NewListGusano):- esGusano(ListGusano), number(PosY), PosY > 0, gusano_getId(ListGusano, Id), gusano_getIdGusano(ListGusano, Member), 
												gusano_getPosX(ListGusano, PosX), NewListGusano = [Id, Member, PosX, PosY].


%--------------------------------------------------------------------------------------------------------------------------------
%---------------------------------R. Funcionales Obligatorio---------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------

%Predicado que generar numeros aleatorios
%Entrada: -Seed (Numero entero)
%		  -Maximo (Numero entero hasta donde se generara el numero aleatorio)
%Salida: Salida (Numero random)
numRandom(Seed, Maximo, Salida):- myRandom(Seed, XNvo), Salida is XNvo mod Maximo.
myRandom(Numero, Salida):- A is 1103515245, C is 12345, M is 2147483648, Salida is ((A * Numero) + C) mod M.

%Predicado que genera una lista con numeros random
getListaRandom(Seed, Cuantos, Maximo, Lista):- numRandom(Seed, Maximo, NumRandom), NumRandom1 is NumRandom + 1,
											myRandom(Seed, Seed1), getListaRandomR(Seed1, Cuantos, Maximo, [NumRandom1], Lista).

%Predicado que genera una lista con numeros aleatorios no repetidos
getListaRandomR(_, 1, _, Lista, ListaFinal):- ListaFinal = Lista.
getListaRandomR(Seed, Cuantos, Maximo, [Car|Cdr], Lista):- numRandom(Seed, Maximo, NumRandom), NumRandom1 is NumRandom + 1,  not(buscarEnLista([Car|Cdr], NumRandom1)),
                                               			Cuantos1 is Cuantos-1, myRandom(Seed, Seed1), insertarAlFinal([Car|Cdr], NumRandom1, Lista1),
                                               			getListaRandomR(Seed1, Cuantos1, Maximo, Lista1, Lista), !.
getListaRandomR(Seed, Cuantos, Maximo, Lista, ListaFinal):- myRandom(Seed, Seed1), getListaRandomR(Seed1, Cuantos, Maximo, Lista, ListaFinal), !.

%Predicado que inserta al final de una lista un elemento
insertarAlFinal([Car], Numero, Salida):- length([Car], Len), Len == 1, Salida = [Car,Numero], !.
insertarAlFinal([Car|Cdr], Numero, [Car|Cola]):- insertarAlFinal(Cdr, Numero, Lista1), Cola = Lista1.

%Predicado que busca en una lista un numero
%Entrada: Lista y numero a buscar en la lista
%Salida: True o False
buscarEnLista([Car|_], Numero):- Car == Numero, !.
buscarEnLista([Car|Cdr], Numero):- length([Car|Cdr], Len), Len > 1, buscarEnLista(Cdr, Numero), !.

%Predicado que convierte de grados a radianes
%Entrada: - Grados (Numero a convertir a radianes)
%Salida: Radianes (Grados en radianes)
getRad(Grados, Radianes):- Radianes is (Grados*pi)/180.

%Predicado para obtener el valor del tiempo
t(Tiempo):- Tiempo = 1.

%Predicado de la velocidad de los diparos
velocidad(Speed):- Speed is 1.
%-----------------------------------------------createScene----------------------------------------------------------------------
%Predicado que permite consultar si es posible crear un escenario válido de tamaño NxM
%Entrada: -Tamaño eje X
%		  -Tamaño eje Y
%		  -Cantidad de enemigos
%		  -Dificultad del escenario
%		  -Semilla para generar valores pseudoaleatorios
%Salida: Escenario del juego
%ESCENARIOS DE 5 x 10
%2 ENEMIGOS
%DIFICULTAD FACIL
createScene(5, 10, 2, 3, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 1, 3], [3, 1, 4], 
									[1, 1, 1, 5], [1, 2, 2, 3], [1, 3, 3, 2], [0, 1, 10, 2], [0, 2, 9, 2]], !.
%DIFICULTAD MEDIANA
createScene(5, 10, 2, 2, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 1, 3], [3, 1, 4], 
									[1, 1, 1, 5], [1, 2, 2, 3], [0, 1, 10, 2], [0, 2, 9, 2]], !.
%DIFICULTAD DIFICIL
createScene(5, 10, 2, 1, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 1, 3], [3, 1, 4], 
									[1, 1, 1, 5], [0, 1, 10, 2], [0, 2, 9, 2]], !.
%4 ENEMIGOS
%DIFICULTAD FACIL
createScene(5, 10, 4, 3, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 3, 2], [3, 4, 2],
									[3, 5, 2], [3, 1, 3], [3, 2, 3], [3, 5, 3], [3, 1, 4], [1, 1, 1, 5], [1, 2, 2, 4], [1, 3, 3, 3], [0, 1, 10, 2], [0, 2, 9, 2], [0, 3, 8, 2], [0, 4, 7, 2]], !.
%DIFICULTAD MEDIANA
createScene(5, 10, 4, 2, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 3, 2], [3, 4, 2],
									[3, 5, 2], [3, 1, 3], [3, 2, 3], [3, 5, 3], [3, 1, 4], [1, 1, 1, 5], [1, 2, 2, 4], [0, 1, 10, 2], [0, 2, 9, 2], [0, 3, 8, 2], [0, 4, 7, 2]], !.
%DIFICULTAD DIFICIL
createScene(5, 10, 4, 1, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 3, 2], [3, 4, 2],
									[3, 5, 2], [3, 1, 3], [3, 2, 3], [3, 5, 3], [3, 1, 4], [1, 1, 1, 5], [0, 1, 10, 2], [0, 2, 9, 2], [0, 3, 8, 2], [0, 4, 7, 2]], !.
%5 ENEMIGOS
%DIFICULTAD FACIL
createScene(5, 10, 5, 3, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 3, 2], 
									[3, 4, 2], [3, 7, 2], [3, 8, 2], [3, 9, 2], [3, 10, 2], [3, 1, 3], [3, 2, 3], [3, 9, 3], [3, 10, 3], [3, 1, 4], [3, 10, 4], [1, 1, 1, 5], [1, 2, 2, 4], 
									[1, 3, 3, 3], [0, 1, 10, 5], [0, 2, 9, 4], [0, 3, 8, 3], [0, 4, 7, 3], [0, 5, 6, 2]], !.
%DIFICULTAD MEDIANA
createScene(5, 10, 5, 2, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 3, 2], 
									[3, 4, 2], [3, 7, 2], [3, 8, 2], [3, 9, 2], [3, 10, 2], [3, 1, 3], [3, 2, 3], [3, 9, 3], [3, 10, 3], [3, 1, 4], [3, 10, 4], [1, 1, 1, 5], [1, 2, 2, 4], 
									[0, 1, 10, 5], [0, 2, 9, 4], [0, 3, 8, 3], [0, 4, 7, 3], [0, 5, 6, 2]], !.
%DIFICULTAD DIFICIL
createScene(5, 10, 5, 1, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 3, 2], 
									[3, 4, 2], [3, 7, 2], [3, 8, 2], [3, 9, 2], [3, 10, 2], [3, 1, 3], [3, 2, 3], [3, 9, 3], [3, 10, 3], [3, 1, 4], [3, 10, 4], [1, 1, 1, 5], 
									[0, 1, 10, 5], [0, 2, 9, 4], [0, 3, 8, 3], [0, 4, 7, 3], [0, 5, 6, 2]], !.

%ESCENARIOS DE 10 x 12
%4 ENEMIGOS
%DIFICULTAD FACIL
createScene(10, 12, 4, 3, _, Scene):- Scene = [10, 12, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [1, 2], [2, 2], [3, 2], 
									[4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], [11, 2], [12, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3], 
									[9, 3], [10, 3], [11, 3], [12, 3], [3, 1, 4], [3, 3, 4], [3, 4, 4], [3, 6, 4], [3, 6, 5], [3, 6, 6], [3, 6, 7], [3, 6, 8], [3, 9, 4], 
									[3, 10, 4], [3, 10, 5], [3, 10, 6], [3, 10, 7], [3, 10, 8], [3, 11, 4], [3, 11, 5], [3, 12, 4], [3, 12, 5], [3, 12, 6], [1, 1, 1, 5], 
									[1, 2, 2, 4], [1, 3, 3, 5], [0, 1, 12, 7], [0, 2, 11, 6], [0, 3, 10, 9], [0, 4, 9, 5]], !. 
%DIFICULTAD MEDIANA
createScene(10, 12, 4, 2, _, Scene):- Scene = [10, 12, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [1, 2], [2, 2], [3, 2], 
									[4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], [11, 2], [12, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3], 
									[9, 3], [10, 3], [11, 3], [12, 3], [3, 1, 4], [3, 3, 4], [3, 4, 4], [3, 6, 4], [3, 6, 5], [3, 6, 6], [3, 6, 7], [3, 6, 8], [3, 9, 4], 
									[3, 10, 4], [3, 10, 5], [3, 10, 6], [3, 10, 7], [3, 10, 8], [3, 11, 4], [3, 11, 5], [3, 12, 4], [3, 12, 5], [3, 12, 6], [1, 1, 1, 5], 
									[1, 2, 2, 4], [0, 1, 12, 7], [0, 2, 11, 6], [0, 3, 10, 9], [0, 4, 9, 5]], !. 
%DIFICULTAD DIFICIL
createScene(10, 12, 4, 1, _, Scene):- Scene = [10, 12, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [1, 2], [2, 2], [3, 2], 
									[4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], [11, 2], [12, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3], 
									[9, 3], [10, 3], [11, 3], [12, 3], [3, 1, 4], [3, 3, 4], [3, 4, 4], [3, 6, 4], [3, 6, 5], [3, 6, 6], [3, 6, 7], [3, 6, 8], [3, 9, 4], 
									[3, 10, 4], [3, 10, 5], [3, 10, 6], [3, 10, 7], [3, 10, 8], [3, 11, 4], [3, 11, 5], [3, 12, 4], [3, 12, 5], [3, 12, 6], [1, 1, 1, 5], 
									[0, 1, 12, 7], [0, 2, 11, 6], [0, 3, 10, 9], [0, 4, 9, 5]], !. 
%6 ENEMIGOS 
%DIFICULTAD FACIL
createScene(10, 12, 6, 3, _, Scene):- Scene = [10, 12, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [1, 2], [2, 2], [3, 2],
									[4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], [11, 2], [12, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3], 
									[9, 3], [10, 3], [11, 3], [12, 3], [3, 11, 4], [3, 11, 5], [3, 11, 6], [3, 4, 4], [3, 9, 4], [3, 2, 4], [3, 1, 4], [3, 1, 5], [3, 1, 6], 
									[3, 3, 4], [3, 12, 4], [3, 12, 5], [3, 12, 6], [3, 12, 7], [3, 12, 8], [3, 10, 4], [3, 10, 5], [3, 2, 5], [1, 1, 1, 7], [1, 2, 2, 6], [1, 3, 3, 5], 
									[0, 1, 12, 9], [0, 2, 11, 7], [0, 3, 10, 6], [0, 4, 9, 5], [0, 5, 8, 4], [0, 6, 7, 4]], !.
%DIFICULTAD MEDIANA
createScene(10, 12, 6, 2, _, Scene):- Scene = [10, 12, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [1, 2], [2, 2], [3, 2],
									[4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], [11, 2], [12, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3], 
									[9, 3], [10, 3], [11, 3], [12, 3], [3, 11, 4], [3, 11, 5], [3, 11, 6], [3, 4, 4], [3, 9, 4], [3, 2, 4], [3, 1, 4], [3, 1, 5], [3, 1, 6], 
									[3, 3, 4], [3, 12, 4], [3, 12, 5], [3, 12, 6], [3, 12, 7], [3, 12, 8], [3, 10, 4], [3, 10, 5], [3, 2, 5], [1, 1, 1, 7], [1, 2, 2, 6], [0, 1, 12, 9], 
									[0, 2, 11, 7], [0, 3, 10, 6], [0, 4, 9, 5], [0, 5, 8, 4], [0, 6, 7, 4]], !.
%DIFICULTAD DIFICIL
createScene(10, 12, 6, 1, _, Scene):- Scene = [10, 12, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [1, 2], [2, 2], [3, 2],
									[4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], [11, 2], [12, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3], 
									[9, 3], [10, 3], [11, 3], [12, 3], [3, 11, 4], [3, 11, 5], [3, 11, 6], [3, 4, 4], [3, 9, 4], [3, 2, 4], [3, 1, 4], [3, 1, 5], [3, 1, 6], 
									[3, 3, 4], [3, 12, 4], [3, 12, 5], [3, 12, 6], [3, 12, 7], [3, 12, 8], [3, 10, 4], [3, 10, 5], [3, 2, 5], [1, 1, 1, 7], [0, 1, 12, 9], 
									[0, 2, 11, 7], [0, 3, 10, 6], [0, 4, 9, 5], [0, 5, 8, 4], [0, 6, 7, 4]], !.

%ESCENARIO DE 20 x 20
%8 ENEMIGOS
%DIFICULTAD FACIL
createScene(20, 20, 8, 3, _, Scene):- Scene = [20, 20, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [13, 1], [14, 1], 
									[15, 1], [16, 1], [17, 1], [18, 1], [19, 1], [20, 1], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], 
									[11, 2], [12, 2], [13, 2], [14, 2], [15, 2], [16, 2], [17, 2], [18, 2], [19, 2], [20, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], 
									[7, 3], [8, 3], [9, 3], [10, 3], [11, 3], [12, 3], [13, 3], [14, 3], [15, 3], [16, 3], [17, 3], [18, 3], [19, 3], [20, 3], [1, 4], [2, 4], 
									[3, 4], [4, 4], [5, 4], [6, 4],[7, 4], [8, 4], [9, 4], [10, 4], [11, 4], [12, 4], [13, 4], [14, 4], [15, 4], [16, 4], [17, 4], [18, 4], 
									[19, 4], [20, 4], [1, 5], [2, 5],[3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 5], [10, 5], [11, 5], [12, 5], [13, 5], [14, 5], [15, 5], 
									[16, 5], [17, 5], [18, 5], [19, 5], [20, 5], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6], [9, 6], [10, 6], [11, 6], [12, 6],
									[13, 6], [14, 6], [15, 6], [16, 6], [17, 6], [18, 6], [19, 6], [20, 6], [3, 1, 7], [3, 2, 7], [3, 2, 8], [3, 3, 7], [3, 4, 7], [3, 6, 7], 
									[3, 7, 7], [3, 7, 8], [3, 7, 9], [3, 8, 7], [3, 8, 8], [3, 10, 7], [3, 10, 8], [3, 11, 7], [3, 15, 7], [3, 16, 7], [3, 16, 8], [3, 17, 7],
									[3, 17, 8], [3, 17, 9], [3, 17, 10], [3, 18, 7], [3, 18, 8], [3, 18, 9], [3, 18, 10], [3, 18, 11], [3, 18, 12], [3, 19, 7], [3, 19, 8], 
									[3, 19, 9], [3, 19, 10], [3, 19, 11], [3, 19, 12], [3, 19, 13], [3, 19, 14], [3, 20, 7], [3, 20, 8], [3, 20, 9], [3, 20, 10], [3, 20, 11], 
									[3, 20, 12], [3, 20, 13], [3, 20, 14], [3, 20, 15], [3, 20, 16], [1, 1, 1, 8], [1, 2, 2, 9], [1, 3, 3, 8], [0, 1, 20, 17], [0, 2, 19, 15], [0, 3, 18, 13], 
									[0, 4, 17, 11], [0, 5, 16, 9], [0, 6, 15, 8], [0, 7, 14, 7], [0, 8, 13, 7]], !.
%DIFICULTAD MEDIANA
createScene(20, 20, 8, 2, _, Scene):- Scene = [20, 20, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [13, 1], [14, 1], 
									[15, 1], [16, 1], [17, 1], [18, 1], [19, 1], [20, 1], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], 
									[11, 2], [12, 2], [13, 2], [14, 2], [15, 2], [16, 2], [17, 2], [18, 2], [19, 2], [20, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], 
									[7, 3], [8, 3], [9, 3], [10, 3], [11, 3], [12, 3], [13, 3], [14, 3], [15, 3], [16, 3], [17, 3], [18, 3], [19, 3], [20, 3], [1, 4], [2, 4], 
									[3, 4], [4, 4], [5, 4], [6, 4],[7, 4], [8, 4], [9, 4], [10, 4], [11, 4], [12, 4], [13, 4], [14, 4], [15, 4], [16, 4], [17, 4], [18, 4], 
									[19, 4], [20, 4], [1, 5], [2, 5],[3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 5], [10, 5], [11, 5], [12, 5], [13, 5], [14, 5], [15, 5], 
									[16, 5], [17, 5], [18, 5], [19, 5], [20, 5], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6], [9, 6], [10, 6], [11, 6], [12, 6],
									[13, 6], [14, 6], [15, 6], [16, 6], [17, 6], [18, 6], [19, 6], [20, 6], [3, 1, 7], [3, 2, 7], [3, 2, 8], [3, 3, 7], [3, 4, 7], [3, 6, 7], 
									[3, 7, 7], [3, 7, 8], [3, 7, 9], [3, 8, 7], [3, 8, 8], [3, 10, 7], [3, 10, 8], [3, 11, 7], [3, 15, 7], [3, 16, 7], [3, 16, 8], [3, 17, 7],
									[3, 17, 8], [3, 17, 9], [3, 17, 10], [3, 18, 7], [3, 18, 8], [3, 18, 9], [3, 18, 10], [3, 18, 11], [3, 18, 12], [3, 19, 7], [3, 19, 8], 
									[3, 19, 9], [3, 19, 10], [3, 19, 11], [3, 19, 12], [3, 19, 13], [3, 19, 14], [3, 20, 7], [3, 20, 8], [3, 20, 9], [3, 20, 10], [3, 20, 11], 
									[3, 20, 12], [3, 20, 13], [3, 20, 14], [3, 20, 15], [3, 20, 16], [1, 1, 1, 8], [1, 2, 2, 9], [0, 1, 20, 17], [0, 2, 19, 15], [0, 3, 18, 13], 
									[0, 4, 17, 11], [0, 5, 16, 9], [0, 6, 15, 8], [0, 7, 14, 7], [0, 8, 13, 7]], !.
%DIFICULTAD DIFICIL
createScene(20, 20, 8, 1, _, Scene):- Scene = [20, 20, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [13, 1], [14, 1], 
									[15, 1], [16, 1], [17, 1], [18, 1], [19, 1], [20, 1], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], 
									[11, 2], [12, 2], [13, 2], [14, 2], [15, 2], [16, 2], [17, 2], [18, 2], [19, 2], [20, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], 
									[7, 3], [8, 3], [9, 3], [10, 3], [11, 3], [12, 3], [13, 3], [14, 3], [15, 3], [16, 3], [17, 3], [18, 3], [19, 3], [20, 3], [1, 4], [2, 4], 
									[3, 4], [4, 4], [5, 4], [6, 4],[7, 4], [8, 4], [9, 4], [10, 4], [11, 4], [12, 4], [13, 4], [14, 4], [15, 4], [16, 4], [17, 4], [18, 4], 
									[19, 4], [20, 4], [1, 5], [2, 5],[3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 5], [10, 5], [11, 5], [12, 5], [13, 5], [14, 5], [15, 5], 
									[16, 5], [17, 5], [18, 5], [19, 5], [20, 5], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6], [9, 6], [10, 6], [11, 6], [12, 6],
									[13, 6], [14, 6], [15, 6], [16, 6], [17, 6], [18, 6], [19, 6], [20, 6], [3, 1, 7], [3, 2, 7], [3, 2, 8], [3, 3, 7], [3, 4, 7], [3, 6, 7], 
									[3, 7, 7], [3, 7, 8], [3, 7, 9], [3, 8, 7], [3, 8, 8], [3, 10, 7], [3, 10, 8], [3, 11, 7], [3, 15, 7], [3, 16, 7], [3, 16, 8], [3, 17, 7],
									[3, 17, 8], [3, 17, 9], [3, 17, 10], [3, 18, 7], [3, 18, 8], [3, 18, 9], [3, 18, 10], [3, 18, 11], [3, 18, 12], [3, 19, 7], [3, 19, 8], 
									[3, 19, 9], [3, 19, 10], [3, 19, 11], [3, 19, 12], [3, 19, 13], [3, 19, 14], [3, 20, 7], [3, 20, 8], [3, 20, 9], [3, 20, 10], [3, 20, 11], 
									[3, 20, 12], [3, 20, 13], [3, 20, 14], [3, 20, 15], [3, 20, 16], [1, 1, 1, 8], [0, 1, 20, 17], [0, 2, 19, 15], [0, 3, 18, 13], 
									[0, 4, 17, 11], [0, 5, 16, 9], [0, 6, 15, 8], [0, 7, 14, 7], [0, 8, 13, 7]], !.

%Predicado que permite consultar si un escenario cumple con los criterios para ser considerado valido.
%Entrada: -Escenario del juego
%Salida: True o false

%-----------------------------------------------checkScene-----------------------------------------------------------------------
checkScene(Scene):- is_list(Scene), obtenerPosicion(Scene, 0, N), N > 0, obtenerPosicion(Scene, 1, M), M > 0, obtenerTDAs(Scene, 1, ListTDAs), verificarTDAs(ListTDAs), 
					obtenerPosXY(ListTDAs, ListPosXY), verificarPosDistintas(ListPosXY), estaGusanoEnAire(ListTDAs, ListTDAs, ListPosXY), !.
%Predicado que crea una lista con las posiciones ocupadas por los TDAs
%Entrada: -Escenario del juego
%		  -Cantidad inicial de la recursion
%Salida: Lista con los TDAs del escenario del juego
obtenerTDAs([_|Cdr], Cantidad, ListTDAs):- Cantidad == 2, ListTDAs = Cdr.
obtenerTDAs([_|Cdr], Cantidad, ListTDAs):- Cantidad1 is Cantidad+1, obtenerTDAs(Cdr, Cantidad1, ListTDAs).
%Predicado que verifica que cada TDA de la lista de TDAs cumplan los criterios para ser considerado como tal
%Entrada: -Lista con los TDAs del escenario
%Salida: True o false
verificarTDAs([]):- !.
verificarTDAs([Car|Cdr]):- is_list(Car), (esGusano(Car); esDisparo(Car); esSuelo(Car); esObstaculo(Car)), verificarTDAs(Cdr), !.
%Predicado que crea una lista con las posiciones ocupadas por los TDAs
%Entrada: -Lista con los TDAs del escenario del juego
%Salida: Lista de dos elementos (ej: [PosX,PosY])
obtenerPosXY([],[]).
obtenerPosXY([Car|Cdr], [Cabeza|Cola]):- ((esGusano(Car), gusano_getPosX(Car, PosX), gusano_getPosY(Car, PosY));(esDisparo(Car), disparo_getPosX(Car, PosX), 
										disparo_getPosY(Car, PosY)); (esObstaculo(Car), obstaculo_getPosX(Car, PosX), obstaculo_getPosY(Car,PosY));(esSuelo(Car), 
										suelo_getPosX(Car, PosX), suelo_getPosY(Car,PosY))), obtenerPosXY(Cdr, Cola), Cabeza = [PosX,PosY].
%Predicado que verifica si algun elemento de la lista con las posiciones X e Y se repite
%Entrada: -Lista con las posiciones X e Y de los TDAs
%Salida: True o false
verificarPosDistintas([]).										
verificarPosDistintas([Car|Cdr]):- compararListas(Car, Cdr), verificarPosDistintas(Cdr), !.
%Predicado que compara el primer elemento de la lista con las posiciones X e Y con los demas
%Entrada: - Primer elemento de la Lista
%		  - Cola de la lista
%Salida: True or false
compararListas(_, []).
compararListas(PosXY, [Car|Cdr]):- not(posXYIguales(PosXY, Car)), compararListas(PosXY, Cdr), !.
%Predicado que compara que dos listas de dos elementos sean iguales
%Entrada: -Primera Lista con la posicion X e Y de un TDA
%		  -Segunda Lista con la posicion X e Y de un TDA
%Salida: True o false
posXYIguales([PosX,PosY], [PosX, PosY]).

%Predicado que verifica que los gusanos del escenario esten sobre un obstaculo o suelo
%modifica la posicion del gusano.
%Entrada: -Lista con las posiciones X e Y de los TDAs
%		  -Lista con los TDAs del escenario
%		  -Lista con la posicion X e Y
%Salida: True o false
estaGusanoEnAire(_, [], _).
estaGusanoEnAire(ListTDAs, [Car|Cdr], ListPosXY):- esGusano(Car), gusano_getPosX(Car, PosX), gusano_getPosY(Car, PosY), PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX, PosY1], Salida), 
												(Salida == 1; Salida == 2), estaGusanoEnAire(ListTDAs, Cdr, ListPosXY), !.
estaGusanoEnAire(ListTDAs, [Car|Cdr], ListPosXY):- (esDisparo(Car); esObstaculo(Car); esSuelo(Car)), estaGusanoEnAire(ListTDAs, Cdr, ListPosXY), !.

%-----------------------------------------------moveMember-----------------------------------------------------------------------
%Predicado que permite consultar si es posible mover un personaje aliado
%Entrada: -Escenario del juego
%		  -Personaje del equipo a mover
%		  -Direccion del movimiento
%		  -Parametro para generar valores pseudoaleatorios
%Salida: Nuevo escenario del juego
moveMember(SceneIn, _, MoveDir, _, SceneOut):- checkScene(SceneIn), MoveDir == 0, SceneOut = SceneIn.
moveMember(SceneIn, Member, MoveDir, _, SceneOut):- checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N), obtenerPosicion(SceneIn, 1, M), obtenerTDAs(SceneIn, 1, ListTDAs), 
													buscarGusano(ListTDAs, 1, Member, TDAGusano), MoveDir > 0, obtenerPosXY(ListTDAs, ListPosXY), gusano_getId(TDAGusano, Id),
													gusano_getIdGusano(TDAGusano, Member), moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir, TDAGusano, NewListTDAs),
													SceneOut = [N, M|NewListTDAs], !.
moveMember(SceneIn, Member, MoveDir, _, SceneOut):- checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N), obtenerPosicion(SceneIn, 1, M), obtenerTDAs(SceneIn, 1, ListTDAs), 
													buscarGusano(ListTDAs, 1, Member, TDAGusano), MoveDir < 0, obtenerPosXY(ListTDAs, ListPosXY), gusano_getId(TDAGusano, Id),
													gusano_getIdGusano(TDAGusano, Member), moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir, TDAGusano, NewListTDAs),
													SceneOut = [N, M|NewListTDAs], !.
%Predicado que busca en la lista TDAs el TDA del gusano Member
%Entrada: -Lista con los TDAs del escenario
%		  -Equipo del gusano a mover
%		  -Personaje del equipo a mover
%Salida: TDA de un gusano
buscarGusano([Car|_], Id, Member, TDAGusano):- esGusano(Car), gusano_getId(Car, Id), gusano_getIdGusano(Car, Member), TDAGusano = Car.
buscarGusano([_|Cdr], Id, Member, TDAGusano):- buscarGusano(Cdr, Id, Member, TDAGusano), !.
%Predicado que realizo el movimiento de un personaje hacia la derecha
%Entrada: -Cantidad de filas del escenario
%		  -Cantidad de columnas del escenario
%		  -Equipo del gusano a mover
%		  -Personaje del equipo a mover
%		  -Lista con los TDAs del escenario
%		  -Lista con las posiciones X e Y de los TDAs
%		  -Cantidad de movimientos a realizar
%		  -TDA del gusano a mover
%Salida: Lista con los TDAs del escenario actualizada
moverJugadorDer(N, M, _, _, ListTDAs, _, _, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY),(PosX > M;PosX < 1;
																	PosY > N; PosY < 1), NewListTDAs = ListTDAs, !.
moverJugadorDer(_, _, _, _, ListTDAs, _, MoveDir, TDAGusano, NewListTDAs):- MoveDir == 0, modificarPosXYGusano(ListTDAs, TDAGusano, NewListTDAs), !.
moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, _, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), PosX1 is PosX+1, gusano_getPosY(TDAGusano, PosY),
																			verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY], Salida), (Salida == 1; Salida == 2; Salida == 3),
																			moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, 0, TDAGusano, NewListTDAs), !.
moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), PosX1 is PosX+1, gusano_getPosY(TDAGusano, PosY), 
																			PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY], Salida), Salida == 0,
																			verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida1), Salida1 == 1, 
																			gusano_setPosX(TDAGusano, PosX1, TDAGusano1), MoveDir1 is MoveDir-1,
																			moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir1, TDAGusano1, NewListTDAs), !.
moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, _, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), PosX1 is PosX+1, gusano_getPosY(TDAGusano, PosY), 
																			PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY], Salida), Salida == 0,
																			verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida1), (Salida1 == 2; Salida == 3), 
																			moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, 0, TDAGusano, NewListTDAs), !.
moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), PosX1 is PosX+1, gusano_getPosY(TDAGusano, PosY),
																			PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY], Salida), Salida == 0,
																			verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida1), Salida1 == 0,
																			posXYCaidaGusano(ListPosXY, ListTDAs, [PosX1, PosY1], TDAGusano, TDAGusano1), MoveDir1 is MoveDir-1,
																			moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir1, TDAGusano1, NewListTDAs), !.
%Predicado que realizo el movimiento de un personaje hacia la izquierda
%Entrada: -Cantidad de filas del escenario
%		  -Cantidad de columnas del escenario
%		  -Equipo del gusano a mover
%		  -Personaje del equipo a mover
%		  -Lista con los TDAs del escenario
%		  -Lista con las posiciones X e Y de los TDAs
%		  -Cantidad de movimientos a realizar
%		  -TDA del gusano a mover
%Salida: Lista con los TDAs del escenario actualizada
moverJugadorIzq(N, M, _, _, ListTDAs, _, _, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY),(PosX > M;PosX < 1;
																	PosY > N; PosY < 1), NewListTDAs = ListTDAs, !.
moverJugadorIzq(_, _, _, _, ListTDAs, _, MoveDir, TDAGusano, NewListTDAs):- MoveDir == 0, modificarPosXYGusano(ListTDAs, TDAGusano, NewListTDAs), !.
moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, _, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), PosX1 is PosX-1, gusano_getPosY(TDAGusano, PosY),
																			verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY], Salida), (Salida == 1; Salida == 2; Salida == 3),
																			moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, 0, TDAGusano, NewListTDAs), !.
moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), PosX1 is PosX-1, gusano_getPosY(TDAGusano, PosY), 
																			PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY], Salida), Salida == 0,
																			verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida1), Salida1 == 1, 
																			gusano_setPosX(TDAGusano, PosX1, TDAGusano1), MoveDir1 is MoveDir+1,
																			moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir1, TDAGusano1, NewListTDAs), !.
moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, _, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), PosX1 is PosX-1, gusano_getPosY(TDAGusano, PosY), 
																			PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY], Salida), Salida == 0,
																			verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida1), (Salida1 == 2; Salida == 3), 
																			moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, 0, TDAGusano, NewListTDAs), !.
moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), PosX1 is PosX-1, gusano_getPosY(TDAGusano, PosY),
																			PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY], Salida), Salida == 0,
																			verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida1), Salida1 == 0,
																			posXYCaidaGusano(ListPosXY, ListTDAs, [PosX1, PosY1], TDAGusano, TDAGusano1), MoveDir1 is MoveDir+1,
																			moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir1, TDAGusano1, NewListTDAs), !.
%Predicado que elimina un TDAGusano de la lista con los TDAs del escenario
%Entrada: -Lista con los TDAs del escenario
%		  -Equipo del gusano a mover
%		  -Personaje del equipo a mover
%Salida: Lista con los TDAs del escenario actualizada
eliminarGusano([Car|Cdr], Id, Member, Cdr):- esGusano(Car), gusano_getId(Car, Id), gusano_getIdGusano(Car, Member).
eliminarGusano([Car|Cdr], Id, Member, [Car|Cola]):- eliminarGusano(Cdr, Id, Member, Cola), !.
%Predicado que modifica la posicion X e Y de un TDA gusano de la lista que contiene los TDAs del escenario
%Entrada: -Lista con los TDAs del escenario
%		  -TDA del gusano a modificar
%Salida: Lista con los TDAs del escenario actualizada
modificarPosXYGusano(ListTDAs, TDAGusano, NewListTDAs):- gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY), gusano_getId(TDAGusano, Id), 
														gusano_getIdGusano(TDAGusano, Member), modificarGusano(ListTDAs, PosX, PosY, Id, Member, NewListTDAs), !.
%Predicado que modifica la posicion X e Y de un TDA gusano
%Entrada: -Lista con los TDAs del escenario
%		  -Posicion X del gusano
%		  -Posicion Y del gusano
%		  -Equipo del gusano a mover
%		  -Personaje del equipo a mover
%Salida: Lista con los TDAs del escenario actualizada
modificarGusano([Car|Cdr], PosX, PosY, Id, Member, [NewTDAGusano|Cdr]):- esGusano(Car), gusano_getId(Car, Id), gusano_getIdGusano(Car, Member), 
																		gusano_setPosX(Car, PosX, TDAGusano),gusano_setPosY(TDAGusano, PosY, NewTDAGusano), !.
modificarGusano([Car|Cdr], PosX, Pos, Id, Member, [Car|Cola]):- modificarGusano(Cdr, PosX, Pos, Id, Member, Cola).
%Predicado que verifica si una posicion X e Y ya es utilizada por un TDA
%Entrada: -Lista con las posiciones X e Y de los TDAs
%		  -Lista con los TDAs del escenario
%		  -Lista con la posicion X e Y
%Salida: 0 si no se encuentra ocupada, 1 si es ocupada por un TDA obstaculo o suelo, 2 si es utilizada por un TDA gusano
verificarPosOcupadaXY([], [], _, Salida):- Salida is 0, !.
verificarPosOcupadaXY([Car|_], [Cabeza|_], PosXY, Salida):- Car == PosXY, (esObstaculo(Cabeza); esSuelo(Cabeza)), Salida is 1, !.
verificarPosOcupadaXY([Car|_], [Cabeza|_], PosXY, Salida):- Car == PosXY, esGusano(Cabeza), Salida is 2, !.
verificarPosOcupadaXY([Car|_], [Cabeza|_], PosXY, Salida):- Car == PosXY, esDisparo(Cabeza), Salida is 3, !.
verificarPosOcupadaXY([_|Cdr], [_|Cola], PosXY, Salida):- verificarPosOcupadaXY(Cdr, Cola, PosXY, Salida).
%Predicado que retorna la posicion X e Y de un gusano cuando cae al moverse, si no es posible realizar el movimiento retorna una lista vacia
%Entrada: -Lista con las posiciones X e Y de los TDAs
%		  -Lista con los TDAs del escenario
%		  -Lista con la posicion X e Y
%		  -TDA del gusano a modificar
%Salida: TDA gusano actualizado o lista vacia
posXYCaidaGusano(_, _, [_, PosY], TDAGusano, NewTDAGusano):- PosY < 1, NewTDAGusano = TDAGusano, !.
posXYCaidaGusano(ListPosXY, ListTDAs, [PosX, PosY], TDAGusano, NewTDAGusano):- PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX, PosY1], Salida), 
																			Salida == 0, posXYCaidaGusano(ListPosXY, ListTDAs, [PosX, PosY1], TDAGusano, NewTDAGusano).
posXYCaidaGusano(ListPosXY, ListTDAs, [PosX, PosY], TDAGusano, NewTDAGusano):- PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX, PosY1], Salida), 
																			Salida == 1, gusano_setPosX(TDAGusano, PosX,TDAGusano1),gusano_setPosY(TDAGusano1,PosY,NewTDAGusano),!.
posXYCaidaGusano(ListPosXY, ListTDAs, [PosX, PosY], TDAGusano, NewTDAGusano):- PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX, PosY1], Salida), 
																			(Salida == 2; Salida == 3), NewTDAGusano = TDAGusano, !.
%Predicado que cuenta la cantidad de gusanos de un equipo
%Entrada: -Lista con los TDAs del escenario
%		  -Equipo de los gusanos a contar
%		  -Cantidad de gusanos que se actualiza en la recursion
%Salida: Cantidad de gusanos de un equipo
contarGusanos([], _, Cant, Cant).
contarGusanos([Car|Cdr], Id, Cant, Total):- esGusano(Car), gusano_getId(Car, Id), Cant1 is Cant+1, contarGusanos(Cdr, Id, Cant1, Total), !.
contarGusanos([_|Cdr], Id, Cant, Total):- contarGusanos(Cdr, Id, Cant, Total), !.

%Predicado que realizar un disparo ejecutado por Member aliado
%Entrada: -Escenario del juego
%		  -Personaje del equipo a mover
%		  -Tipo del disparo
%		  -Angulo del disparo
%		  -Parametro para generar valores pseudoaleatorios
%Salida: Nuevo escenario del juego
shoot(SceneIn, Member, ShootType, Angle, _, SceneOut):- ShootType == disparoMRU, checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N), obtenerPosicion(SceneIn, 1, M), obtenerTDAs(SceneIn, 1, ListTDAs), 
														obtenerPosXY(ListTDAs, ListPosXY), buscarGusano(ListTDAs, 1, Member, TDAGusano), gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY), 
														velocidad(Speed), t(Tiempo), getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), 
														PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)), verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida), Salida == 0, 
														PosX1 > 0, PosX1 =< M, PosY1 > 0, PosY1 =< N, disparo(2, Angle, Speed, PosX1, PosY1, TDADisparo), 
														agregarTDAaListTDAs(ListTDAs, TDADisparo, ListTDAs1), SceneOut = [N, M|ListTDAs1], !.

shoot(SceneIn, Member, ShootType, Angle, _, SceneOut):- ShootType == disparoMRU, checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N), obtenerPosicion(SceneIn, 1, M), obtenerTDAs(SceneIn, 1, ListTDAs), 
														obtenerPosXY(ListTDAs, ListPosXY), buscarGusano(ListTDAs, 1, Member, TDAGusano), gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY), 
														velocidad(Speed), t(Tiempo), getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), 
														PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)), verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida), Salida == 0, 
														(PosX1 =< 0; PosX1 > M; PosY1 =< 0; PosY1 > N), SceneOut = [N, M|ListTDAs], !.

shoot(SceneIn, Member, ShootType, Angle, _, SceneOut):- ShootType == disparoMRU, checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N), obtenerPosicion(SceneIn, 1, M), obtenerTDAs(SceneIn, 1, ListTDAs), 
														obtenerPosXY(ListTDAs, ListPosXY), buscarGusano(ListTDAs, 1, Member, TDAGusano), gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY), 
														velocidad(Speed), t(Tiempo), getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), 
														PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)), verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida),
														(Salida == 1; Salida == 2; Salida == 3), eliminarTDAListTDAs(ListPosXY, ListTDAs, [PosX1,PosY1], ListTDAs1), 
														eliminarTDAListPosXY(ListPosXY, [PosX1,PosY1], ListPosXY1), verificarGusanoEnAire(ListTDAs1, ListTDAs1, ListPosXY1, ListTDAs2), 
														((contarGusanos(ListTDAs2, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(ListTDAs2, 0, 0, GusanosEne), GusanosEne > 0, 
														SceneOut = [N, M|ListTDAs2]); (contarGusanos(ListTDAs2, 1, 0, GusanosJug), GusanosJug == 0, contarGusanos(ListTDAs2, 0, 0, GusanosEne), 
														GusanosEne > 0, SceneOut = "DEFEAT"); (contarGusanos(ListTDAs2, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(ListTDAs2, 0, 0, GusanosEne), 
														GusanosEne == 0, SceneOut = "VICTORY")), !.
%Predicado que agrega al final de la lista que contiene los TDAs del escenario un TDA
%Entrada: -Lista con los TDAs del escenario
%		  -TDA a agregar
%Salida: Lista con los TDAs del escenario actualizada
agregarTDAaListTDAs([], TDADisparo, [TDADisparo]):- !. 
agregarTDAaListTDAs([Car|Cdr], TDADisparo, [Car|Cola]):- agregarTDAaListTDAs(Cdr, TDADisparo, Cola), !.

%Predicado que elimina un TDA de la lista que contiene los TDAs del escenario
%Entrada: -Lista con las posiciones X e Y de los TDAs
%		  -Lista con los TDAs del escenario
%		  -Lista con la posicion X e Y
%Salida: Lista con los TDAs del escenario actualizada
eliminarTDAListTDAs([Car|_], [_|Cdr], PosXY, Cdr):- Car == PosXY, !.
eliminarTDAListTDAs([_|Cdr], [Cabeza|Cola], PosXY, [Cabeza|Cdr1]):- eliminarTDAListTDAs(Cdr, Cola, PosXY, Cdr1).

%Predicado que elimina una Posicion X e Y de la lista que contiene las posiciones X e Y de los TDAs
%Entrada: -Lista con las posiciones X e Y de los TDAs
%		  -Lista con la posicion X e Y
%Salida: Lista con las posiciones de los TDAs actualizada
eliminarTDAListPosXY([Car|Cdr], PosXY, Cdr):- Car == PosXY, !.
eliminarTDAListPosXY([Car|Cdr], PosXY, [Car|Cdr1]):- eliminarTDAListPosXY(Cdr, PosXY, Cdr1).

%Predicado que verifica que los gusanos del escenario esten sobre un obstaculo o suelo, en caso de que el gusano cae sobre otro gusano es eliminado, en cambio, si cae sobre el TDA suelo o obstaculo se
%modifica la posicion del gusano.
%Entrada: -Lista con los TDAs del escenario
%		  -Lista con los TDAs del escenario
%		  -Lista con la posicion X e Y
%Salida: Lista con los TDAs del escenario actualizada
verificarGusanoEnAire(_, [], _, []):- !.
verificarGusanoEnAire(ListTDAs, [Car|Cdr], ListPosXY, Cdr):- esGusano(Car), gusano_getPosX(Car, PosX), gusano_getPosY(Car, PosY), PosY1 is PosY-1, verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX, PosY1], 
															Salida), Salida == 0, posXYCaidaGusano(ListPosXY, ListTDAs, [PosX,PosY1], Car, TDAGusano), TDAGusano == Car, !.

verificarGusanoEnAire(ListTDAs, [Car|Cdr], ListPosXY, [TDAGusano|Cdr]):- esGusano(Car), gusano_getPosX(Car, PosX), gusano_getPosY(Car, PosY), PosY1 is PosY-1, 
																		verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX, PosY1], Salida), Salida == 0, 
																		posXYCaidaGusano(ListPosXY, ListTDAs, [PosX,PosY1], Car, TDAGusano), !.

verificarGusanoEnAire(ListTDAs, [Car|Cdr], ListPosXY, [Car|Cdr1]):- verificarGusanoEnAire(ListTDAs, Cdr, ListPosXY, Cdr1), !.

%Predicado que actualiza el escenario del juego en t+1, es decir, retorna un nuevo escenario con los disparos actualizados, considerado los efectos de esto (cambio del estado del juego)
%Entrada: -Escenario del juego
%		  -Parametro para generar valores pseudoaleatorios
%Salida: Escenario del juego actualizado
updateScene(SceneIn, _, SceneOut):- checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N), obtenerPosicion(SceneIn, 1, M), obtenerTDAs(SceneIn, 1, ListTDAs), obtenerPosXY(ListTDAs, ListPosXY),
									actualizarDisparos(N, M, ListTDAs, ListTDAs, ListPosXY, NewListTDAs), 
									((contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), GusanosEne > 0, 
									SceneOut = [N, M|NewListTDAs]); (contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug == 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), 
									GusanosEne > 0, SceneOut = "DEFEAT"); (contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), 
									GusanosEne == 0, SceneOut = "VICTORY")), !.

%Predicado que retorna la lista con los TDAs del escenario actualizada en t+1
%Entrada: -Lista con los TDAs del escenario
%		  -Lista con los TDAs del escenario
%		  -Lista con las posiciones X e Y de los TDAs
%Salida: Lista con los TDAs del escenario actualizada
actualizarDisparos(_, _, [],ListTDAs, ListPosXY, NewListTDAs):- verificarGusanoEnAire(ListTDAs, ListTDAs, ListPosXY, NewListTDAs), !.
actualizarDisparos(N, M, [Car|Cdr], ListTDAs, ListPosXY, NewListTDAs):- esDisparo(Car), disparo_getPosX(Car, PosX), disparo_getPosY(Car, PosY), disparo_getAngulo(Car, Angle), disparo_getVelo(Car, Speed),t(Tiempo),
																getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)),
																verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1],Salida), Salida == 0,eliminarTDAListTDAs(ListPosXY, ListTDAs,[PosX,PosY], ListTDAs1),
																eliminarTDAListPosXY(ListPosXY, [PosX,PosY], ListPosXY1), disparo(2, Angle, Speed, PosX1, PosY1, TDADisparo),
																PosX1 > 0, PosX1 =< M, PosY1 > 0, PosY1 =< N,
																agregarTDAaListTDAs(ListTDAs1, TDADisparo, ListTDAs2), agregarPosXYaListPosXY(ListPosXY1, [PosX1,PosY1], ListPosXY2), 
																actualizarDisparos(N, M, Cdr, ListTDAs2, ListPosXY2, NewListTDAs), !.
actualizarDisparos(N, M, [Car|Cdr], ListTDAs, ListPosXY, NewListTDAs):- esDisparo(Car), disparo_getPosX(Car, PosX), disparo_getPosY(Car, PosY), disparo_getAngulo(Car, Angle), disparo_getVelo(Car, Speed),t(Tiempo),
																getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)),
																verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1],Salida), Salida == 0,eliminarTDAListTDAs(ListPosXY, ListTDAs,[PosX,PosY], ListTDAs1),
																eliminarTDAListPosXY(ListPosXY, [PosX,PosY], ListPosXY1), (PosX1 =< 0; PosX1 > M; PosY1 =< 0; PosY1 > N),
																actualizarDisparos(N, M, Cdr, ListTDAs1, ListPosXY1, NewListTDAs), !.

actualizarDisparos(N, M, [Car|Cdr], ListTDAs, ListPosXY, NewListTDAs):- esDisparo(Car), disparo_getPosX(Car, PosX), disparo_getPosY(Car, PosY), disparo_getAngulo(Car, Angle), disparo_getVelo(Car, Speed),t(Tiempo),
																getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)),
																verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1],Salida), (Salida == 1; Salida == 2; Salida == 3), 
																eliminarTDAListTDAs(ListPosXY, ListTDAs,[PosX,PosY], ListTDAs1), eliminarTDAListPosXY(ListPosXY, [PosX,PosY], ListPosXY1), 
																eliminarTDAListTDAs(ListPosXY1, ListTDAs1,[PosX1,PosY1], ListTDAs2), eliminarTDAListPosXY(ListPosXY1, [PosX1,PosY1], ListPosXY2), 
																actualizarDisparos(N, M, Cdr, ListTDAs2, ListPosXY2, NewListTDAs), !.

actualizarDisparos(N, M, [_|Cdr], ListTDAs, ListPosXY, NewListTDAs):- actualizarDisparos(N, M, Cdr, ListTDAs, ListPosXY, NewListTDAs), !.

%Predicado que agrega una Posicion X e Y de la lista que contiene las posiciones X e Y de los TDAs
%Entrada: -Lista con las posiciones X e Y de los TDAs
%		  -Lista con la posicion X e Y
%Salida: Lista con las posiciones de los TDAs actualizada
agregarPosXYaListPosXY([], PosXY, [PosXY]):- !.
agregarPosXYaListPosXY([Car|Cdr], PosXY, [Car|Cdr1]):- agregarPosXYaListPosXY(Cdr, PosXY, Cdr1).
%Predicado que convierte un escenario a su representacion a string
%Entrada: -Escenario del juego
%Salida: Representacion del escenario del juego en string
sceneToString(Scene, SceneStr):- checkScene(Scene), obtenerPosicion(Scene, 0, N), obtenerPosicion(Scene, 1, M), crearMatriz(N, M, MatrizDeCeros), obtenerTDAs(Scene, 1, ListTDAs),
								ponerTDAsEnMatriz(N, M, ListTDAs, MatrizDeCeros, MatrizConTDAs), convertirMatrizAStr(MatrizConTDAs, "\n", SceneStr), !.
sceneToString(Scene, SceneStr):- Scene == "VICTORY", SceneStr = "VICTORY".
sceneToString(Scene, SceneStr):- Scene == "DEFEAT", SceneStr = "DEFEAT".

%Predicado que crea una matriz de ceros N x M
%Entrada: -Cantidad de filas de la matriz
%		  -Cantidad de columnas de la matriz
%Salida: Matriz de ceros N x M
crearMatriz(0, _, []).
crearMatriz(N, M, [Fila|Cola]):- N > 0, M > 0, crearMatrizFila(M, Fila), N1 is N-1, crearMatriz(N1, M, Cola), !.
%Predicado que recorre las filas del espacio asignando ceros
%Entrada: -Cantidad de columnas de la matriz
%Salida: Fila de una matriz
crearMatrizFila(M, [0|Cola]):- M > 0, M1 is M-1, crearMatrizFila(M1,Cola), !.
crearMatrizFila(0, []).
%Predicado que inserta en una matriz los TDAs del escenario del juego
%Entrada: -Cantidad de filas de la matriz
%		  -Cantidad de columnas de la matriz
%		  -Lista con los TDAs del escenario
%		  -Matriz que se actualiza en cada recursion
%Salida: Matriz que contiene los TDAs del escenario
ponerTDAsEnMatriz(_, _, [], Matriz, Matriz).
ponerTDAsEnMatriz(N, M, [Car|Cdr], Matriz, MatrizConTDAs):- esGusano(Car), gusano_getPosX(Car, PosX), gusano_getPosY(Car, PosY), PosY1 is N-PosY, 
															insertarTDAEnMatriz(PosX, PosY1, Car, Matriz, Matriz1), ponerTDAsEnMatriz(N, M, Cdr, Matriz1, MatrizConTDAs), !.
ponerTDAsEnMatriz(N, M, [Car|Cdr], Matriz, MatrizConTDAs):- esObstaculo(Car), obstaculo_getPosX(Car, PosX), obstaculo_getPosY(Car, PosY), PosY1 is N-PosY, 
															insertarTDAEnMatriz(PosX, PosY1, Car, Matriz, Matriz1), ponerTDAsEnMatriz(N, M, Cdr, Matriz1, MatrizConTDAs), !.
ponerTDAsEnMatriz(N, M, [Car|Cdr], Matriz, MatrizConTDAs):- esSuelo(Car), suelo_getPosX(Car, PosX), suelo_getPosY(Car, PosY), PosY1 is N-PosY, 
															insertarTDAEnMatriz(PosX, PosY1, Car, Matriz, Matriz1), ponerTDAsEnMatriz(N, M, Cdr, Matriz1, MatrizConTDAs), !.
ponerTDAsEnMatriz(N, M, [Car|Cdr], Matriz, MatrizConTDAs):- esDisparo(Car), disparo_getPosX(Car, PosX), disparo_getPosY(Car, PosY), PosY1 is N-PosY, 
															insertarTDAEnMatriz(PosX, PosY1, Car, Matriz, Matriz1), ponerTDAsEnMatriz(N, M, Cdr, Matriz1, MatrizConTDAs), !.
ponerTDAsEnMatriz(N, M, [_|Cdr], Matriz, MatrizConTDAs):- ponerTDAsEnMatriz(N, M, Cdr, Matriz, MatrizConTDAs), !.
%Predicado que inserta un TDA en una matriz
%Entrada: -Posicion X del TDA a insertar
%		  -Posicion Y del TDA a insertar
%		  -TDA a insertar
%		  -Matriz con los TDAs del escenario
%Salida: Matriz actualizada (con un TDA insertado)
insertarTDAEnMatriz(PosX, PosY, TDA, [Car|Cdr], [Cabeza|Cdr]):- PosY == 0, insertarTDAEnMatrizFila(PosX, TDA, Car, Cabeza), !.
insertarTDAEnMatriz(PosX, PosY, TDA, [Car|Cdr], [Car|Cola]):- PosY1 is PosY-1, insertarTDAEnMatriz(PosX, PosY1, TDA, Cdr, Cola), !.
%Predicado que inserta un TDA en una fila de una matriz
%Entrada: -Posicion X del TDA a insertar
%		  -TDA a insertar
%		  -Fila de la matriz que se le insertara el TDA
%Salida: Fila de una matriz actualizada (con un TDA insertado)
insertarTDAEnMatrizFila(PosX, TDA, [_|Cdr], [Cabeza|Cdr]):- PosX == 1, Cabeza = TDA, !.
insertarTDAEnMatrizFila(PosX, TDA, [Car|Cdr], [Car|Cola]):- PosX1 is PosX-1, insertarTDAEnMatrizFila(PosX1, TDA, Cdr, Cola), !.
%Predicado que convierte una matriz a su representacion a string
%Entrada: -Matriz que contiene los TDAs del escenario
%		  -String de la fila de la representacion el escenario del juego que se actualiza en cada recursion
%Salida: String de la representacion del escenario
convertirMatrizAStr([], Str, Str).
convertirMatrizAStr([Fila|Cdr], Str, SceneStr):- convertirMatrizAStrFila(Fila, Str, Str1), convertirMatrizAStr(Cdr, Str1, SceneStr), !.
%Predicado que convierte un fila de una matriz a su representacion a string
%Entrada: -Fila de la matriz que contiene al escenario
%		  -String de la representacion el escenario del juego que se actualiza en cada recursion
%Salida: String de la fila de la representacion del escenario
convertirMatrizAStrFila([], Str, NewStr):- string_concat(Str, "\n", NewStr), !.
convertirMatrizAStrFila([Car|Cdr], Str, NewStr):- Car == 0, string_concat(Str, "  ", Str1), convertirMatrizAStrFila(Cdr, Str1, NewStr), !.
convertirMatrizAStrFila([Car|Cdr], Str, NewStr):- esGusano(Car), gusano_getId(Car, Id), Id == 0, string_concat(Str, "E ", Str1), convertirMatrizAStrFila(Cdr, Str1, NewStr), !.
convertirMatrizAStrFila([Car|Cdr], Str, NewStr):- esGusano(Car), gusano_getId(Car, Id), Id == 1, string_concat(Str, "A ", Str1), convertirMatrizAStrFila(Cdr, Str1, NewStr), !.
convertirMatrizAStrFila([Car|Cdr], Str, NewStr):- esDisparo(Car), string_concat(Str, "o ", Str1), convertirMatrizAStrFila(Cdr, Str1, NewStr), !.
convertirMatrizAStrFila([Car|Cdr], Str, NewStr):- esObstaculo(Car), string_concat(Str, "# ", Str1), convertirMatrizAStrFila(Cdr, Str1, NewStr), !.
convertirMatrizAStrFila([Car|Cdr], Str, NewStr):- esSuelo(Car), string_concat(Str, "_ ", Str1), convertirMatrizAStrFila(Cdr, Str1, NewStr), !.
%Predicado que permite mover el personaje de juego, disparar, desplazar el proyectil disparado actualizando el escenario y repetir estos mismos pasos por parte de un personaje enemigo
%Entrada: -Escenario del juego
%		  -Personaje del equipo a mover
%		  -Direccion del movimiento
%		  -Tipo del disparo
%		  -Angulo del disparo
%		  -Parametro para generar valores pseudoaleatorios
%Salida: Nuevo escenario del juego
play(SceneIn, Member, MoveDir, ShootType, Angle, Seed, SceneOut):- moveMember(SceneIn, Member, MoveDir, _, SceneOut1), shoot(SceneOut1, Member, ShootType, Angle, _, SceneOut2), ((SceneOut2 == "DEFEAT", 
															SceneOut = "DEFEAT"); (SceneOut2 == "VICTORY", SceneOut = "VICTORY"); (updateScene(SceneOut2, _, SceneOut3), 
															((SceneOut3 == "DEFEAT", SceneOut = "DEFEAT"); (SceneOut3 == "VICTORY", SceneOut = "VICTORY"); 
                                                            (obtenerPosicion(SceneOut3, 1, M), obtenerTDAs(SceneOut3, 1, ListTDAs), listGusanosEnemigos(ListTDAs, ListGusEne), length(ListGusEne, Len),
															numRandom(Seed, Len, NumGusano), NumGusano1 is NumGusano+1, obtenerGusanoEne(ListGusEne, NumGusano1, TDAGusEne), 
															gusano_getIdGusano(TDAGusEne, MemberEne), numRandom(Seed, M, MovDirEne), MovDirEne1 is floor(MovDirEne-M/2), 
															moveMemberEnemigo(SceneOut3, MemberEne, MovDirEne1, _, SceneOut4), numRandom(Seed, 360, AngleEne), 
															shootEnemigo(SceneOut4, MemberEne, disparoMRU, AngleEne, _, SceneOut5), ((SceneOut5 == "DEFEAT", SceneOut = "DEFEAT"); 
															(SceneOut5 == "VICTORY", SceneOut = "VICTORY"); (updateScene(SceneOut5, _, SceneOut6), 
															((SceneOut6 == "DEFEAT", SceneOut = "DEFEAT"); (SceneOut6 == "VICTORY", SceneOut = "VICTORY"); (SceneOut = SceneOut6)))))))), !.
%Predicado que crea una lista con los TDAs de los gusanos enemigos
%Entrada: -Lista con los TDAs del escenario
%Salida: Lista con los TDAs de los gusanos enemigos
listGusanosEnemigos([], []).
listGusanosEnemigos([Car|Cdr], ListGusEne):- esGusano(Car), gusano_getId(Car, 0), listGusanosEnemigos(Cdr, ListGusEne1), ListGusEne = [Car|ListGusEne1], !.
listGusanosEnemigos([_|Cdr], ListGusEne):- listGusanosEnemigos(Cdr, ListGusEne), !.
%Predicado que retorna un TDA gusano enemigo dado una posicion
%Entrada: -Lista con los TDAs de los gusanos enemigos
%		  -Posicion de la lista a obtener
%Salida: TDA de un gusano enemigo
obtenerGusanoEne([Car|_], NumGusano, TDAGusEne):- NumGusano == 0, TDAGusEne = Car, !.
obtenerGusanoEne([_|Cdr], NumGusano, TDAGusEne):- NumGusano1 is NumGusano-1, obtenerGusanoEne(Cdr, NumGusano1, TDAGusEne), !.
%Predicado que permite consultar si es posible mover un personaje enemigo
%Entrada: -Escenario del juego
%		  -Personaje del equipo a mover
%		  -Direccion del movimiento
%		  -Parametro para generar valores pseudoaleatorios
%Salida: Nuevo escenario del juego
moveMemberEnemigo(SceneIn, _, MoveDir, _, SceneOut):- checkScene(SceneIn), MoveDir == 0, SceneOut = SceneIn.
moveMemberEnemigo(SceneIn, Member, MoveDir, _, SceneOut):- checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N), obtenerPosicion(SceneIn, 1, M), obtenerTDAs(SceneIn, 1, ListTDAs), 
														buscarGusano(ListTDAs, 0, Member, TDAGusano), MoveDir > 0, obtenerPosXY(ListTDAs, ListPosXY), gusano_getId(TDAGusano, Id),
														gusano_getIdGusano(TDAGusano, Member), moverJugadorDer(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir, TDAGusano, NewListTDAs),
														((contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), GusanosEne > 0, 
														SceneOut = [N, M|NewListTDAs]); (contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug == 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), 
														GusanosEne > 0, SceneOut = "DEFEAT"); (contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), 
														GusanosEne == 0, SceneOut = "VICTORY")), !.

moveMemberEnemigo(SceneIn, Member, MoveDir, _, SceneOut):- checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N), obtenerPosicion(SceneIn, 1, M), obtenerTDAs(SceneIn, 1, ListTDAs), 
														buscarGusano(ListTDAs, 0, Member, TDAGusano), MoveDir < 0, obtenerPosXY(ListTDAs, ListPosXY), gusano_getId(TDAGusano, Id),
														gusano_getIdGusano(TDAGusano, Member), moverJugadorIzq(N, M, Id, Member, ListTDAs, ListPosXY, MoveDir, TDAGusano, NewListTDAs),
														((contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), GusanosEne > 0, 
														SceneOut = [N, M|NewListTDAs]); (contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug == 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), 
														GusanosEne > 0, SceneOut = "DEFEAT"); (contarGusanos(NewListTDAs, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(NewListTDAs, 0, 0, GusanosEne), 
														GusanosEne == 0, SceneOut = "VICTORY")), !.
%Predicado que realizar un disparo ejecutado por Member enemigo
%Entrada: -Escenario del juego
%		  -Personaje del equipo a mover
%		  -Tipo del disparo
%		  -Angulo del disparo
%		  -Parametro para generar valores pseudoaleatorios
%Salida: Nuevo escenario del juego
shootEnemigo(SceneIn, Member, ShootType, Angle, _, SceneOut):- ShootType == disparoMRU, checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N),obtenerPosicion(SceneIn, 1, M),obtenerTDAs(SceneIn, 1, ListTDAs),
														obtenerPosXY(ListTDAs, ListPosXY), buscarGusano(ListTDAs, 0, Member, TDAGusano), gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY), 
														velocidad(Speed), t(Tiempo), getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), 
														PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)), verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida), Salida == 0, 
														PosX1 > 0, PosX1 =< M, PosY1 > 0, PosY1 =< N, disparo(2, Angle, Speed, PosX1, PosY1, TDADisparo), 
														agregarTDAaListTDAs(ListTDAs, TDADisparo, ListTDAs1), SceneOut = [N, M|ListTDAs1], !.
shootEnemigo(SceneIn, Member, ShootType, Angle, _, SceneOut):- ShootType == disparoMRU, checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N),obtenerPosicion(SceneIn, 1, M),obtenerTDAs(SceneIn, 1, ListTDAs),
														obtenerPosXY(ListTDAs, ListPosXY), buscarGusano(ListTDAs, 0, Member, TDAGusano), gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY), 
														velocidad(Speed), t(Tiempo), getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), 
														PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)), verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida), Salida == 0, 
														(PosX1 =< 0; PosX1 > M; PosY1 =< 0; PosY1 > N), SceneOut = [N, M|ListTDAs], !.
shootEnemigo(SceneIn, Member, ShootType, Angle, _, SceneOut):- ShootType == disparoMRU, checkScene(SceneIn), obtenerPosicion(SceneIn, 0, N),obtenerPosicion(SceneIn, 1, M),obtenerTDAs(SceneIn, 1, ListTDAs),
														obtenerPosXY(ListTDAs, ListPosXY), buscarGusano(ListTDAs, 0, Member, TDAGusano), gusano_getPosX(TDAGusano, PosX), gusano_getPosY(TDAGusano, PosY), 
														velocidad(Speed), t(Tiempo), getRad(Angle, NewAngle), PosX1 is ceil(PosX + (Speed * (cos(NewAngle)) * Tiempo)), 
														PosY1 is ceil(PosY + (Speed * (sin(NewAngle)) * Tiempo)), verificarPosOcupadaXY(ListPosXY, ListTDAs, [PosX1,PosY1], Salida),
														(Salida == 1; Salida == 2; Salida == 3), eliminarTDAListTDAs(ListPosXY, ListTDAs, [PosX1,PosY1], ListTDAs1), 
														eliminarTDAListPosXY(ListPosXY, [PosX1,PosY1], ListPosXY1), verificarGusanoEnAire(ListTDAs1, ListTDAs1, ListPosXY1, ListTDAs2), 
														((contarGusanos(ListTDAs2, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(ListTDAs2, 0, 0, GusanosEne), GusanosEne > 0, 
														SceneOut = [N, M|ListTDAs2]); (contarGusanos(ListTDAs2, 1, 0, GusanosJug), GusanosJug == 0, contarGusanos(ListTDAs2, 0, 0, GusanosEne), 
														GusanosEne > 0, SceneOut = "DEFEAT"); (contarGusanos(ListTDAs2, 1, 0, GusanosJug), GusanosJug > 0, contarGusanos(ListTDAs2, 0, 0, GusanosEne), 
														GusanosEne == 0, SceneOut = "VICTORY")), !.

%Ejemplos:
%REQUIRIMIENTOS OBLIGATORIOS:
%   createScene:	1.- createScene(5, 10, 4, 1, _, Scene).
%				 	2.- createScene(10, 12, 6, 2, _, Scene).
%				 	3.- createScene(20, 20, 8, 3, _, Scene).

% 	checkScene:  	1.- createScene(5, 10, 4, 1, _, Scene), checkScene(Scene).
%				 	2.- createScene(10, 12, 6, 2, _, Scene), checkScene(Scene).
%				 	3.- createScene(20, 20, 8, 3, _, Scene), checkScene(Scene).

%	moveMember:  	1.- createScene(5, 10, 4, 1, _, Scene), moveMember(Scene, 1, 3, _, SceneOut).
%				 	2.- createScene(10, 12, 6, 2, _, Scene), moveMember(Scene, 2, -3, _, SceneOut).
%				 	3.- createScene(20, 20, 8, 3, _, Scene), moveMember(Scene, 3, 5, _, SceneOut).

%	shoot: 		 	1.- createScene(5, 10, 4, 1, _, Scene), shoot(Scene, 1, disparoMRU, 0, _, SceneOut).
%				 	2.- createScene(10, 12, 6, 2, _, Scene), shoot(Scene, 2, disparoMRU, 270, _, SceneOut).
%				 	3.- createScene(20, 20, 8, 3, _, Scene), shoot(Scene, 3, disparoMRU, 180, _, SceneOut).

%	updateScene: 	1.- createScene(5, 10, 4, 1, _, Scene), shoot(Scene, 1, disparoMRU, 0, _, SceneOut), updateScene(SceneOut, _, SceneOut1).
%				 	2.- createScene(10, 12, 6, 2, _, Scene), updateScene(Scene, _, SceneOut).
%				 	3.- createScene(20, 20, 8, 3, _, Scene), shoot(Scene, 3, disparoMRU, 45, _, SceneOut), updateScene(SceneOut, _, SceneOut1).

%	sceneToString: 	1.- createScene(5, 10, 4, 1, _, Scene), moveMember(Scene, 1, 3, _, SceneOut), sceneToString(SceneOut, SceneStr).
%					2.- createScene(10, 12, 6, 2, _, Scene), shoot(Scene, 2, disparoMRU, 270, _, SceneOut), sceneToString(SceneOut, SceneStr).
%					3.- createScene(20, 20, 8, 3, _, Scene), shoot(Scene, 3, disparoMRU, 45, _, SceneOut), updateScene(SceneOut, _, SceneOut1), sceneToString(SceneOut1, SceneStr).

%REQUIRIMIENTOS EXTRAS: 
%	play: 			1.- createScene(5, 10, 4, 1, _, Scene), play(Scene, 1, 3, disparoMRU, 0, 3213123, SceneOut).
%					2.- createScene(10, 12, 6, 2, _, Scene), play(Scene, 2, -4, disparoMRU, 270, 5464865, SceneOut).
%					3.- createScene(20, 20, 8, 3, _, Scene), play(Scene, 2, 5, disparoMRU, 30, 984561, SceneOut).
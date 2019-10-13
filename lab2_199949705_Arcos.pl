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
											myRandom(Seed, Seed1), write(NumRandom1), getListaRandomR(Seed1, Cuantos, Maximo, [NumRandom1], Lista).

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

%Predicado que permite consultar si es posible crear un escenario válido de tamaño NxM
%Entrada: -Tamaño eje X
%		  -Tamaño eje Y
%		  -Cantidad de enemigos
%		  -Dificultad del escenario
%		  -Semilla para generar valores pseudoaleatorios
%Salida: Escenario del juego
%ESCENARIOS DE 5 x 10
%2 enemigos y 3 aliados
createScene(5, 10, 2, _, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 1, 3], [3, 1, 4], 
									[1, 1, 1, 5], [1, 2, 2, 3], [1, 3, 3, 2], [0, 1, 10, 2], [0, 2, 9, 2]], !.
%4 enemigos y 1 aliados
createScene(5, 10, 4, _, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 3, 2], [3, 4, 2],
									[3, 5, 2], [3, 1, 3], [3, 2, 3], [3, 5, 3], [3, 1, 4], [1, 1, 1, 5], [1, 2, 2, 4], [0, 1, 10, 2], [0, 2, 9, 2], [0, 3, 8, 2], [0, 4, 7, 2]], !.
%5 enemigos y 1 aliados
createScene(5, 10, 5, _, _, Scene):- Scene = [5, 10, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [3, 1, 2], [3, 2, 2], [3, 3, 2], 
									[3, 4, 2], [3, 7, 2], [3, 8, 2], [3, 9, 2], [3, 10, 2], [3, 1, 3], [3, 2, 3], [3, 9, 3], [3, 10, 3], [3, 1, 4], [3, 10, 4], [1, 1, 1, 5], 
									[0, 1, 10, 5], [0, 2, 9, 4], [0, 3, 8, 3], [0, 4, 7, 3], [0, 5, 6, 2]], !.

%ESCENARIOS DE 10 x 12
createScene(10, 12, 4, _, _, Scene):- Scene = [10, 12, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [1, 2], [2, 2], [3, 2], 
									[4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], [11, 2], [12, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3], 
									[9, 3], [10, 3], [11, 3], [12, 3], [3, 1, 4], [3, 3, 4], [3, 4, 4], [3, 6, 4], [3, 6, 5], [3, 6, 6], [3, 6, 7], [3, 6, 8], [3, 9, 4], 
									[3, 10, 4], [3, 10, 5], [3, 10, 6], [3, 10, 7], [3, 10, 8], [3, 11, 4], [3, 11, 5], [3, 12, 4], [3, 12, 5], [3, 12, 6], [1, 1, 1, 5], 
									[1, 2, 2, 4], [0, 1, 12, 7], [0, 2, 11, 6], [0, 3, 10, 9], [0, 4, 9, 5]], !. 

createScene(10, 12, 6, _, _, Scene):- Scene = [10, 12, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [1, 2], [2, 2], [3, 2],
									[4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], [11, 2], [12, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3], 
									[9, 3], [10, 3], [11, 3], [12, 3], [3, 11, 4], [3, 11, 5], [3, 11, 6], [3, 4, 4], [3, 9, 4], [3, 2, 4], [3, 1, 4], [3, 1, 5], [3, 1, 6], 
									[3, 3, 4], [3, 12, 4], [3, 12, 5], [3, 12, 6], [3, 12, 7], [3, 12, 8], [3, 10, 4], [3, 10, 5], [3, 2, 5], [1, 1, 1, 7], [0, 1, 12, 9], 
									[0, 2, 11, 7], [0, 3, 10, 6], [0, 4, 9, 5], [0, 5, 8, 4], [0, 6, 7, 4]], !.

%ESCENARIO DE 20 x 20
createScene(20, 20, 8, _, _, Scene):- Scene = [20, 20, [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1], [9, 1], [10, 1], [11, 1], [12, 1], [13, 1], [14, 1], 
									[15, 1], [16, 1], [17, 1], [18, 1], [19, 1], [20, 1], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2], 
									[11, 2], [12, 2], [13, 2], [14, 2], [15, 2], [16, 2], [17, 2], [18, 2], [19, 2], [20, 2], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], 
									[7, 3], [8, 3], [9, 3], [10, 3], [11, 3], [12, 3], [13, 3], [14, 3], [15, 3], [16, 3], [17, 3], [18, 3], [19, 3], [20, 3], [1, 4], [2, 4], 
									[3, 4], [4, 4], [5, 4], [6, 4],[7, 4], [8, 4], [9, 4], [10, 4], [11, 4], [12, 4], [13, 4], [14, 4], [15, 4], [16, 4], [17, 4], [18, 4], 
									[19, 4], [20, 4], [1, 5], [2, 5],[3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 5], [10, 5], [11, 5], [12, 5], [13, 5], [14, 5], [15, 5], 
									[16, 5], [17, 5], [18, 5], [19, 5], [20, 5], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6], [9, 6], [10, 6], [11, 6], [12, 6],
									[13, 6], [14, 6], [15, 6], [16, 6], [17, 6], [18, 6], [19, 6], [20, 6], [3, 1, 9], [3, 2, 9], [3, 2, 10], [3, 3, 9], [3, 4, 9], [3, 6, 9], 
									[3, 7, 9], [3, 7, 10], [3, 7, 11], [3, 8, 9], [3, 8, 10], [3, 10, 9], [3, 10, 10], [3, 11, 9], [3, 15, 9], [3, 16, 9], [3, 16, 10], [3, 17, 9],
									[3, 17, 10], [3, 17, 11], [3, 17, 12], [3, 18, 9], [3, 18, 10], [3, 18, 11], [3, 18, 12], [3, 18, 13], [3, 18, 14], [3, 19, 9], [3, 19, 10], 
									[3, 19, 11], [3, 19, 12], [3, 19, 13], [3, 19, 14], [3, 19, 15], [3, 19, 16], [3, 20, 9], [3, 20, 10], [3, 20, 11], [3, 20, 12], [3, 20, 13], 
									[3, 20, 14], [3, 20, 15], [3, 20, 16], [3, 20, 17], [3, 20, 18], [1, 1, 1, 10], [0, 1, 20, 19], [0, 2, 19, 17], [0, 3, 18, 15], [0, 4, 17, 13],
									[0, 5, 16, 11], [0, 6, 15, 10], [0, 7, 14, 9], [0, 8, 13, 9]], !.

checkScene(Scene):- is_list(Scene), obtenerPosicion(Scene, 0, N), N > 0, obtenerPosicion(Scene, 1, M), M > 0, obtenerTDAs(Scene, 1, ListTDAs), verificarTDAs(ListTDAs), 
					obtenerPosXY(ListTDAs, ListPosXY), verificarPosDistintas(ListPosXY), !.
obtenerTDAs([_|Cdr], Cantidad, ListTDAs):- Cantidad == 2, ListTDAs = Cdr.
obtenerTDAs([_|Cdr], Cantidad, ListTDAs):- Cantidad1 is Cantidad+1, obtenerTDAs(Cdr, Cantidad1, ListTDAs).
verificarTDAs([]):- !.
verificarTDAs([Car|Cdr]):- is_list(Car), (esGusano(Car); esDisparo(Car); esSuelo(Car); esObstaculo(Car)), verificarTDAs(Cdr), !.
obtenerPosXY([],[]).
obtenerPosXY([Car|Cdr], [Cabeza|Cola]):- ((esGusano(Car), gusano_getPosX(Car, PosX), gusano_getPosY(Car, PosY));(esDisparo(Car), disparo_getPosX(Car, PosX), disparo_getPosY(Car, PosY));
										(esObstaculo(Car), obstaculo_getPosX(Car, PosX), obstaculo_getPosY(Car,PosY));(esSuelo(Car), suelo_getPosX(Car, PosX), suelo_getPosY(Car,PosY))),
										obtenerPosXY(Cdr, Cola), Cabeza = [PosX,PosY].
verificarPosDistintas([]).										
verificarPosDistintas([Car|Cdr]):- compararListas(Car, Cdr), verificarPosDistintas(Cdr), !.
compararListas(_, []).
compararListas(TDA, [Car|Cdr]):- not(posXYIguales(TDA, Car)), compararListas(TDA, Cdr), !.
posXYIguales([PosX,PosY], [PosX, PosY]).
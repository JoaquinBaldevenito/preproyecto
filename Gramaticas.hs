--Main
programa -> tipo main() bloque
bloque -> { lista_sentencias }
lista_sentencias -> sentencia lista_sentencias | ε
--Sentencias
sentencia -> declaracion ;
sentencia -> asignacion ;
sentencia -> return E ;
sentencia -> return ;

--Declaracion de Variables
declaracion -> tipo id 
declaracion -> tipo asignacion 

--Asignacion de Variables
asignacion -> id = E

--Tipos de Datos
tipo -> int | bool | void

--Operaciones 
E → E + E
    | E * E
    | ( E )
    | nro
    | id
    | E || E
    | E && E
    | !E
    | false
    | true

--2 Expresiones regulares

--Palabras Reservadas
palabras_reservadas -> main | int | bool | void | return | if | else | while

--Variables
id -> [a-z][a-zA-Z0-9]*

--Constantes
constante -> false | true
nro -> 0 | [1-9][0-9]*

--Operadores
operador -> + | * | = | || | && | ! | == | != 

--Delimitadores
delimitadores -> ; | { | } | ( | ) 

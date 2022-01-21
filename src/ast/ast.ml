(* Abstract Syntax Tree *)
open Lexing 

(* position in the source file, we use ocamllex's default type *)
type position = Lexing.position
let position_unknown = Lexing.dummy_pos


(* extents are pairs of positions *)
type extent = position * position (* start/end *)
let extent_unknown = (position_unknown, position_unknown)


(* Many parts of the syntax are tagged with an extent indicating which 
   part of the parser-file corresponds to the sub-tree.
   This is very useful for interesting error reporting!
 *)
type 'a ext = 'a * extent


type bool_unary_op =
  | NEG  

type int_unary_op = 
  | UNARY_PLUS     (* +e *)
  | UNARY_MINUS    (* -e *)

type int_binary_op =
  | PLUS          (* e + e *)
  | MINUS         (* e - e *)
  | MULTIPLY      (* e * e *)
  | DIVIDE        (* e / e *)

type bool_binary_op =
  | AND           (* e && e *)
  | OR            (* e || e *)
  | XOR           (* e xor e *)

type str_binary_op =
  | STRCAT        

type list_binary_op = 
  | LISTCONS
  | RANGE

type int_expr = 
  (* unary operation *)
  | Int_unary of int_unary_op * (int_expr ext)

  (* binary operation *)
  | Int_binary of int_binary_op * (int_expr ext) * (int_expr ext)

  (* constants (integers are still in their string representation) *)
  | Int_const of string ext

type compare_op =
  | EQUAL         (* e = e *)
  | EQV           (* e == e *)
  | NEQV          (* e <> e *)
  | LT            (* e < e *)
  | LE            (* e <= e *)
  | GT            (* e > e *)
  | GE            (* e >= e *)

type bool_expr = 
  (* unary operation *)
  | Bool_unary of bool_unary_op * (bool_expr ext)

  (* binary operation *)
  | Bool_binary of bool_binary_op * (bool_expr ext) * (bool_expr ext)
  | Compare of compare_op * (int_expr ext) * (int_expr ext)

  (* constants *)
  | Bool_const of bool
    


type var = string


(* types: only integers (mathematical integers, in Z) *)
type typ = INT      


type stat =

  (* block of statements { declarations; statements;  } *)
  | AST_block of (((int * var) ext) list) * ((stat ext) list)

  (* assignment of integer expression: var = expr *)
  | AST_assign of (var ext) * (int_expr ext)

  (* if-then-else, with boolean condition;
     the else branch is optional 
   *)
  | AST_if of (bool_expr ext) (* condition *) * 
              (stat ext) (* then branch *) * 
              (stat ext option) (* optional else *)

  (* while loop, with boolean condition *)
  | AST_while of (bool_expr ext) (* condition *) * 
                 (stat ext) (* body *)

  (* program exit *)
  | AST_HALT

  (* assertion: exit if the boolean expression does not hold *)
  | AST_assert of bool_expr ext

  (* prints the value of some or all variables *)
  | AST_print of (var ext) list
  | AST_PRINT_ALL


type term =
  | Int of int
  | Str of string
  | Var of string
  | Unit
  | Null
  | C of string * term list (* for value contructors*)
  | App of term * term
  | Abs of string * term
  | Case of term * (term * term) list
  | Map of term * (term * term) list
  | Fold of term * (term * term) list
  | Unfold of term * (term * term) list

type datatype =
  | Unit_Type
  | Init_Type of string * datatype option * (string * datatype list) list

(* type name, optional type variable, value constructors *)
(* | Final_Type of  *)

type prog = stat ext list
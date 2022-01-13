(* Abstract Syntax Tree *)

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

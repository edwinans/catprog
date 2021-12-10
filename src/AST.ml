(* Abstract Syntax Tree *)

type term =
  | Int of int
  | Str of string
  | Var of string
  | Null
  | App of term * term
  | Fold of (string * term) list
  | Unfold of (string * term) list
  | Fun of string * term

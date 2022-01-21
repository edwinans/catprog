

(* 
   Definition of the abstract syntax trees output by the parser.
*)


(* open Lexing *)


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

(* variable identifiers, just strings *)
(* local variables and scoping would require using UNIQUE IDENTIFIERS
   to handle the case where several variables have the same name
 *)
type var = string


(* types: only integers (mathematical integers, in Z) *)
type typ = AST_INT      


(* unary expression operators *)

type int_unary_op = 
  | AST_UNARY_PLUS     (* +e *)
  | AST_UNARY_MINUS    (* -e *)

type bool_unary_op =
  | AST_NOT            (* !e logical negation *)


(* binary expression operators *)

type int_binary_op =
  | AST_PLUS          (* e + e *)
  | AST_MINUS         (* e - e *)
  | AST_MULTIPLY      (* e * e *)
  | AST_DIVIDE        (* e / e *)

type compare_op =
  | AST_EQUAL         (* e == e *)
  | AST_NOT_EQUAL     (* e != e *)
  | AST_LESS          (* e < e *)
  | AST_LESS_EQUAL    (* e <= e *)
  | AST_GREATER       (* e > e *)
  | AST_GREATER_EQUAL (* e >= e *)

type bool_binary_op =
  | AST_AND           (* e && e *)
  | AST_OR            (* e || e *)


(* expressions *)

type int_expr = 
  (* unary operation *)
  | AST_int_unary of int_unary_op * (int_expr ext)

  (* binary operation *)
  | AST_int_binary of int_binary_op * (int_expr ext) * (int_expr ext)

  (* variable use *)
  | AST_identifier of var ext

  (* constants (integers are still in their string representation) *)
  | AST_int_const of string ext



type bool_expr =
  (* unary operation *)
  | AST_bool_unary of bool_unary_op * (bool_expr ext)

  (* binary operation *)
  | AST_bool_binary of bool_binary_op * (bool_expr ext) * (bool_expr ext)
  | AST_compare of compare_op * (int_expr ext) * (int_expr ext)

  (* constants *)
  | AST_bool_const of bool

type expr =
  | Str of string
  | Var of string
  | Unit
  | Null
  | C of string * expr list (* for value contructors*)
  | App of expr * expr
  | Abs of string * expr
  | Case of expr * (expr * expr) list
  | Map of expr * (expr * expr) list
  | Fold of expr * (expr * expr) list
  | Unfold of expr * (expr * expr) list

type def = data_def
(* L(A) -> S*)
type data_name = string * string option * string
type data_def = Init_Type of data_name * (string * string list * string) list

        
(* a program is a list of statements *)
type prog = stat ext list

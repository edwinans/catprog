open Printf 
open Ast

module Env = Map.Make(String) 

let env = Env.empty 

let str_of_seq (l : 'a list) sep seed = 
    List.fold_left (fun x y -> x ^ sep ^ y) seed l

let rec str_of_term = function
    | Int n -> string_of_int n 
    | Str s -> "\"" ^ s ^ "\"" 
    | Var s -> s 
    | C(c, terms) -> let terms_s = List.map str_of_term terms in 
        (str_of_seq terms_s "," (c ^ "(")) ^ ")"
    | App(f, x) -> (str_of_term f) ^ " " ^ (str_of_term x)
    | Abs(x, t) -> "fun " ^ x ^ " -> " ^ str_of_term t 
    | Case(arg, l) -> "match " ^ str_of_term arg ^ " with \n" ^
        let ls = List.map (fun (x,y) -> "|" ^ str_of_term x ^ " -> " ^ str_of_term y) l in 
        str_of_seq ls "\n" ""
    | _ -> ""

let compile t = match t with 
    | Int _ -> printf "%s\n" (str_of_term t)
    | Str _ -> printf "%s\n" (str_of_term t)
    | Var _ -> printf "%s\n" (str_of_term t)
    | C(_, _) -> printf "(%s)\n" (str_of_term t)
    | App(_, _) -> printf "(%s)\n" (str_of_term t)
    | Abs(_, _) -> printf "(%s)\n" (str_of_term t)
    | Case(_, _) -> printf "(%s)\n" (str_of_term t)
    | _ -> ()
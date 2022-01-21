
(*
  Lexer for a Charity-like language.
*)
    
{
open Lexing
open Abstract_syntax_tree
open Parser

(* keyword table *)
let kwd_table = Hashtbl.create 10
let _ = 
  List.iter (fun (a,b) -> Hashtbl.add kwd_table a b)
    [
     (* data *)
     "def",    TOK_DEF;
     "data",   TOK_DATA;
     (* constants *)

     (* expression operators *)
     "and",   TOK_AND;
     "or",    TOK_OR;
     "xor",   TOK_XOR;
     "not",   TOK_NOT;

     (* control flow *)

     (* special statements *)
   ]
}

(* special character classes *)
let space = [' ' '\t' '\r']+
let newline = "\n" | "\r" | "\r\n"

(* utilities *)
let digit = ['0'-'9']
let digit_ = ['0'-'9' '_']

(* integers *)
let int_dec = digit digit_*

(* tokens *)
rule token = parse

(* identifier (TOK_id) or reserved keyword *)
| ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']* as id
{ try Hashtbl.find kwd_table id with Not_found -> TOK_id id }

(* symbols *)
| "("    { TOK_LPAREN }
| ")"    { TOK_RPAREN }
| "["    { TOK_LBRACKET }
| "]"    { TOK_RBRACKET }
| "{"    { TOK_LCURLY }
| "}"    { TOK_RCURLY }
| "{|"   { TOK_LFOLD }
| "|}"   { TOK_RFOLD }
| "(|"   { TOK_LUNFOLD }
| "|)"   { TOK_RUNFOLD }
| "{:"   { TOK_LRECUR }
| ":}"   { TOK_RRECUR }
| "*"    { TOK_MUL }
| "*."   { TOK_FMUL }
| "+"    { TOK_ADD }
| "+."   { TOK_FADD }
| "-"    { TOK_SUB }
| "-."   { TOK_FSUB }
| "/"    { TOK_DIVIDE }
| "/."   { TOK_FDIVIDE }
| "!"    { TOK_EXCLAIM }
| "<"    { TOK_LT }
| ">"    { TOK_GT }
| "<="   { TOK_LE }
| ">="   { TOK_GE }
| "=="   { TOK_EQV }
| "<>"   { TOK_NEQV}
| "&&"   { TOK_AND_AND }
| "||"   { TOK_BAR_BAR }
| ":"    { TOK_COLON }
| ";"    { TOK_SEMICOLON }
| ","    { TOK_COMMA }
| "="    { TOK_EQUAL }
| "|"    { TOK_BAR }
| ":\\"  { TOK_HIGHERORDERCOLON}
| "."    { TOK_STOP }
| ".."   { TOK_RANGE }
| "->"   { TOK_SARROW }
| "=>"   { TOK_DARROW }
| "^"    { TOK_STRCAT }
| "~"    { TOK_NEG }
| "::"   { TOK_LISTCONS}
| "_"    { TOK_UNDERSCORE }
| "#"    { TOK_SHARP }
| "@"    { TOK_AT}

(* literals *)
| int_dec  as c { TOK_int c }

(* spaces, comments *)
| "(*" { comment lexbuf; token lexbuf }
| "//" [^ '\n' '\r']* { token lexbuf }
| newline { new_line lexbuf; token lexbuf }
| space { token lexbuf }

(* end of files *)
| eof { TOK_EOF }


(* nested comments (handled recursively)  *)
and comment = parse
| "*)" { () }
| [^ '\n' '\r'] { comment lexbuf }
| newline { new_line lexbuf; comment lexbuf }

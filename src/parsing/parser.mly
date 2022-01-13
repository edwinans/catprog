(*
  Cours "Typage et Analyse Statique" - Master STL
  Sorbonne Université
  Antoine Miné 2015-2018
*)


(*
  Parser for a very simple C-like "curly bracket" language.
  
  There should be exactly one shift/reduce conflict, due to nested 
  if-then-else constructs. The resolution picked by menhir should be correct.
 *)

%{
open AST
%}


/* tokens */
/**********/

%token TOK_LPAREN 
%token TOK_RPAREN 
%token TOK_LBRACKET 
%token TOK_RBRACKET 
%token TOK_LCURLY 
%token TOK_RCURLY 
%token TOK_LFOLD 
%token TOK_RFOLD 
%token TOK_LUNFOLD 
%token TOK_RUNFOLD 
%token TOK_LRECUR 
%token TOK_RRECUR 
%token TOK_MUL 
%token TOK_FMUL 
%token TOK_ADD 
%token TOK_FADD 
%token TOK_SUB 
%token TOK_FSUB 
%token TOK_DIVIDE 
%token TOK_FDIVIDE 
%token TOK_EXCLAIM 
%token TOK_LT 
%token TOK_GT 
%token TOK_LE 
%token TOK_GE 
%token TOK_EQV 
%token TOK_NEQV
%token TOK_AND_AND 
%token TOK_BAR_BAR 
%token TOK_COLON 
%token TOK_SEMICOLON 
%token TOK_COMMA 
%token TOK_EQUAL 
%token TOK_BAR 
%token TOK_HIGHERORDERCOLON
%token TOK_STOP 
%token TOK_RANGE 
%token TOK_SARROW 
%token TOK_DARROW 
%token TOK_STRCAT 
%token TOK_NEG 
%token TOK_LISTCONS
%token TOK_UNDERSCORE 
%token TOK_SHARP 
%token TOK_AT

%token <string> TOK_id
%token <string> TOK_int

%token TOK_EOF

/* priorities of binary operators (lowest to highest) */
%left TOK_ADD TOK_FADD TOK_SUB TOK_FSUB
%left TOK_MUL TOK_FMUL TOK_DIVIDE TOK_FDIVIDE


/* entry-point */
/****************/

%start<Abstract_syntax_tree.prog> file


%%


/* toplevel */
/************/

file: t=list(ext(stat)) TOK_EOF { t }


/* expressions */
/***************/


// integer unary operators
%inline int_unary_op:
| TOK_PLUS           { AST_UNARY_PLUS }
| TOK_MINUS          { AST_UNARY_MINUS }

// boolean unary operator
%inline bool_unary_op:
| TOK_EXCLAIM        { AST_NOT }

// integer binary operators    
%inline int_binary_op:
| TOK_STAR           { AST_MULTIPLY }
| TOK_DIVIDE         { AST_DIVIDE }
| TOK_PLUS           { AST_PLUS }
| TOK_MINUS          { AST_MINUS }

// comparison operators    
%inline compare_op:
| TOK_LESS           { AST_LESS }
| TOK_GREATER        { AST_GREATER }
| TOK_LESS_EQUAL     { AST_LESS_EQUAL }
| TOK_GREATER_EQUAL  { AST_GREATER_EQUAL }
| TOK_EQUAL_EQUAL    { AST_EQUAL }
| TOK_NOT_EQUAL      { AST_NOT_EQUAL }

// boolean binary operators    
%inline bool_binary_op:
| TOK_AND_AND        { AST_AND }
| TOK_BAR_BAR        { AST_OR }


// boolean expressions    
bool_expr:
| TOK_LPAREN e=bool_expr TOK_RPAREN
    { e }
    
| TOK_TRUE
    { AST_bool_const true }
    
| TOK_FALSE
    { AST_bool_const false }
    
| o=bool_unary_op e=ext(bool_expr)
    { AST_bool_unary (o,e) }
    
| e1=ext(bool_expr) o=bool_binary_op e2=ext(bool_expr)
    { AST_bool_binary (o,e1,e2) }
    
| e1=ext(int_expr) o=compare_op e2=ext(int_expr)
    { AST_compare (o,e1,e2) }


// integer expressions    
int_expr:    
| TOK_LPAREN e=int_expr TOK_RPAREN
    { e }
    
| e=ext(TOK_int)
    { AST_int_const e }
    
| e=ext(TOK_id)
    { AST_identifier e }
    
| o=int_unary_op e=ext(int_expr)
    { AST_int_unary (o,e) }
    
| e1=ext(int_expr) o=int_binary_op e2=ext(int_expr)
    { AST_int_binary (o,e1,e2) }
    
// | TOK_RAND TOK_LPAREN e1=ext(sign_int_literal)  
//            TOK_COMMA  e2=ext(sign_int_literal) TOK_RPAREN
//     { AST_rand (e1, e2) }


// integer with optional sign, useful for TOK_RAND
sign_int_literal:
| i=TOK_int            { i }
| TOK_PLUS i=TOK_int   { i }
| TOK_MINUS i=TOK_int  { "-"^i }



/* statements */
/**************/

// blocks: some declarations, then some instructions  
block:
| TOK_LCURLY d=list(ext(decl)) l=list(ext(stat)) TOK_RCURLY  { d, l }

// a declaration, simply "int x;"
decl:
| t=typ v=TOK_id TOK_SEMICOLON { t, v }

// we only support integer types for now    
typ:
| TOK_INT { AST_INT }    

// statements    
stat:
| l=block                     
  { AST_block (fst l, snd l) }

| e=ext(TOK_id) TOK_EQUAL f=ext(int_expr) TOK_SEMICOLON
  { AST_assign (e, f) }

| TOK_IF TOK_LPAREN e=ext(bool_expr) TOK_RPAREN s=ext(stat)
  { AST_if (e, s, None) }

// | TOK_IF TOK_LPAREN e=ext(bool_expr) TOK_RPAREN s=ext(stat) TOK_ELSE t=ext(stat) 
//   { AST_if (e, s, Some t) }

| TOK_WHILE TOK_LPAREN e=ext(bool_expr) TOK_RPAREN s=ext(stat)
  { AST_while (e, s) }

// | TOK_ASSERT TOK_LPAREN e=ext(bool_expr) TOK_RPAREN TOK_SEMICOLON
//   { AST_assert e }

// | TOK_PRINT TOK_LPAREN l=separated_list(TOK_COMMA,ext(TOK_id)) TOK_RPAREN TOK_SEMICOLON
//   { AST_print l }

// | TOK_PRINT_ALL TOK_SEMICOLON
//   { AST_PRINT_ALL }

// | TOK_HALT TOK_SEMICOLON
//   { AST_HALT }


/* utilities */
/*************/

// adds extent information to rule
%inline ext(X): 
| x=X { x, ($startpos, $endpos) }


%%

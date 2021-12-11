open AST 

let () = 
begin
    let bool_t = Init_Type(
        "bool", None,
        [
            ("true", [Unit_Type]);
            ("false", [Unit_Type])
        ]
    ) and 
    not_t = Case(Var "x", [
        C("true", [Unit]), C("false", [Unit]);
        C("false", [Unit]), C("true", [Unit])
    ]) in ()
end
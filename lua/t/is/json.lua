-- x:match("^[%s\n]*[%[%{]")
return function(x) return (type(x)=='string' and (x:match("^[%s\n]*%{.*%}[%s\n]*$") or x:match("^[%s\n]*%[.*%][%s\n]*$"))) and true or false end
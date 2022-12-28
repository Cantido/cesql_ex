Nonterminals expression literal unary_logic_operator unary_numeric_operator unary_expression binary_comparison_operator binary_arithmetic_operator binary_logic_operator binary_expression set_expression in_expression like_expression exists_expression expressions.

Terminals lparen rparen comma int boolean string keyword keyword_and keyword_or keyword_xor keyword_not keyword_in keyword_like keyword_exists hyphen comparison_ne comparison_gte comparison_lte comparison_gt comparison_lt comparison_eq arithmetic_plus arithmetic_mult arithmetic_div arithmetic_mod.

Rootsymbol expression.

Left 100 binary_arithmetic_operator.
Left 200 binary_logic_operator.
Left 300 binary_comparison_operator.
Unary 1000 unary_logic_operator unary_numeric_operator.

literal -> int : extract_value('$1').
literal -> boolean : extract_value('$1').
literal -> string : extract_value('$1').

unary_logic_operator -> keyword_not : extract_token('$1').
unary_numeric_operator -> hyphen : extract_token('$1').
unary_expression -> unary_numeric_operator expression : {'$1', '$2'}.
unary_expression -> unary_logic_operator expression : {'$1', '$2'}.

binary_logic_operator -> keyword_and : extract_token('$1').
binary_logic_operator -> keyword_or : extract_token('$1').
binary_logic_operator -> keyword_xor : extract_token('$1').

binary_comparison_operator -> comparison_ne : extract_token('$1').
binary_comparison_operator -> comparison_gte : extract_token('$1').
binary_comparison_operator -> comparison_lte : extract_token('$1').
binary_comparison_operator -> comparison_gt : extract_token('$1').
binary_comparison_operator -> comparison_lt : extract_token('$1').
binary_comparison_operator -> comparison_eq: extract_token('$1').

binary_arithmetic_operator -> arithmetic_plus: extract_token('$1').
binary_arithmetic_operator -> hyphen: extract_token('$1').
binary_arithmetic_operator -> arithmetic_mult: extract_token('$1').
binary_arithmetic_operator -> arithmetic_div: extract_token('$1').
binary_arithmetic_operator -> arithmetic_mod: extract_token('$1').

binary_expression -> expression binary_logic_operator expression : {'$1', '$2', '$3'}.
binary_expression -> expression binary_comparison_operator expression : {'$1', '$2', '$3'}.
binary_expression -> expression binary_arithmetic_operator expression : {'$1', '$2', '$3'}.

set_expression -> lparen expressions rparen : '$2'.
in_expression -> expression keyword_in set_expression : {'$1', '$2', '$3'}.
in_expression -> expression keyword_not keyword_in set_expression : {'$1', '$2', '$3', '$4'}.

like_expression -> expression keyword_like string : {'$1', '$2', '$3'}.
like_expression -> expression keyword_not keyword_like string : {'$1', '$2', '$3', '$4'}.

exists_expression -> keyword_exists keyword : {'$1', '$2'}.

expressions -> expression : ['$1'].
expressions -> expression comma expressions : ['$1'|'$3'].

expression -> literal : '$1'.
expression -> keyword : '$1'.
expression -> lparen expression rparen : '$2'.
expression -> unary_expression : '$1'.
expression -> binary_expression : '$1'.
expression -> like_expression : '$1'.
expression -> exists_expression : '$1'.
expression -> in_expression : '$1'.

Erlang code.

extract_value({_Token, _Line, Value}) -> Value.
extract_token({Token, _Line}) -> Token.

Definitions.

WHITESPACE = [\s\t\n\r]

Rules.

[0-9]+         : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
true|false     : {token, {boolean, TokenLine, TokenChars == "true"}}.
"([^"]|\\")*"  : {token, {string, TokenLine, TokenChars}}.
'([^']|\\')*'  : {token, {string, TokenLine, TokenChars}}.
AND            : {token, {keyword_and, TokenLine}}.
OR            : {token, {keyword_or, TokenLine}}.
XOR            : {token, {keyword_xor, TokenLine}}.
LIKE            : {token, {keyword_like, TokenLine}}.
EXISTS            : {token, {keyword_exists, TokenLine}}.
IN            : {token, {keyword_in, TokenLine}}.
NOT            : {token, {keyword_not, TokenLine}}.

-            : {token, {hyphen, TokenLine}}.

!=            : {token, {comparison_ne, TokenLine}}.
<>            : {token, {comparison_ne, TokenLine}}.
>=            : {token, {comparison_gte, TokenLine}}.
<=            : {token, {comparison_lte, TokenLine}}.
>            : {token, {comparison_gt, TokenLine}}.
<            : {token, {comparison_lt, TokenLine}}.
=            : {token, {comparison_eq, TokenLine}}.


\+            : {token, {arithmetic_plus, TokenLine}}.
% hyphen is overloaded, defined above as `hyphen`
\*            : {token, {arithmetic_mult, TokenLine}}.
\/            : {token, {arithmetic_div, TokenLine}}.
\%            : {token, {arithmetic_mod, TokenLine}}.


[a-zA-Z0-9][a-z-A-Z0-9_]* : {token, {keyword, TokenLine, TokenChars}}.
,                        : {token, {comma, TokenLine, TokenChars}}.
\(                        : {token, {lparen, TokenLine, TokenChars}}.
\)                        : {token, {rparen, TokenLine, TokenChars}}.
{WHITESPACE}+ : skip_token.

Erlang code.


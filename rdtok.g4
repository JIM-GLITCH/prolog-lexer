/* run "java org.antlr.v4.Tool -Dlanguage=JavaScript rdtok.g4" */

/** This document is based on rdtok*/

lexer grammar rdtok;
tokens {
	STRING,
	ATOM,
	VAR,
	END
}
OPEN_CT: [ \t\r\n] '(';

WS: [ \t\r\n] -> skip;

LINE_COMMENT: '%' .*? ('\n' | EOF) -> skip;

BLOCK_COMMENT: '/*' .*? '*/' -> skip;

CUT: '!' -> type(ATOM);

OPEN: '(';

CLOSE: ')';

COMMA: ',';

SEMICOLON: ';' -> type(ATOM);

OPEN_LIST: '[';
CLOSE_LIST: ']';

OPEN_CURLY: '{';
CLOSE_CURLY: '}';

HT_SEP: '|';

FULL_STOP: '.' -> more, mode(full_stop);

STRING: '"' ('""' | ('\\' .) | ~'"') '"' -> type(STRING);

QUOTED_ATOM: '\'' SINGLE_QUOTED* '\'' -> type(ATOM);

VAR: ('_' | 'A' ..'Z') ('_' | [0-9a-zA-Z])* -> type(VAR);

INT: '0\'' SINGLE_QUOTED | [2-9] '\'' [0-9]+;
ATOM: [a-z] ('_' | [0-9a-zA-Z])*;
GRAPHIC_: GRAPHIC_CHAR+ -> type(ATOM);
fragment SINGLE_QUOTED: NON_QUOTE | '\'\'' | '"' | '`';
NON_QUOTE:
	'\\' [\\'"`]
	| CONTROL_ESCAPE_SEQUENCE
	| OCTAL_ESCAPE_SEQUENCE
	| HEXCADECIMAL_ESCAPE_SEQUENCE
	| GRAPHIC_CHAR
	| ALPHANUMERIC
	| SOLO
	| SPACE_CHAR
	| NEW_LINE;
CONTROL_ESCAPE_SEQUENCE: BACK_SLASH SYMBOLIC_CONTROL;
SYMBOLIC_CONTROL: 'a' | 'b' | 'r' | 'f' | 't' | 'n' | 'v';
META: '\\' | '\'' | '"' | '`';
BACK_SLASH: '\\';

OCTAL_ESCAPE_SEQUENCE: BACK_SLASH [0-7]+ BACK_SLASH?;
HEXCADECIMAL_ESCAPE_SEQUENCE:
	BACK_SLASH 'x' [0-9A-Fa-f]+ BACK_SLASH;
GRAPHIC_CHAR: [#$&*+\-./:<=>?@^~]| BACK_SLASH;
ALPHANUMERIC: ALPHA | [0-9];
fragment ALPHA: '_' | LETTER;
fragment LETTER: [a-zA-Z];
fragment SOLO:
	'!'
	| '('
	| ')'
	| ','
	| ';'
	| '['
	| ']'
	| '|'
	| '%';
fragment SPACE_CHAR: ' ';
fragment NEW_LINE: '\r\n' | '\r' | '\n';

mode full_stop;
EOF2: EOF -> type(END), mode(DEFAULT_MODE);
COMMENT:
	{ this._input.LA(1)=="%".charCodeAt() }? -> type(END), mode(DEFAULT_MODE);
WS2: [ \t\r\n] -> type(END), mode(DEFAULT_MODE);
GRAPHIC:
	[@$*+\-./:<=>?\\^~]* -> type(ATOM), mode(DEFAULT_MODE);

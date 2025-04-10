package chocopy.pa1;
import java_cup.runtime.*;

%%

/*** Do not change the flags below unless you know what you are doing. ***/

%unicode
%line
%column

%class ChocoPyLexer
%public

%cupsym ChocoPyTokens
%cup
%cupdebug

%eofclose false

/*** Do not change the flags above unless you know what you are doing. ***/

/* The following code section is copied verbatim to the
 * generated lexer class. */
%{
    /* The code below includes some convenience methods to create tokens
     * of a given type and optionally a value that the CUP parser can
     * understand. Specifically, a lot of the logic below deals with
     * embedded information about where in the source code a given token
     * was recognized, so that the parser can report errors accurately.
     * (It need not be modified for this project.) */

    /** Producer of token-related values for the parser. */
    final ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();

    private StringBuilder string = new StringBuilder();

    /** Return a terminal symbol of syntactic category TYPE and no
     *  semantic value at the current source location. */
    private Symbol symbol(int type) {
        return symbol(type, yytext());
    }

    /** Return a terminal symbol of syntactic category TYPE and semantic
     *  value VALUE at the current source location. */
    private Symbol symbol(int type, Object value) {
        return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[type], type,
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
            new ComplexSymbolFactory.Location(yyline + 1,yycolumn + yylength()),
            value);
  }

%}

/* === Macros === */
WhiteSpace = [ \t]
LineBreak  = \r\n|[\r\n]
Identifier = [a-zA-Z_][a-zA-Z0-9_]*
IntegerLiteral = 0|[1-9][0-9]*
Comment = [#][^\n]*
Ident =  [ \t]+
Dedent = [ \t]+

%%

<YYINITIAL> {

  /* === Palavras-chave === */
  "False"     { return symbol(ChocoPyTokens.FALSE); }
  "None"      { return symbol(ChocoPyTokens.NONE); }
  "True"      { return symbol(ChocoPyTokens.TRUE); }
  "and"       { return symbol(ChocoPyTokens.AND); }
  "as"        { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "assert"    { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "async"     { return symbol(ChocoPyTokens.UNUSED, yytext(); }
  "await"     { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "break"     { return symbol(ChocoPyTokens.UNUSED, yytext()); } 
  "class"     { return symbol(ChocoPyTokens.CLASS); }
  "continue"  { return symbol(ChocoPyTokens.UNUSED, yytext()); } 
  "def"       { return symbol(ChocoPyTokens.DEF); } 
  "del"       { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "elif"      { return symbol(ChocoPyTokens.ELIF); }
  "else"      { return symbol(ChocoPyTokens.ELSE); }
  "except"    { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "finally"   { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "for"       { return symbol(ChocoPyTokens.FOR); }
  "from"      { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "global"    { return symbol(ChocoPyTokens.GLOBAL); }
  "if"        { return symbol(ChocoPyTokens.IF); }
  "import"    { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "in"        { return symbol(ChocoPyTokens.IN); }
  "is"        { return symbol(ChocoPyTokens.IS); }
  "lambda"    { return symbol(ChocoPyTokens.UNUSED, yytext()); } 
  "nonlocal"  { return symbol(ChocoPyTokens.NONLOCAL); }
  "not"       { return symbol(ChocoPyTokens.NOT); }
  "or"        { return symbol(ChocoPyTokens.OR); } 
  "pass"      { return symbol(ChocoPyTokens.PASS); }
  "raise"     { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "return"    { return symbol(ChocoPyTokens.RETURN); }
  "try"       { return symbol(ChocoPyTokens.UNUSED, yytext()); }   
  "while"     { return symbol(ChocoPyTokens.WHILE); }
  "with"      { return symbol(ChocoPyTokens.UNUSED, yytext()); }
  "yield"     { return symbol(ChocoPyTokens.UNUSED, yytext()); }

  /* === Literais === */
  {IntegerLiteral}    { return symbol(ChocoPyTokens.NUMBER, Integer.parseInt(yytext())); }
  {StringLiteral}     { return symbol(ChocoPyTokens.STRING_LITERAL, processStringLiteral(yytext())); }

  /* === Identificadores === */
  {Identifier}        { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

  /* === Operadores === */
  "="     { return symbol(ChocoPyTokens.EQ, yytext()); }
  "=="    { return symbol(ChocoPyTokens.EQEQ, yytext()); }
  "!="    { return symbol(ChocoPyTokens.NOTEQ, yytext()); }
  "<"     { return symbol(ChocoPyTokens.LT, yytext()); }
  "<="    { return symbol(ChocoPyTokens.LTE, yytext()); }
  ">"     { return symbol(ChocoPyTokens.GT, yytext()); }
  ">="    { return symbol(ChocoPyTokens.GTE, yytext()); }
  "+"     { return symbol(ChocoPyTokens.PLUS, yytext()); }
  "-"     { return symbol(ChocoPyTokens.MINUS, yytext()); }
  "*"     { return symbol(ChocoPyTokens.MULT, yytext()); }
  "//"    { return symbol(ChocoPyTokens.INTDIV), yytext(); }
  "%"     { return symbol(ChocoPyTokens.MOD, yytext()); }

  /* === Delimitadores === */
  "."     { return symbol(ChocoPyTokens.DOT, yytext()); }
  ":"     { return symbol(ChocoPyTokens.COLON, yytext()); }
  ","     { return symbol(ChocoPyTokens.COMMA, yytext()); }
  "("     { return symbol(ChocoPyTokens.LPAREN, yytext()); }
  ")"     { return symbol(ChocoPyTokens.RPAREN, yytext()); }
  "["     { return symbol(ChocoPyTokens.LBRACK, yytext()); }
  "]"     { return symbol(ChocoPyTokens.RBRACK, yytext()); }
  "->"    { return symbol(ChocoPyTokens.ARROW, yytext()); }

  /* === Espaços e Comentários === */
  {WhiteSpace}        { /* ignora */ }
  {LineBreak}         { return symbol(ChocoPyTokens.NEWLINE); }
  {Comment}           { /* ignora */ }

  /* === IDENT e DEDENT === */
  {Ident}             { return symbol(ChocoPyTokens.IDENT); }
  {Dedent}            { return symbol(ChocoPyTokens.DEDENT); }
}

<<EOF>> {
  return symbol(ChocoPyTokens.EOF);
}

/* === Token não Reconhecido === */
[^] { return symbol(ChocoPyTokens.UNRECOGNIZED); }

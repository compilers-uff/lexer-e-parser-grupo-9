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
    
    private String processStringLiteral(String text) {
        return text.substring(1, text.length() - 1)
                   .replace("\\n", "\n")
                   .replace("\\t", "\t")
                   .replace("\\r", "\r")
                   .replace("\\\"", "\"")
                   .replace("\\\\", "\\");
    }

%}

/* === Macros === */
WhiteSpace = [ \t]+
LineBreak  = \r\n|[\r\n]
Identifier = [a-zA-Z_][a-zA-Z0-9_]*
IntegerLiteral = 0|[1-9][0-9]*
StringLiteral = \"([^\"\\n\\\\]|\\\\[btnr\"\\\\])*\" 
Comment = \#.*

%%

<YYINITIAL> {

  /* === Palavras-chave === */
  "def"       { return symbol(ChocoPyTokens.DEF); }
  "class"     { return symbol(ChocoPyTokens.CLASS); }
  "if"        { return symbol(ChocoPyTokens.IF); }
  "else"      { return symbol(ChocoPyTokens.ELSE); }
  "elif"      { return symbol(ChocoPyTokens.ELIF); }
  "while"     { return symbol(ChocoPyTokens.WHILE); }
  "for"       { return symbol(ChocoPyTokens.FOR); }
  "in"        { return symbol(ChocoPyTokens.IN); }
  "return"    { return symbol(ChocoPyTokens.RETURN); }
  "pass"      { return symbol(ChocoPyTokens.PASS); }
  "not"       { return symbol(ChocoPyTokens.NOT); }
  "and"       { return symbol(ChocoPyTokens.AND); }
  "or"        { return symbol(ChocoPyTokens.OR); }
  "is"        { return symbol(ChocoPyTokens.IS); }
  "global"    { return symbol(ChocoPyTokens.GLOBAL); }
  "nonlocal"  { return symbol(ChocoPyTokens.NONLOCAL); }
  "True"      { return symbol(ChocoPyTokens.TRUE); }
  "False"     { return symbol(ChocoPyTokens.FALSE); }
  "None"      { return symbol(ChocoPyTokens.NONE); }

  /* === Literais === */
  {IntegerLiteral}    { return symbol(ChocoPyTokens.NUMBER, Integer.parseInt(yytext())); }
  {StringLiteral}     { return symbol(ChocoPyTokens.STRING_LITERAL, processStringLiteral(yytext())); }

  /* === Identificadores === */
  {Identifier}        { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }

  /* === Operadores === */
  "="     { return symbol(ChocoPyTokens.EQ); }
  "=="    { return symbol(ChocoPyTokens.EQEQ); }
  "!="    { return symbol(ChocoPyTokens.NOTEQ); }
  "<"     { return symbol(ChocoPyTokens.LT); }
  "<="    { return symbol(ChocoPyTokens.LTE); }
  ">"     { return symbol(ChocoPyTokens.GT); }
  ">="    { return symbol(ChocoPyTokens.GTE); }
  "+"     { return symbol(ChocoPyTokens.PLUS); }
  "-"     { return symbol(ChocoPyTokens.MINUS); }
  "*"     { return symbol(ChocoPyTokens.MULT); }
  "//"    { return symbol(ChocoPyTokens.INTDIV); }
  "%"     { return symbol(ChocoPyTokens.MOD); }

  /* === Delimitadores === */
  "."     { return symbol(ChocoPyTokens.DOT); }
  ":"     { return symbol(ChocoPyTokens.COLON); }
  ","     { return symbol(ChocoPyTokens.COMMA); }
  "("     { return symbol(ChocoPyTokens.LPAREN); }
  ")"     { return symbol(ChocoPyTokens.RPAREN); }
  "["     { return symbol(ChocoPyTokens.LBRACK); }
  "]"     { return symbol(ChocoPyTokens.RBRACK); }
  "->"    { return symbol(ChocoPyTokens.ARROW); }

  /* === Espaços e Comentários === */
  {WhiteSpace}        { /* ignora */ }
  {LineBreak}         { return symbol(ChocoPyTokens.NEWLINE); }
  {Comment}           { /* ignora */ }
}

<<EOF>> {
  return symbol(ChocoPyTokens.EOF);
}

/* Token não reconhecido */
[^] { return symbol(ChocoPyTokens.UNRECOGNIZED); }

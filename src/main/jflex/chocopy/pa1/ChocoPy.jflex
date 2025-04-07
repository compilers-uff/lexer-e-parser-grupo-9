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


%state STRING

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

/* Macros (regexes used in rules below) */

WhiteSpace = [ \t]
LineBreak  = \r|\n|\r\n
InputCharacter = [^\r\n]
IntegerLiteral = 0 | [1-9][0-9]*
Identifier = [a-zA-Z_][a-zA-Z0-9_]*


StringChar        = [^\"\n\\]
EscapeSequence    = \\[btnr\"\\]
Comment           = \#.*


%%

<YYINITIAL> {


  /* KeyWords */
  "def"           { return symbol(ChocoPyTokens.DEF); }
  "class"         { return symbol(ChocoPyTokens.CLASS); }
  "if"            { return symbol(ChocoPyTokens.IF); }
  "else"          { return symbol(ChocoPyTokens.ELSE); }
  "elif"          { return symbol(ChocoPyTokens.ELIF); }
  "while"         { return symbol(ChocoPyTokens.WHILE); }
  "return"        { return symbol(ChocoPyTokens.RETURN); }
  "pass"          { return symbol(ChocoPyTokens.PASS); }
  "not"           { return symbol(ChocoPyTokens.NOT); }
  "and"           { return symbol(ChocoPyTokens.AND); }
  "or"            { return symbol(ChocoPyTokens.OR); }
  "None"          { return symbol(ChocoPyTokens.NONE); }
  "True"          { return symbol(ChocoPyTokens.TRUE); }
  "False"         { return symbol(ChocoPyTokens.FALSE); }
  "global"        { return symbol(ChocoPyTokens.GLOBAL); }
  "nonlocal"      { return symbol(ChocoPyTokens.NONLOCAL); }


  /* Delimiters. */
  {LineBreak}                 { return symbol(ChocoPyTokens.NEWLINE); }

  /* Literals. */
  {IntegerLiteral}            { return symbol(ChocoPyTokens.NUMBER,
                                                 Integer.parseInt(yytext())); }

  /* Operators. */
  "+"                         { return symbol(ChocoPyTokens.PLUS, yytext()); }
  "/"                         { return symbol(ChocoPyTokens.INTDIV, yytext()); }
  "="                         { return symbol(ChocoPyTokens.EQ); }
  "=="                        { return symbol(ChocoPyTokens.EQEQ); }
  "!="                        { return symbol(ChocoPyTokens.NOTEQ); }
  "<"                         { return symbol(ChocoPyTokens.LT); }
  "<="                        { return symbol(ChocoPyTokens.LTE); }
  ">"                         { return symbol(ChocoPyTokens.GT); }
  ">="                        { return symbol(ChocoPyTokens.GTE); }
  "-"                         { return symbol(ChocoPyTokens.MINUS); }
  "*"                         { return symbol(ChocoPyTokens.STAR); }
  "//"                        { return symbol(ChocoPyTokens.SLASH); }
  "."                         { return symbol(ChocoPyTokens.DOT); }
  ":"                         { return symbol(ChocoPyTokens.COLON); }
  ","                         { return symbol(ChocoPyTokens.COMMA); }
  "("                         { return symbol(ChocoPyTokens.LPAREN); }
  ")"                         { return symbol(ChocoPyTokens.RPAREN); }
  "["                         { return symbol(ChocoPyTokens.LBRACK); }
  "]"                        { return symbol(ChocoPyTokens.RBRACK); }


  /* Whitespace. */
  {WhiteSpace}                { /* ignore */ }

  /* Comment. */
  {Comment}       { /* ignorar */ }
}

<STRING> {
  [^\"\n\\]+ { string.append(yytext()); }

  \\t { string.append('\t'); }
  \\n { string.append('\n'); }
  \\r { string.append('\r'); }
  \\\" { string.append('\"'); }
  \\\\ { string.append('\\'); }

  \" {
    yybegin(YYINITIAL);
    return symbol(ChocoPyTokens.STRING_LITERAL, string.toString());
  }

  \n|\r { return symbol(ChocoPyTokens.UNRECOGNIZED); }
}

<<EOF>>                       { return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                           { return symbol(ChocoPyTokens.UNRECOGNIZED); }
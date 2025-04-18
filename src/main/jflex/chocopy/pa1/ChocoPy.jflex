package chocopy.pa1;
import java_cup.runtime.*;
import java.util.Iterator;
import java.util.ArrayList;

%%

/*** Do not change the flags below unless you know what you are doing. ***/

%unicode
%line
%column
%states YYAFTER
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
    private int indent_current = 0;
    private String string_current = "";
    private int string_line = 0, string_column = 0;

    private ArrayList<Integer> stack = new ArrayList<Integer>(); 
    private boolean indentErrorUnchecked = true;

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
    private void push(int indent){
      stack.add(indent);
    }
    private int pop(){
        if(stack.isEmpty()) return 0;
        return stack.remove(stack.size() - 1);
    }
    private int top(){
        if(stack.isEmpty()) return 0;
        return stack.get(stack.size() - 1);
    }
    private boolean find(int indent){
      if(indent == 0) return true;
      Iterator<Integer> it = stack.iterator();
      while(it.hasNext()){
         if(it.next() == indent)
            return true;
      }
      return false;
    }
%}

/* === Macros === */
WhiteSpace = [ \t]
LineBreak  = \r\n|[\r\n]
IntegerLiteral = 0|[1-9][0-9]*
StringLiteral = \"(\\.|[^\"\\])*\"
Identifier = [a-zA-Z_][a-zA-Z0-9_]*
Comment = #[^\r\n]*
%%

<YYINITIAL> {

  /* === Espaços e Comentários === */
  {WhiteSpace} {
    if (yytext().equals("\t"))
      indent_current += 8;
    else
      indent_current += 1;
  }

  {LineBreak} { 
    indent_current = 0;
  }

  {Comment}           { /* ignora */ }

  [^ \t\r\n#] {
      yypushback(1);  // Caractere que não é espaço/tab/linha/comentário

      int currentTop = top();

      if (currentTop > indent_current) {
          pop();
          if (top() < indent_current) {
              // Indentação errada entre dois níveis conhecidos
              indent_current = top();
              return symbolFactory.newSymbol("<bad indentation>", ChocoPyTokens.UNRECOGNIZED,
                  new ComplexSymbolFactory.Location(yyline + 1, yycolumn - 1),
                  new ComplexSymbolFactory.Location(yyline + 1, yycolumn + yylength()),
                  indent_current);
          }
          // Retorna DEDENT
          return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[ChocoPyTokens.DEDENT], ChocoPyTokens.DEDENT,
              new ComplexSymbolFactory.Location(yyline + 1, yycolumn - 1),
              new ComplexSymbolFactory.Location(yyline + 1, yycolumn + yylength()),
              indent_current);
      }

      yybegin(YYAFTER);

      if (currentTop < indent_current) {
          push(indent_current);
          return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[ChocoPyTokens.INDENT], ChocoPyTokens.INDENT,
              new ComplexSymbolFactory.Location(yyline + 1, yycolumn - 1),
              new ComplexSymbolFactory.Location(yyline + 1, yycolumn + yylength()),
              indent_current);
      }
  }
}

<YYAFTER>{

  {LineBreak}         { yybegin(YYINITIAL); indent_current = 0; indentErrorUnchecked = true; return symbol(ChocoPyTokens.NEWLINE);}

  /* === Espaços e Comentários === */
  {WhiteSpace}        { /* ignora */ }
  {Comment}           { /* ignora */ }

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
  {StringLiteral}     {return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[ChocoPyTokens.STRING], ChocoPyTokens.STRING,
                                                      new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
                                                      new ComplexSymbolFactory.Location(yyline + 1,yycolumn + yylength()), 
                                                      yytext().replace("\"", "")); }
  
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
  "/"     { return symbol(ChocoPyTokens.DIV); }
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

}

<<EOF>> {

  // Processa DEDENTs 
  if (!stack.isEmpty()) {
    int lastIndent = pop();
    // Se ainda há níveis na pilha, continua processando
  if (!stack.isEmpty()) {
      yypushback(1); // Nova chamada ao EOF
    }
  return symbol(ChocoPyTokens.DEDENT, lastIndent);
  }
  return symbol(ChocoPyTokens.EOF);
}

/* Token não reconhecido */
[^] { return symbol(ChocoPyTokens.UNRECOGNIZED); }

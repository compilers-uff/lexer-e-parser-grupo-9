[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/4nHL7_6-)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=18895483&assignment_repo_type=AssignmentRepo)
# CS 164: Programming Assignment 1

[PA1 Specification]: https://drive.google.com/open?id=1oYcJ5iv7Wt8oZNS1bEfswAklbMxDtwqB
[ChocoPy Specification]: https://drive.google.com/file/d/1mrgrUFHMdcqhBYzXHG24VcIiSrymR6wt

Note: Users running Windows should replace the colon (`:`) with a semicolon (`;`) in the classpath argument for all command listed below.

## Getting started

Run the following command to generate and compile your parser, and then run all the provided tests:

    mvn clean package

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=s --test --dir src/test/data/pa1/sample/

In the starter code, only one test should pass. Your objective is to build a parser that passes all the provided tests and meets the assignment specifications.

To manually observe the output of your parser when run on a given input ChocoPy program, run the following command (replace the last argument to change the input file):

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=s src/test/data/pa1/sample/expr_plus.py

You can check the output produced by the staff-provided reference implementation on the same input file, as follows:

    java -cp "chocopy-ref.jar:target/assignment.jar" chocopy.ChocoPy --pass=r src/test/data/pa1/sample/expr_plus.py

Try this with another input file as well, such as `src/test/data/pa1/sample/coverage.py`, to see what happens when the results disagree.

## Assignment specifications

See the [PA1 specification][] on the course
website for a detailed specification of the assignment.

Refer to the [ChocoPy Specification][] on the CS164 web site
for the specification of the ChocoPy language. 

## Receiving updates to this repository

Add the `upstream` repository remotes (you only need to do this once in your local clone):

    git remote add upstream https://github.com/cs164berkeley/pa1-chocopy-parser.git

To sync with updates upstream:

    git pull upstream master


## Membros

Membros do Grupo: Felipe Mendes Salles, Fernando Moreira e Lucas Lopes

## Respostas da Entrega 1

**Que estratégia você usou para emitir tokens INDENT e DEDENT corretamente? Mencione o nome do arquivo e o(s) número(s) da(s) linha(s) para a parte principal da sua solução.**

R: A estratégia para emissão correta dos tokens INDENT e DEDENT no arquivo ChocoPyLexer.jflex (linhas 85-123 e 195-204) baseia-se em uma implementação de pilha que avalia os níveis de indentação. Durante a análise léxica no estado YYINITIAL, o lexer calcula a indentação atual (indent_current) contando espaços (1 por caractere) e tabs (8 espaços). Quando encontra um caractere não-branco, compara a indentação atual com o topo da pilha (currentTop): se maior, empilha o novo nível e emite INDENT; se menor, desempilha e emite DEDENT, com verificação de consistência para detectar indentação inválida. No final do arquivo (<<EOF>>), a estratégia desempilha todos os níveis restantes, emitindo DEDENTs pendentes para fechar blocos abertos, garantindo que a estrutura do código esteja corretamente aninhada mesmo sem delimitadores explícitos. A pilha mantém o histórico de níveis válidos, enquanto as transições entre YYINITIAL e YYAFTER controlam quando a indentação deve ser verificada.

**Como sua solução ao item 1 se relaciona ao descrito na seção 3.1 do manual de referência de ChocoPy? (Arquivo chocopy_language_reference.pdf.)**S

R: Nossa solução implementa os requisitos do manual do ChocoPy sobre indentação, utilizando uma pilha para gerenciar os níveis de indentação conforme especificado. Assim como descrito no manual, ao detectar um aumento na indentação em relação ao topo da pilha, um token INDENT é emitido e o novo nível é empilhado (linhas 108-113), enquanto uma diminuição gera tokens DEDENT até alcançar um nível válido (linhas 88-102), incluindo o tratamento especial para TABS como 8 espaços (linhas 68-71). O fechamento de blocos no final do arquivo (linhas 195-204) também segue estritamente a especificação, emitindo DEDENTs para todos os níveis pendentes na pilha, garantindo que todas as estruturas indentadas sejam corretamente finalizadas, exatamente como especifica o manual de referência.

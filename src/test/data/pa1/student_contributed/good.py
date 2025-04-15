#Declaraçao de função
def soma(a: int, b: int) -> int:
    return a + b

#Declaraçao de classe
class Animal(object):
    nome: str = "foo"

    def __init__(self: "Animal"):
        self.nome = "fii"

    def fala(self: "Animal") -> str:
        return "fuuu"

#Declaraçao de ifs aninhados
if x < y and x < z:
    print("x é menor")
    if x < z:
        print("x ainda é menor")
        if x < w:
            print("x continua é menor")
elif x == y:
    print("são iguais")
else:
    print("x é maior")

#aninhamento de expressões
z = (((y + x)%z)*10)//3

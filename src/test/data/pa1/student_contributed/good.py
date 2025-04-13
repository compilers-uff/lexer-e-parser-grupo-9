x: int = 1
y: int = 2

class Animal(object):
    nome: str = "bicho"

    def __init__(self: "Animal"):
        self.nome = "animal"

    def fala(self: "Animal") -> str:
        return "???"


if x < y:
    print("x é menor")
elif x == y:
    print("são iguais")
else:
    print("x é maior")

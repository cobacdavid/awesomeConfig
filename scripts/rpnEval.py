#!/usr/bin/env python3
import sys


class Pile:
    def __init__(self, liste=[]):
        self.liste = liste[:]

    def __test_op_binaire(self):
        if len(self.liste) < 2:
            raise Exception('il faut au moins deux éléments dans la pile')

    def __str__(self):
        return str(self.liste)

    def somme_algebrique(self, operation='+'):
        self.__test_op_binaire()
        #
        resultat = eval(str(self.liste[-2]) + operation + str(self.liste[-1]))
        self.liste = self.liste[:-2] + [resultat]

    def plus(self):
        self.somme_algebrique('+')

    def moins(self):
        self.somme_algebrique('-')

    def fois(self):
        self.__test_op_binaire()
        #
        resultat = self.liste[-2] * self.liste[-1]
        self.liste = self.liste[:-2] + [resultat]

    def divise(self):
        self.__test_op_binaire()
        #
        resultat = self.liste[-2] / self.liste[-1]
        self.liste = self.liste[:-2] + [resultat]

    def neg(self):
        self.liste[-1] = -self.liste[-1]

    def carre(self):
        self.liste[-1] **= 2

    def racine(self):
        self.liste[-1] **= .5

    def ajoute_element(self, element):
        self.liste.append(eval(element))

    def voir(self):
        return self.liste

    def swap(self):
        self.liste[-1], self.liste[-2] = self.liste[-2], self.liste[-1]

    def dup(self):
        n = self.liste.pop()
        self.liste = self.liste + self.liste[-n:]

    def drop(self):
        self.liste.pop()

    def egalite(self):
        b = +(self.liste[-2] == self.liste[-1])
        self.liste = self.liste[:-2] + [b]

    def rot(self):
        if len(self.liste) >= 3:
            self.liste[-1], self.liste[-2], self.liste[-3] = \
                self.liste[-3], self.liste[-1], self.liste[-2]

    def roll(self):
        n = self.liste.pop()
        self.liste.insert(-n, self.liste[-1])
        self.liste.pop()


class Calcul_RPN:
    def __init__(self, expression, pile=[]):
        self.liste = expression.strip().split()
        self.pile = Pile(pile)

    def evalue(self, etapes=False):
        for element in self.liste:
            if element == '+':
                self.pile.plus()
            elif element == '-':
                self.pile.moins()
            elif element == '*':
                self.pile.fois()
            elif element == '/':
                self.pile.divise()
            elif element == "neg":
                self.pile.neg()
            elif element == "carre" or element == "sq":
                self.pile.carre()
            elif element == "racine" or element == "sqrt":
                self.pile.racine()
            elif element == "swap":
                self.pile.swap()
            elif element == "dup":
                self.pile.ajoute_element('1')
                self.pile.dup()
            elif element == "dup2":
                self.pile.ajoute_element('2')
                self.pile.dup()
            elif element == "dupn":
                self.pile.dup()
            elif element == "drop":
                self.pile.drop()
            elif element == "rot":
                self.pile.rot()
            elif element == "roll":
                self.pile.roll()
            elif element == "==":
                self.pile.egalite()
            else:
                self.pile.ajoute_element(element)
            if etapes:
                print(self.pile)

    def __str__(self):
        return str(self.pile)


if len(sys.argv) == 2:
    expression = sys.argv[1]
    c = Calcul_RPN(expression)
    c.evalue()
    print(c)
else:
    print("1 seul argument demandé")


# expressions = ["5 3 - carre 5 3 dup2 2 * * neg swap carre + swap carre + ==",
#                "5 3 dup2 dup2 - carre rot rot 2 * * neg rot carre + rot carre + ==",
#                "5 3 dup2 - carre 3 roll dup2 2 * * neg swap carre + swap carre + =="]
# for e in expressions:
#     c = Calcul_RPN(e)
#     c.evalue(etapes=True)
#     print("Pile de sortie :", c, "\n")

# e = "1 2 3 4 5 6 7 8 9 drop 3 dupn"
# c = Calcul_RPN(e)
# c.evalue(etapes=True)
# print("Pile de sortie :", c , "\n")

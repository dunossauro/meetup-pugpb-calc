from unittest import TestCase
from app import calc


class TestCalc(TestCase):
    def test_soma_deve_existir_em_app(self):
        self.assertIn('soma', dir(calc))

    def test_soma_deve_ser_uma_função(self):
        self.assertIn('__call__', dir(calc.soma))

    def test_soma_deve_receber_2_argumentos(self):
        self.assertEqual(2, calc.soma.__code__.co_argcount)

    def test_soma_deve_ter_os_parâmetros_x_e_y(self):
        self.assertEqual('x', calc.soma.__code__.co_varnames[0])
        self.assertEqual('y', calc.soma.__code__.co_varnames[1])

    def test_soma_x_y_retorna_z(self):
        somaveis = [
            (1, 1, 2),
            (1, 2, 3),
            (2, 2, 4),
            (3, 3, 6),
        ]
        for x, y, z in somaveis:
            with self.subTest(x=x, y=y, z=z):
                self.assertEqual(z, calc.soma(x, y))

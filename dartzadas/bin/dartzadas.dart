import 'dart:io';
import 'package:math_expressions/math_expressions.dart';

void main() {
  print('--- Calculadora de Expressões ---');
  print('Digite uma expressão matemática ou "sair" para fechar.');

  while (true) {    
    String? expressaoString = stdin.readLineSync();

    if (expressaoString == null || expressaoString.toLowerCase() == 'sair') {
      print('Encerrando a calculadora.');
      break;
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(expressaoString);
      ContextModel cm = ContextModel();
      double resultado = exp.evaluate(EvaluationType.REAL, cm);

      
      // Verificamos se o resultado é infinito antes de imprimir.
      if (resultado.isInfinite) {
        print('Erro: Divisão por zero não é permitida.');
      } 
      // Bônus: Também podemos verificar se o resultado é "NaN" (Not a Number),
      // que ocorre em operações como a raiz quadrada de um número negativo.
      else if (resultado.isNaN) {
        print('Erro: A operação resultou em um valor indefinido (NaN).');
      }
      // Se não for nenhum dos casos acima, o resultado é válido.
      else {
        print('O resultado é: $resultado');
      }
      

    } catch (e) {
      print('Expressão inválida. Por favor, tente novamente.');
    }
  }
}
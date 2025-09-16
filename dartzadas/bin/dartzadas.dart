import 'dart:io';
import 'package:math_expressions/math_expressions.dart';

void main() {
  print('--- Calculadora de Expressões ---');
  print('Digite uma expressão matemática ou "sair" para fechar.');

  final parser = GrammarParser();
  final evaluator = RealEvaluator();

  while (true) {
    String? expressaoString = stdin.readLineSync();

    if (expressaoString == null || expressaoString.toLowerCase() == 'sair') {
      print('Encerrando a calculadora.');
      break;
    }

    try {
      Expression exp = parser.parse(expressaoString);
      ContextModel cm = ContextModel();
      double resultado = evaluator.evaluate(exp).toDouble();

      if (resultado.isInfinite) {
        print('Erro: Divisão por zero não é permitida.');
      } else if (resultado.isNaN) {
        print('Erro: A operação resultou em um valor indefinido (NaN).');
      } else {
        print('O resultado é: $resultado');
      }
    } catch (e) {
      print('Expressão inválida. Por favor, tente novamente.');
    }
  }
}
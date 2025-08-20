import 'dart:io';
import 'package:math_expressions/math_expressions.dart';

void main() {
  print('--- Calculadora de Expressões ---');
  print('Digite uma expressão matemática ou "sair" para fechar.');

  while (true) {
    print('\nSua expressão:');
    String? expressaoString = stdin.readLineSync();

    // Condição para sair do loop
    if (expressaoString == null || expressaoString.toLowerCase() == 'sair') {
      print('Encerrando a calculadora.');
      break;
    }

    try {
      // 1. Prepara o parser (o "cérebro" que lê a expressão)
      Parser p = Parser();
      // 2. Transforma a string em uma expressão matemática compreensível
      Expression exp = p.parse(expressaoString);

      // 3. Prepara um modelo de contexto (para variáveis como 'pi' ou 'e')
      ContextModel cm = ContextModel();

      // 4. Avalia (calcula) a expressão e obtém o resultado
      double resultado = exp.evaluate(EvaluationType.REAL, cm);

      // 5. Mostra o resultado
      print('O resultado é: $resultado');

    } catch (e) {
      // Se o usuário digitar algo inválido (ex: "5 + * 3"), o programa não vai quebrar.
      print('Expressão inválida. Por favor, tente novamente. Erro: $e');
    }
  }
}
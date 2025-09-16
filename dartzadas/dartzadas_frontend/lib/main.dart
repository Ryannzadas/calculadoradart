import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _expressionController = TextEditingController();
  String _resultText = '';

  void _append(String value) {
    final String current = _expressionController.text;
    _expressionController.text = current + value;
    _expressionController.selection = TextSelection.fromPosition(
      TextPosition(offset: _expressionController.text.length),
    );
  }

  void _clear() {
    _expressionController.clear();
    setState(() => _resultText = '');
  }

  void _backspace() {
    final String current = _expressionController.text;
    if (current.isEmpty) return;
    _expressionController.text = current.substring(0, current.length - 1);
    _expressionController.selection = TextSelection.fromPosition(
      TextPosition(offset: _expressionController.text.length),
    );
  }

  void _evaluate() {
    final String expressionString = _expressionController.text.trim();
    if (expressionString.isEmpty) {
      setState(() => _resultText = '');
      return;
    }

    try {
      final Parser parser = Parser();
      final Expression expression = parser.parse(expressionString);
      final ContextModel contextModel = ContextModel();
      final double result = expression.evaluate(EvaluationType.REAL, contextModel).toDouble();

      if (result.isInfinite) {
        setState(() => _resultText = 'Erro');
      } else if (result.isNaN) {
        setState(() => _resultText = 'Erro');
      } else {
        setState(() => _resultText = result.toString());
      }
    } catch (_) {
      setState(() => _resultText = 'Expressão inválida.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Expressões'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _expressionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite a expressão',
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _evaluate(),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _resultText.isEmpty ? 'Resultado aparecerá aqui' : _resultText,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    _CalcButton(label: '7', onTap: () => _append('7')),
                    _CalcButton(label: '8', onTap: () => _append('8')),
                    _CalcButton(label: '9', onTap: () => _append('9')),
                    _CalcButton(label: '/', onTap: () => _append('/')),
                    _CalcButton(label: '4', onTap: () => _append('4')),
                    _CalcButton(label: '5', onTap: () => _append('5')),
                    _CalcButton(label: '6', onTap: () => _append('6')),
                    _CalcButton(label: '*', onTap: () => _append('*')),
                    _CalcButton(label: '1', onTap: () => _append('1')),
                    _CalcButton(label: '2', onTap: () => _append('2')),
                    _CalcButton(label: '3', onTap: () => _append('3')),
                    _CalcButton(label: '-', onTap: () => _append('-')),
                    _CalcButton(label: '0', onTap: () => _append('0')),
                    _CalcButton(label: '.', onTap: () => _append('.')),
                    _CalcButton(label: '(', onTap: () => _append('(')),
                    _CalcButton(label: ')', onTap: () => _append(')')),
                    _CalcButton(label: 'C', onTap: _clear, isAccent: true),
                    _CalcButton(label: '⌫', onTap: _backspace, isAccent: true),
                    _CalcButton(label: '^', onTap: () => _append('^')),
                    _CalcButton(label: '+', onTap: () => _append('+')),
                    _CalcButton(label: '√', onTap: () => _append('sqrt(')),
                    _CalcButton(label: 'sin', onTap: () => _append('sin(')),
                    _CalcButton(label: 'cos', onTap: () => _append('cos(')),
                    _CalcButton(label: '=', onTap: _evaluate, isPrimary: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isAccent;

  const _CalcButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color background = isPrimary
        ? colors.primary
        : isAccent
            ? colors.tertiaryContainer
            : colors.surfaceContainerHigh;
    final Color foreground = isPrimary ? colors.onPrimary : colors.onSurfaceVariant;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }
}

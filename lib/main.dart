// lib/main.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scientific Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  // ignore: libraryprivatetypesinpublicapi
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String history = '';
  double firstValue = 0;
  double? secondValue;
  String? operation;
  bool shouldResetDisplay = false;
  bool isInScientificMode = false;
  bool isInRadianMode = true;

  void addDigit(String digit) {
    setState(() {
      if (display == '0' || shouldResetDisplay) {
        display = digit;
        shouldResetDisplay = false;
      } else {
        display += digit;
      }
    });
  }

  void addDecimal() {
    setState(() {
      if (shouldResetDisplay) {
        display = '0.';
        shouldResetDisplay = false;
      } else if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  void setOperation(String newOperation) {
    setState(() {
      firstValue = double.parse(display);
      operation = newOperation;
      history = '$display $newOperation ';
      shouldResetDisplay = true;
    });
  }

  void calculateResult() {
    if (operation == null) return;

    setState(() {
      secondValue = double.parse(display);
      double result = 0;

      switch (operation) {
        case '+':
          result = firstValue + secondValue!;
          break;
        case '-':
          result = firstValue - secondValue!;
          break;
        case '×':
          result = firstValue * secondValue!;
          break;
        case '÷':
          if (secondValue == 0) {
            display = 'Error';
            history = '';
            operation = null;
            return;
          }
          result = firstValue / secondValue!;
          break;
        case '^':
          result = math.pow(firstValue, secondValue!).toDouble();
          break;
      }

      history = '$history$secondValue =';
      display = formatResult(result);
      operation = null;
      shouldResetDisplay = true;
    });
  }

  String formatResult(double result) {
    // Convert to integer if the result is a whole number
    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    return result.toString();
  }

  void clear() {
    setState(() {
      display = '0';
      history = '';
      operation = null;
      firstValue = 0;
      secondValue = null;
      shouldResetDisplay = false;
    });
  }

  // void backSpace() {
  //   if (display.length >= 2) {}
  // }

  void performScientificOperation(String operation) {
    double value = double.parse(display);
    double result = 0;

    setState(() {
      switch (operation) {
        case 'sin':
          result = performTrigFunction(math.sin, value);
          break;
        case 'cos':
          result = performTrigFunction(math.cos, value);
          break;
        case 'tan':
          result = performTrigFunction(math.tan, value);
          break;
        case 'log':
          result = math.log(value) / math.ln10;
          break;
        case 'ln':
          result = math.log(value);
          break;
        case '√':
          result = math.sqrt(value);
          break;
        case 'x²':
          result = value * value;
          break;
        case 'π':
          result = math.pi;
          break;
        case 'e':
          result = math.e;
          break;
        case '!':
          result = factorial(value);
          break;
        case '±':
          result = -value;
          break;
      }

      history = '$operation($display) =';
      display = formatResult(result);
      shouldResetDisplay = true;
    });
  }

  double performTrigFunction(
      double Function(double) trigFunction, double value) {
    if (!isInRadianMode) {
      value = value * math.pi / 180;
    }
    return trigFunction(value);
  }

  double factorial(double n) {
    if (n <= 1) return 1;
    if (n != n.toInt()) return double.nan;

    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  void toggleAngleMode() {
    setState(() {
      isInRadianMode = !isInRadianMode;
    });
  }

  Widget button(String label, VoidCallback onPressed,
      {Color? textcolor, Icon? icon, int flex = 1}) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        //icon != null?
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(fontSize: 25, color: textcolor ?? Colors.white70),
          ),
        )
        // : IconButton(onPressed: onPressed, icon: icon!),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        actions: [
          IconButton(
            icon: Icon(isInScientificMode ? Icons.science : Icons.calculate),
            onPressed: () {
              setState(() {
                isInScientificMode = !isInScientificMode;
              });
            },
            tooltip: 'Toggle Scientific Mode',
          ),
        ],
      ),
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    // height: MediaQuery.sizeOf(context).height * 0.4,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          history,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          display,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isInScientificMode)
                          Text(
                            isInRadianMode ? 'RAD' : 'DEG',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // if (isInScientificMode)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //     child: Column(
                  //       children: [
                  // Row(
                  //   children: [
                  //     button(
                  //         'sin', () => performScientificOperation('sin')),
                  //     button(
                  //         'cos', () => performScientificOperation('cos')),
                  //     button(
                  //         'tan', () => performScientificOperation('tan')),
                  //     button(
                  //         'log', () => performScientificOperation('log')),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     button('ln', () => performScientificOperation('ln')),
                  //     button('√', () => performScientificOperation('√')),
                  //     button('x²', () => performScientificOperation('x²')),
                  //     button('^', () => setOperation('^')),
                  //   ],
                  // ),
                  //       ],
                  //     ),
                  //   ),
                ],
              )),
          Expanded(
            flex: 1,
            // height: MediaQuery.sizeOf(context).height * 0.4,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isInScientificMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          button('sin', () => performScientificOperation('sin'),
                              textcolor: Colors.blueAccent),
                          button('cos', () => performScientificOperation('cos'),
                              textcolor: Colors.blueAccent),
                          button('tan', () => performScientificOperation('tan'),
                              textcolor: Colors.blueAccent),
                          button('log', () => performScientificOperation('log'),
                              textcolor: Colors.blueAccent),
                        ],
                      ),
                    if (isInScientificMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          button('ln', () => performScientificOperation('ln'),
                              textcolor: Colors.blueAccent),
                          button('√', () => performScientificOperation('√'),
                              textcolor: Colors.blueAccent),
                          button('x²', () => performScientificOperation('x²'),
                              textcolor: Colors.blueAccent),
                        ],
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isInScientificMode)
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          button('^', () => setOperation('^'),
                              textcolor: Colors.blueAccent),
                          button('π', () => performScientificOperation('π'),
                              textcolor: Colors.blueAccent),
                          button('e', () => performScientificOperation('e'),
                              textcolor: Colors.blueAccent),
                          button('!', () => performScientificOperation('!'),
                              textcolor: Colors.blueAccent),
                          button(
                              isInRadianMode ? 'DEG' : 'RAD', toggleAngleMode,
                              textcolor: Colors.blueAccent),
                        ],
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        button('C', clear, textcolor: Colors.redAccent),
                        button('7', () => addDigit('7')),
                        button('4', () => addDigit('4')),
                        button('1', () => addDigit('1')),
                        button('.', addDecimal),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        button('±', () => performScientificOperation('±')),
                        button('8', () => addDigit('8')),
                        button('5', () => addDigit('5')),
                        button('2', () => addDigit('2')),
                        button('0', () => addDigit('0')),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        button('%', () {
                          setState(() {
                            double value = double.parse(display);
                            display = formatResult(value / 100);
                          });
                        }),
                        button('9', () => addDigit('9')),
                        button('6', () => addDigit('6')),
                        button('3', () => addDigit('3')),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        button('÷', () => setOperation('÷'),
                            textcolor: Colors.orangeAccent),
                        button('×', () => setOperation('×'),
                            textcolor: Colors.orangeAccent),
                        button('-', () => setOperation('-'),
                            textcolor: Colors.orangeAccent),
                        button('+', () => setOperation('+'),
                            textcolor: Colors.orangeAccent),
                        button('=', calculateResult,
                            textcolor: Colors.greenAccent),
                      ],
                    ),

                    // button(
                    //     icon: Icon(Icons.backspace),
                    //     () => backSpace()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
                    // if (isInScientificMode)
                    //   Column(
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       button('π', () => performScientificOperation('π')),
                    //       button('e', () => performScientificOperation('e')),
                    //       button('!', () => performScientificOperation('!')),
                    //       button(
                    //           isInRadianMode ? 'DEG' : 'RAD', toggleAngleMode,
                    //           textcolor: Colors.blueAccent),
                    //     ],
                    //   ),



                        //   child: Column(
                        //     children: [
                        //       button('C', clear, textcolor: Colors.redAccent),
                        //       button(
                        //           '±', () => performScientificOperation('±')),
                        //       button('%', () {
                        //         setState(() {
                        //           double value = double.parse(display);
                        //           display = formatResult(value / 100);
                        //         });
                        //       }),
                        //       button('÷', () => setOperation('÷'),
                        //           textcolor: Colors.orangeAccent),
                        //     ],
                        //   ),
                        // ),
                        // Row(
                        //   children: [
                        //     button('7', () => addDigit('7')),
                        //     button('8', () => addDigit('8')),
                        //     button('9', () => addDigit('9')),
                        //     button('×', () => setOperation('×'),
                        //         textcolor: Colors.orangeAccent),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     button('4', () => addDigit('4')),
                        //     button('5', () => addDigit('5')),
                        //     button('6', () => addDigit('6')),
                        //     button('-', () => setOperation('-'),
                        //         textcolor: Colors.orangeAccent),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     button('1', () => addDigit('1')),
                        //     button('2', () => addDigit('2')),
                        //     button('3', () => addDigit('3')),
                        //     button('+', () => setOperation('+'),
                        //         textcolor: Colors.orangeAccent),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     button('0', () => addDigit('0'), flex: 2),
                        //     button('.', addDecimal),
                        //     // button(
                        //     //     icon: Icon(Icons.backspace),
                        //     //     () => backSpace()),
                        //     button('=', calculateResult,
                        //         textcolor: Colors.greenAccent),
                        //   ],
                        // ),
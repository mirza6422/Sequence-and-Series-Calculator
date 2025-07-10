import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seq_series_calculator/providers/sequence_provider.dart';
import 'package:seq_series_calculator/screens/arithmetic_seq_screen.dart';
import 'package:seq_series_calculator/screens/geometric_seq_screen.dart';
import 'package:seq_series_calculator/screens/home_screen.dart';
import 'package:seq_series_calculator/screens/recurrence_screen.dart';
import 'package:seq_series_calculator/screens/sigma_notation_screen.dart'; // Import python_ffi

void main() {
  // No Python FFI initialization needed
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SequenceProvider())],
      child: MaterialApp(
        title: 'Sequence & Series Calculator',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
            labelStyle: const TextStyle(color: Colors.deepPurple),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/arithmetic': (context) => const ArithmeticSequenceScreen(),
          '/geometric': (context) => const GeometricSequenceScreen(),
          '/sigma': (context) => const SigmaNotationScreen(),
          '/recurrence': (context) => const RecurrenceScreen(),
        },
      ),
    );
  }
}

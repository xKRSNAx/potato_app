import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // Запускаем приложение напрямую, без инициализации AdMob
  runApp(const PotatoApp());
}

class PotatoApp extends StatelessWidget {
  const PotatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сорта картофеля',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
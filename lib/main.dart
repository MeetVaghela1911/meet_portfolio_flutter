// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'presentation/portfolio_home_page.dart';

// void main() {
//   runApp(const PortfolioApp());
// }

// class PortfolioApp extends StatelessWidget {
//   const PortfolioApp({super.key});

//   @override
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/portfolio_home_page.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meet Vaghela ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF133C55),
          primary: const Color(0xFF133C55),
          secondary: const Color(0xFF386FA4),
          background: Colors.white,
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: const Color(0xFF0F172A),
          displayColor: const Color(0xFF0F172A),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionShell extends StatelessWidget {
  const SectionShell({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.backgroundColor = Colors.transparent,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152), // max-w-6xl
          child: Column(
            children: [
              // Title with Gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                ).createShader(bounds),
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 36, // 4xl
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Required for ShaderMask
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).moveY(begin: 20, end: 0),

              const SizedBox(height: 24),

              // Gradient Divider
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scaleX(begin: 0, end: 1),

              if (subtitle != null) ...[
                const SizedBox(height: 24),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: const Color(0xFF4B5563), // gray-600
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms).moveY(begin: 20, end: 0),
              ],

              const SizedBox(height: 64),

              child,
            ],
          ),
        ),
      ),
    );
  }
}

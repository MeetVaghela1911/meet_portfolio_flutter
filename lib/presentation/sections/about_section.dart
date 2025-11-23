import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/section_shell.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      title: 'About Me',
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Text(
            'I am a passionate Mobile Application Developer with a strong focus on building high-quality, user-centric apps. With expertise in Flutter and Android (Java/Kotlin), I specialize in creating seamless cross-platform experiences.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: const Color(0xFF4B5563), // gray-600 (bluish gray)
              height: 1.8,
            ),
          ).animate().fadeIn(duration: 600.ms).moveY(begin: 20, end: 0),
          const SizedBox(height: 24),
          Text(
            'My journey involves working on diverse projects ranging from enterprise CRMs to social networking platforms. I thrive on solving complex problems and optimizing performance to deliver robust solutions.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: const Color(0xFF4B5563), // gray-600
              height: 1.8,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).moveY(begin: 20, end: 0),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onNavigate});

  final Function(String) onNavigate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive font sizing logic
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth < 900;
        
        // Clamp font sizes
        final nameFontSize = (constraints.maxWidth * 0.08).clamp(40.0, 75.0);
        final titleFontSize = (constraints.maxWidth * 0.04).clamp(18.0, 24.0);
        final descFontSize = (constraints.maxWidth * 0.03).clamp(16.0, 18.0);

        return SizedBox(
          height: MediaQuery.of(context).size.height, // Full viewport height
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  // "Hi, I'm"
                  Text(
                    "Hi, I'm",
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937), // gray-800
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms).moveY(begin: 20, end: 0),
                  
                  const SizedBox(height: 8),

                  // "Meet Vaghela" Gradient Text
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                    ).createShader(bounds),
                    child: Text(
                      'Meet Vaghela',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.w800,
                        color: Colors.white, // Required for ShaderMask
                        height: 1.2,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 300.ms).moveY(begin: 20, end: 0),

                  const SizedBox(height: 26),

                  // Subtitle
                  Text(
                    'Flutter & Android Developer | Mobile App Specialist',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: titleFontSize,
                      color: const Color(0xFF4B5563), // gray-600
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 500.ms).moveY(begin: 20, end: 0),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'I build real-time, scalable, and cross-platform mobile experiences.\nFrom concept to deployment, I create solutions that blend performance with intuitive UI/UX.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: descFontSize,
                      color: const Color(0xFF6B7280), // gray-500
                      height: 1.6,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 700.ms).moveY(begin: 20, end: 0),

                  const SizedBox(height: 48),

                  // Buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _HeroButton(
                        label: 'View My Work',
                        onPressed: () => onNavigate('projects'),
                        isPrimary: true,
                      ),
                      _HeroButton(
                        label: 'Get In Touch',
                        onPressed: () => onNavigate('contact'),
                        isPrimary: false,
                      ),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 900.ms).moveY(begin: 20, end: 0),
                ],
              ),
            ),
          ),
          ),
        );
      },
    );
  }
}

class _HeroButton extends StatefulWidget {
  const _HeroButton({required this.label, required this.onPressed, required this.isPrimary});

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          width: 180, // Fixed width for consistency
          height: 54, // Fixed height for consistency
          child: widget.isPrimary
              ? ElevatedButton(
                  onPressed: widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: _isHovered ? 8 : 4,
                    backgroundColor: Colors.transparent,
                    shadowColor: const Color(0xFF133C55).withOpacity(0.3),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.label,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              : OutlinedButton(
                  onPressed: widget.onPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF133C55), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    backgroundColor: _isHovered ? const Color(0xFF133C55) : Colors.transparent,
                    foregroundColor: _isHovered ? Colors.white : const Color(0xFF133C55),
                    elevation: _isHovered ? 8 : 0,
                  ),
                  child: Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

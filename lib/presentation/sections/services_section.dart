import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/section_shell.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key, required this.onNavigate});

  final Function(String) onNavigate;

  static final _services = [
    _Service(
      title: 'Mobile App Development',
      description: 'Custom native and cross-platform mobile apps built with Flutter and Android.',
      features: [
        'Flutter & Dart',
        'Android Native (Java/Kotlin)',
        'Firebase & Push Notifications',
        'App Store & Play Store Publishing'
      ],
      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
      icon: LucideIcons.smartphone,
    ),
    _Service(
      title: 'Full-Stack Mobile Solutions',
      description: 'End-to-end mobile architecture, real-time database sync, and cloud integrations.',
      features: [
        'Firebase Integration (Realtime, Firestore)',
        'API Integration & Development',
        'Secure Data Storage with RoomDB',
        'App Performance Optimization'
      ],
      gradient: const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
      icon: LucideIcons.server,
    ),
    _Service(
      title: 'App Optimization & Security',
      description: 'Optimize existing apps for performance, load, and security.',
      features: [
        'Code Refactoring',
        'Caching & Lazy Loading',
        'Offline Access with Room',
        'Biometric Authentication'
      ],
      gradient: const LinearGradient(colors: [Color(0xFFA855F7), Color(0xFF9333EA)]),
      icon: LucideIcons.shield,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      title: 'Services',
      subtitle: 'Comprehensive mobile development solutions tailored to your business needs',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 1024;
          final crossAxisCount = isWide
              ? 3
              : constraints.maxWidth > 768
                  ? 2
                  : 1;

          return Column(
            children: [
              Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: _services
                    .map(
                      (service) => SizedBox(
                        width: constraints.maxWidth / crossAxisCount - (crossAxisCount == 1 ? 0 : 22),
                        child: _ServiceCard(service: service, index: _services.indexOf(service)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 64),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Ready to Start Your Project?',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Let\'s discuss how I can help bring your mobile app ideas to life with custom solutions.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => onNavigate('contact'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          child: Text(
                            'Get Started Today',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 700.ms).moveY(begin: 20, end: 0),
            ],
          );
        },
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  const _ServiceCard({required this.service, required this.index});
  final _Service service;
  final int index;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('service-card-${widget.index}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.05 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                  blurRadius: _isHovered ? 40 : 20,
                  offset: Offset(0, _isHovered ? 20 : 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Gradient
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isHovered ? 0.05 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: widget.service.gradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
                      transformAlignment: Alignment.center,
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: widget.service.gradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(widget.service.icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.service.title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: _isHovered ? const Color(0xFF133C55) : const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.service.description,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF4B5563),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...widget.service.features.map(
                      (feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
          .animate(key: ValueKey(_isVisible))
          .fadeIn(duration: 300.ms, delay: (widget.index * 80).ms, curve: Curves.easeOutCubic)
          .moveY(begin: 30, end: 0, duration: 300.ms, curve: Curves.easeOutCubic),
    );
  }
}

class _Service {
  const _Service({
    required this.title,
    required this.description,
    required this.features,
    required this.gradient,
    required this.icon,
  });

  final String title;
  final String description;
  final List<String> features;
  final LinearGradient gradient;
  final IconData icon;
}

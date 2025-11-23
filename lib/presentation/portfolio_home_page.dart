import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/hero_section.dart';
import 'sections/projects_section.dart';
import 'sections/services_section.dart';
import 'sections/skills_section.dart';
import 'widgets/animated_particles.dart';

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'home': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'services': GlobalKey(),
    'projects': GlobalKey(),
    'contact': GlobalKey(),
  };

  String _activeSection = 'home';
  bool _isScrolled = false;

  List<_NavItem> get _navItems => const [
        _NavItem(id: 'home', label: 'Home'),
        _NavItem(id: 'about', label: 'About'),
        _NavItem(id: 'skills', label: 'Skills'),
        _NavItem(id: 'services', label: 'Services'),
        _NavItem(id: 'projects', label: 'Projects'),
        _NavItem(id: 'contact', label: 'Contact'),
      ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    if (_isScrolled != offset > 50) {
      setState(() {
        _isScrolled = offset > 50;
      });
    }

    for (final item in _navItems) {
      final context = _sectionKeys[item.id]?.currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final position = box.localToGlobal(Offset.zero);
      // Adjusted threshold for better active state detection
      if (position.dy <= kToolbarHeight + 100 && position.dy + box.size.height > kToolbarHeight) {
        if (_activeSection != item.id) {
          setState(() {
            _activeSection = item.id;
          });
        }
        break;
      }
    }
  }

  void _scrollToSection(String id) {
    final targetContext = _sectionKeys[id]?.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFEEF6FF), // Updated to user's color
                  // Color(0xFFEEF6FF), // Updated to user's color
                ],
              ),
            ),
          ),
          const AnimatedParticlesBackground(),
          
          // Main Content
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero, // Removed padding to allow full width
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeroSection(
                        key: _sectionKeys['home'],
                        onNavigate: _scrollToSection,
                      ),
                      AboutSection(key: _sectionKeys['about']),
                      SkillsSection(key: _sectionKeys['skills']),
                      ServicesSection(
                        key: _sectionKeys['services'],
                        onNavigate: _scrollToSection,
                      ),
                      ProjectsSection(key: _sectionKeys['projects']),
                      ContactSection(
                        key: _sectionKeys['contact'],
                        onSubmit: (payload) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Thanks ${payload.name}, I\'ll respond soon!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      const _Footer(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Navigation Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _PortfolioNavigation(
              items: _navItems,
              activeSection: _activeSection,
              isScrolled: _isScrolled,
              onTap: _scrollToSection,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String id;
  final String label;
  const _NavItem({required this.id, required this.label});
}

class _PortfolioNavigation extends StatelessWidget {
  const _PortfolioNavigation({
    required this.items,
    required this.activeSection,
    required this.isScrolled,
    required this.onTap,
  });

  final List<_NavItem> items;
  final String activeSection;
  final bool isScrolled;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: isScrolled ? 10 : 0, sigmaY: isScrolled ? 10 : 0),
        child: Container(
          color: isScrolled ? Colors.white.withOpacity(0.1) : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 4 , horizontal: 24),
          child: SafeArea(
            bottom: false,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1152), // max-w-6xl
                child: Row(
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.center,
                  children: [
                    if (isMobile)
                       Expanded(
                         child: SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                           child: Row(
                             children: items.map((item) => _NavButton(
                               item: item,
                               isActive: activeSection == item.id,
                               onTap: () => onTap(item.id),
                             )).toList(),
                           ),
                         ),
                       )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: items.map((item) => _NavButton(
                          item: item,
                          isActive: activeSection == item.id,
                          onTap: () => onTap(item.id),
                        )).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFF133C55) : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111827), // gray-900
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152),
          child: Column(
            children: const [
              Text(
                '© 2025 Meet Vaghela. Built with passion using Flutter & Firebase.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9CA3AF)), // gray-400
              ),
            ],
          ),
        ),
      ),
    );
  }
}


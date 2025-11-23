import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/section_shell.dart';


class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  bool _isVisible = false;

  static final _projects = [
    _Project(
      title: 'Urja Sahayak CRM',
      description: 'Enterprise CRM with GPS tracking, barcode scanning, and custom canvas annotations.',
      image: 'https://play-lh.googleusercontent.com/tBcGKARULuYy69BhI5-gocyKqE9YOCVL7vPEGkoRVhdRFPKkxUj4xDLcv-3GLqunR1Y=w240-h480',
      technologies: ['Android', 'Firebase', 'Google Maps API'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.scriptmatrix.urjastrots',
      githubUrl: '',
      showPlayStore: true,
      showGithub: false,
    ),
    _Project(
      title: 'Matrix Convo',
      description: 'A real-time messaging app with quick replies, media compression, and optimized APIs.',
      image: 'https://play-lh.googleusercontent.com/fT1HcqMGmjzWCfE6KyC-MkVmrC9I_LITGg9GlKk0-3WIp7Q5RxEHCnLZkudmCCJjtCg=w240-h480',
      technologies: ['Android (Java)', 'Firebase', 'Room DB'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.scriptmatrix.matrixconvo',
      githubUrl: '',
      showPlayStore: true,
      showGithub: false,
    ),
    _Project(
      title: 'Solar Matrix CRM',
      description: 'A scalable CRM app built with Flutter, integrating push notifications and camera features.',
      image: 'https://play-lh.googleusercontent.com/g7DI8OroBfM660PsbXTK2sP6xaG5-PuZrh0WcifwEUj0_GVGVs6n7CJdQUUpNeyl8CSF=w240-h480',
      technologies: ['Flutter', 'Dart', 'Firebase', 'MLKit'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.scriptmatrix.solarmatrix',
      githubUrl: '',
      showPlayStore: true,
      showGithub: false,
    ),
    _Project(
      title: 'Zlerts',
      description: 'Secure messaging platform with fingerprint login and Firebase push notifications.',
      image: 'https://play-lh.googleusercontent.com/fT1HcqMGmjzWCfE6KyC-MkVmrC9I_LITGg9GlKk0-3WIp7Q5RxEHCnLZkudmCCJjtCg=w240-h480',
      technologies: ['Flutter', 'Firebase Notification', 'Biometric'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.scriptmatrix.matrixconvo',
      githubUrl: '',
      showPlayStore: true,
      showGithub: false,
    ),
    _Project(
      title: 'OwnBook',
      description: 'Collaborative real-time note-taking app with offline sync and audio/image support.',
      image: 'https://cdn-icons-png.flaticon.com/128/1302/1302002.png',
      technologies: ['Java', 'Firebase', 'RoomDB'],
      playStoreUrl: '',
      githubUrl: 'https://github.com/MeetVaghela1911/OwnBook',
      showPlayStore: false,
      showGithub: true,
    ),
    _Project(
      title: 'Zipcard',
      description: 'Cross-platform eCommerce app with cart/wishlist and in-app payments.',
      image: 'https://cdn-icons-png.flaticon.com/128/5033/5033286.png',
      technologies: ['Flutter', 'Firebase', 'Razorpay'],
      playStoreUrl: '',
      githubUrl: '#', // Placeholder GitHub URL
      showPlayStore: false,
      showGithub: true, // Enable GitHub link
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      title: 'Featured Projects',
      subtitle: null, // Remove subtitle
      backgroundColor: const Color(0xFFF8FAFC),
      child: VisibilityDetector(
        key: const Key('projects-section'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.05 && !_isVisible) {
            setState(() => _isVisible = true);
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 1024;
            final crossAxisCount = isWide
                ? 3
                : constraints.maxWidth > 768
                    ? 2
                    : 1;

            return Wrap(
              spacing: 32,
              runSpacing: 32,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: _projects
                  .map(
                    (project) {
                      final index = _projects.indexOf(project);
                      final rowIndex = index ~/ crossAxisCount; // Calculate which row this card is in
                      return SizedBox(
                        width: constraints.maxWidth / crossAxisCount - (crossAxisCount == 1 ? 0 : 22),
                        child: _ProjectCard(project: project, index: index, isVisible: _isVisible, rowIndex: rowIndex),
                      );
                    },
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project, required this.index, required this.isVisible, required this.rowIndex});
  final _Project project;
  final int index;
  final bool isVisible;
  final int rowIndex;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                blurRadius: _isHovered ? 30 : 20,
                offset: Offset(0, _isHovered ? 15 : 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Container with Overlay
              Stack(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: const Color(0xFFF9FAFB), // gray-50
                    padding: const EdgeInsets.all(16),
                    child: AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      child: Image.network(
                        widget.project.image,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(LucideIcons.image, size: 48, color: Color(0xFF9CA3AF)),
                          );
                        },
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF133C55).withOpacity(0.8),
                              const Color(0xFF386FA4).withOpacity(0.9),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.project.showPlayStore)
                                _OverlayButton(
                                  icon: LucideIcons.externalLink,
                                  label: 'View Live',
                                  onTap: () => launchUrl(Uri.parse(widget.project.playStoreUrl)),
                                ),
                              if (widget.project.showPlayStore && widget.project.showGithub)
                                const SizedBox(width: 16),
                              if (widget.project.showGithub)
                                _OverlayButton(
                                  icon: LucideIcons.github,
                                  label: 'Code',
                                  onTap: () => launchUrl(Uri.parse(widget.project.githubUrl)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.project.title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.project.description,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF4B5563),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.project.technologies
                          .map(
                            (tech) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF), // blue-50
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                tech,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF2563EB), // blue-600
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    if (widget.project.showPlayStore || widget.project.showGithub) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          if (widget.project.showPlayStore)
                            _LinkText(
                              icon: LucideIcons.play,
                              label: 'Play Store',
                              onTap: () => launchUrl(Uri.parse(widget.project.playStoreUrl)),
                            ),
                          if (widget.project.showPlayStore && widget.project.showGithub)
                            const SizedBox(width: 24),
                          if (widget.project.showGithub)
                            _LinkText(
                              icon: LucideIcons.github,
                              label: 'GitHub',
                              onTap: () => launchUrl(Uri.parse(widget.project.githubUrl)),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .animate(key: ValueKey(widget.isVisible))
          .fadeIn(duration: 500.ms, delay: (widget.rowIndex * 150).ms, curve: Curves.easeOutCubic)
          .moveY(begin: 30, end: 0, duration: 500.ms, curve: Curves.easeOutCubic),
    );
  }
}

class _OverlayButton extends StatefulWidget {
  const _OverlayButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_OverlayButton> createState() => _OverlayButtonState();
}

class _OverlayButtonState extends State<_OverlayButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Icon(widget.icon, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkText extends StatefulWidget {
  const _LinkText({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<_LinkText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: _isHovered ? const Color(0xFF386FA4) : const Color(0xFF133C55),
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isHovered ? const Color(0xFF386FA4) : const Color(0xFF133C55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Project {
  const _Project({
    required this.title,
    required this.description,
    required this.image,
    required this.technologies,
    required this.playStoreUrl,
    required this.githubUrl,
    required this.showPlayStore,
    required this.showGithub,
  });

  final String title;
  final String description;
  final String image;
  final List<String> technologies;
  final String playStoreUrl;
  final String githubUrl;
  final bool showPlayStore;
  final bool showGithub;
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/section_shell.dart';


class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  bool _isVisible = false;

  static final _skills = [
    _Skill('Flutter', LucideIcons.code),
    _Skill('Android', LucideIcons.smartphone),
    _Skill('iOS', LucideIcons.smartphone),
    _Skill('Firebase', LucideIcons.database),
    _Skill('Supabase', LucideIcons.server),
    _Skill('MySQL', LucideIcons.database),
    _Skill('GitHub', LucideIcons.github),
    _Skill('Figma', LucideIcons.figma),
    _Skill('Java', LucideIcons.code),
    _Skill('Dart', LucideIcons.globe),
    _Skill('Kotlin', LucideIcons.cpu),
    _Skill('Python', LucideIcons.zap),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      title: 'Skills & Technologies',
      subtitle: 'I use modern tools and frameworks to build user-centric, high-performance mobile applications',
      child: VisibilityDetector(
        key: const Key('skills-section'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.05 && !_isVisible) {
            setState(() => _isVisible = true);
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            // Grid logic: 2 cols on mobile, 3 on tablet, 4 on desktop
            final crossAxisCount = maxWidth < 600
                ? 2
                : maxWidth < 900
                    ? 3
                    : 4;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1,
              ),
              itemCount: _skills.length,
              itemBuilder: (context, index) {
                final skill = _skills[index];
                final rowIndex = index ~/ crossAxisCount; // Calculate which row this card is in
                return _SkillCard(skill: skill, index: index, isVisible: _isVisible, rowIndex: rowIndex);
              },
            );
          },
        ),
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  const _SkillCard({required this.skill, required this.index, required this.isVisible, required this.rowIndex});

  final _Skill skill;
  final int index;
  final bool isVisible;
  final int rowIndex;

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 10 : 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gradient Overlay on Hover
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isHovered ? 0.1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.skill.icon,
                    size: 48, // w-16 h-16 approx
                    color: const Color(0xFF133C55),
                  )
                      .animate(target: _isHovered ? 1 : 0)
                      .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
                  const SizedBox(height: 12),
                  Text(
                    widget.skill.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _isHovered ? const Color(0xFF133C55) : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate(key: ValueKey(widget.isVisible))
          .fadeIn(duration: 500.ms, delay: (widget.rowIndex * 150).ms, curve: Curves.easeOutCubic)
          .moveY(begin: 30, end: 0, duration: 500.ms, curve: Curves.easeOutCubic),
    );
  }
}

class _Skill {
  const _Skill(this.name, this.icon);
  final String name;
  final IconData icon;
}

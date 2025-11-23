import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedParticlesBackground extends StatefulWidget {
  const AnimatedParticlesBackground({super.key});

  @override
  State<AnimatedParticlesBackground> createState() => _AnimatedParticlesBackgroundState();
}

class _AnimatedParticlesBackgroundState extends State<AnimatedParticlesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      50, // Reduced from 50 for better performance
      (_) => _Particle(
        position: Offset(
          _random.nextDouble(),
          _random.nextDouble(),
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 0.0005, // Slower movement
          (_random.nextDouble() - 0.5) * 0.0005,
        ),
        size: _random.nextDouble() * 2.5 + 1.5,
        opacity: _random.nextDouble() * 0.3 + 0.2,
        color: _palette[_random.nextInt(_palette.length)],
      ),
    );

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..addListener(() {
        setState(() {
          _updateParticles();
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParticles() {
    for (final particle in _particles) {
      var dx = particle.position.dx + particle.velocity.dx;
      var dy = particle.position.dy + particle.velocity.dy;

      if (dx > 1) dx = 0;
      if (dx < 0) dx = 1;
      if (dy > 1) dy = 0;
      if (dy < 0) dy = 1;

      particle.position = Offset(dx, dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ParticlesPainter(particles: _particles),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  const _ParticlesPainter({required this.particles});

  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < particles.length; i++) {
      final particle = particles[i];
      final offset = Offset(particle.position.dx * size.width, particle.position.dy * size.height);

      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(offset, particle.size, paint);

      for (var j = i + 1; j < particles.length; j++) {
        final other = particles[j];
        final otherOffset = Offset(other.position.dx * size.width, other.position.dy * size.height);
        final distance = (offset - otherOffset).distance;
        if (distance < 120) { // Reduced from 160 for better performance
          final opacity = (1 - (distance / 120)) * 0.15;
          final linePaint = Paint()
            ..color = particle.color.withOpacity(opacity)
            ..strokeWidth = 1;
          canvas.drawLine(offset, otherOffset, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  _Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
    required this.color,
  });

  Offset position;
  Offset velocity;
  double size;
  double opacity;
  Color color;
}

const _palette = [
  Color(0xFF2563EB),
  Color(0xFF0EA5E9),
  Color(0xFF06B6D4),
  Color(0xFF3B82F6),
  Color(0xFF0284C7),
];


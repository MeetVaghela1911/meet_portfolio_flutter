import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/section_shell.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key, required this.onSubmit});

  final ValueChanged<ContactPayload> onSubmit;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Send data to Formspree API (same as React)
      final response = await http.post(
        Uri.parse('https://formspree.io/f/myzjlqbp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'subject': _subjectController.text.trim(),
          'message': _messageController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        // Success - clear form and show success screen
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
        });
      } else {
        // Error - show error message
        setState(() => _isSubmitting = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send message. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Network error
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error. Please check your connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    setState(() => _isSuccess = false);
  }

  @override
  Widget build(BuildContext context) {
    // Show success screen if form was submitted successfully
    if (_isSuccess) {
      return SectionShell(
        title: 'Thank You!',
        subtitle: 'Your message has been sent successfully. I\'ll get back to you soon!',
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _resetForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shadowColor: Colors.transparent,
                  elevation: 0,
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
                      'Send Another Message',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).scale(delay: 300.ms),
            ],
          ),
        ),
      );
    }

    // Show contact form
    return SectionShell(
      title: 'Get In Touch',
      subtitle: 'Let\'s turn your ideas into powerful mobile apps!',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 1024;
          return Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Form
              SizedBox(
                width: isWide ? constraints.maxWidth * 0.55 : constraints.maxWidth,
                child: _ContactForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  subjectController: _subjectController,
                  messageController: _messageController,
                  isSubmitting: _isSubmitting,
                  onSubmit: _handleSubmit,
                ),
              ).animate().fadeIn(duration: 600.ms).moveX(begin: -20, end: 0),
              
              SizedBox(height: isWide ? 0 : 48, width: isWide ? 48 : 0),
              
              // Contact Info
              SizedBox(
                width: isWide ? constraints.maxWidth * 0.4 : constraints.maxWidth,
                child: const _ContactInfo(),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms).moveX(begin: 20, end: 0),
            ],
          );
        },
      ),
    );
  }
}

class _ContactForm extends StatelessWidget {
  const _ContactForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.subjectController,
    required this.messageController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Me a Message',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF133C55),
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  children: [
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth,
                      child: _TextField(
                        label: 'Your Name',
                        hint: 'John Doe',
                        controller: nameController,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth,
                      child: _TextField(
                        label: 'Email Address',
                        hint: 'john@example.com',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) return 'Invalid email';
                          return null;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            _TextField(
              label: 'Subject',
              hint: 'Project Inquiry',
              controller: subjectController,
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _TextField(
              label: 'Message',
              hint: 'Tell me about your project...',
              controller: messageController,
              maxLines: 6,
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(LucideIcons.send, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Send Message',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  static final _contactItems = [
    _ContactItem(
      icon: LucideIcons.mail,
      label: 'Email',
      value: 'info.dev.meet@gmail.com',
      href: 'mailto:info.dev.meet@gmail.com',
    ),
    _ContactItem(
      icon: LucideIcons.mapPin,
      label: 'Location',
      value: 'Vadodara, Gujarat',
      href: 'https://linkedin.com/in/meet-vaghela-8ab3b7267',
    ),
  ];

  static final _socials = [
    _SocialItem(
      icon: LucideIcons.github,
      label: 'GitHub',
      url: 'https://github.com/MeetVaghela1911',
    ),
    _SocialItem(
      icon: LucideIcons.linkedin,
      label: 'LinkedIn',
      url: 'https://linkedin.com/in/meet-vaghela-8ab3b7267',
    ),
    _SocialItem(
      icon: LucideIcons.code,
      label: 'LeetCode',
      url: 'https://leetcode.com/u/MEET1911',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Items
        Column(
          children: _contactItems.map((item) => _ContactCard(item: item)).toList(),
        ),
        
        const SizedBox(height: 32),
        
        // Social Links
        Text(
          'Follow Me',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF133C55),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: _socials.map((social) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _SocialCard(social: social),
          )).toList(),
        ),

        const SizedBox(height: 32),

        // Availability
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Availability',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF133C55),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                   .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 1.seconds),
                  const SizedBox(width: 12),
                  Text(
                    'Available for new projects',
                    style: GoogleFonts.inter(color: const Color(0xFF4B5563)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'I typically respond within 24 hours',
                style: GoogleFonts.inter(color: const Color(0xFF6B7280), fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatefulWidget {
  const _ContactCard({required this.item});
  final _ContactItem item;

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.item.href)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 10 : 5),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.item.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.label,
                      style: GoogleFonts.inter(color: const Color(0xFF6B7280), fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: _isHovered 
                            ? [const Color(0xFF133C55), const Color(0xFF386FA4)]
                            : [const Color(0xFF1F2937), const Color(0xFF1F2937)],
                      ).createShader(bounds),
                      child: Text(
                        widget.item.value,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white, // Required for ShaderMask
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialCard extends StatefulWidget {
  const _SocialCard({required this.social});
  final _SocialItem social;

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.social.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
          width: 80,
          height: 50,
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 10 : 5),
              ),
            ],
          ),
          child: Icon(
            widget.social.icon,
            color: const Color(0xFF133C55),
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(color: const Color(0xFF1F2937)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF133C55), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class ContactPayload {
  ContactPayload({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  final String name;
  final String email;
  final String subject;
  final String message;
}

class _ContactItem {
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.href,
  });
  final IconData icon;
  final String label;
  final String value;
  final String href;
}

class _SocialItem {
  const _SocialItem({required this.icon, required this.label, required this.url});
  final IconData icon;
  final String label;
  final String url;
}


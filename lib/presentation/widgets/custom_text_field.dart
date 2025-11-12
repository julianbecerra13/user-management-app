import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

/// Widget reutilizable para campos de texto con diseño futurista
/// Implementa DRY - centraliza el estilo de campos de formulario
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label con gradiente
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            // Campo de texto con glassmorphism
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.darkCard.withOpacity(0.5),
                    AppTheme.darkSurface.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: _isFocused
                      ? AppTheme.primaryCyan.withOpacity(_glowAnimation.value)
                      : AppTheme.primaryCyan.withOpacity(0.2),
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryCyan
                              .withOpacity(_glowAnimation.value * 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppTheme.darkBackground.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() => _isFocused = hasFocus);
                    },
                    child: TextFormField(
                      controller: widget.controller,
                      validator: widget.validator,
                      keyboardType: widget.keyboardType,
                      readOnly: widget.readOnly,
                      onTap: widget.onTap,
                      maxLines: widget.maxLines,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          color: AppTheme.textHint.withOpacity(0.5),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: widget.prefixIcon != null
                            ? Padding(
                                padding: const EdgeInsets.all(12),
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      AppTheme.primaryGradient
                                          .createShader(bounds),
                                  child: widget.prefixIcon,
                                ),
                              )
                            : null,
                        suffixIcon: widget.suffixIcon != null
                            ? Padding(
                                padding: const EdgeInsets.all(12),
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      AppTheme.primaryGradient
                                          .createShader(bounds),
                                  child: widget.suffixIcon,
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        errorStyle: const TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      cursorColor: AppTheme.primaryCyan,
                      cursorWidth: 2,
                      cursorRadius: const Radius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

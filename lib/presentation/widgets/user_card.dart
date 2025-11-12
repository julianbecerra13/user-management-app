import 'dart:ui';
import 'package:flutter/material.dart';
import '../../data/models/user.dart';
import '../../core/constants/app_theme.dart';
import '../../core/utils/date_formatter.dart';

/// Widget reutilizable para mostrar una tarjeta de usuario con diseño futurista
/// Implementa DRY - evita duplicar código de UI
class UserCard extends StatefulWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UserCard({
    Key? key,
    required this.user,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: AppTheme.cardGradient,
            border: Border.all(
              color: _isPressed
                  ? AppTheme.primaryCyan.withOpacity(0.5)
                  : AppTheme.primaryCyan.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: _isPressed
                ? AppTheme.glowShadow(color: AppTheme.primaryCyan)
                : [
                    BoxShadow(
                      color: AppTheme.darkBackground.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.darkCard.withOpacity(0.3),
                      AppTheme.darkCard.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Avatar con gradiente
                        _buildAvatar(),
                        const SizedBox(width: 16),
                        // Información del usuario
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    AppTheme.primaryGradient.createShader(bounds),
                                child: Text(
                                  widget.user.fullName,
                                  style: AppTheme.heading2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.primaryCyan.withOpacity(0.2),
                                          AppTheme.primaryPurple.withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.primaryCyan.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '${widget.user.age} años',
                                      style: AppTheme.bodyTextSecondary.copyWith(
                                        color: AppTheme.accentPink, // Dorado
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.cake_outlined,
                                    size: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormatter.format(widget.user.birthDate),
                                    style: AppTheme.caption.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Botones de acción
                        if (widget.onEdit != null || widget.onDelete != null)
                          _buildActionMenu(),
                      ],
                    ),
                    // Información de direcciones
                    if (widget.user.addresses.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppTheme.primaryCyan.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryCyan.withOpacity(0.1),
                              AppTheme.primaryPurple.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryCyan.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppTheme.primaryGradient.createShader(bounds),
                              child: const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.user.addresses.length} ${widget.user.addresses.length == 1 ? "dirección" : "direcciones"} registrada${widget.user.addresses.length == 1 ? "" : "s"}',
                              style: AppTheme.bodyTextSecondary.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryCyan.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _getInitials(),
          style: const TextStyle(
            color: AppTheme.darkBackground,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildActionMenu() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.darkCard.withOpacity(0.5),
            AppTheme.darkCard.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryCyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: AppTheme.primaryCyan,
        ),
        color: AppTheme.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.primaryCyan.withOpacity(0.3),
          ),
        ),
        onSelected: (value) {
          if (value == 'edit' && widget.onEdit != null) {
            widget.onEdit!();
          } else if (value == 'delete' && widget.onDelete != null) {
            widget.onDelete!();
          }
        },
        itemBuilder: (context) => [
          if (widget.onEdit != null)
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.primaryGradient.createShader(bounds),
                    child: const Icon(Icons.edit_outlined,
                        size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Editar',
                    style: TextStyle(color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),
          if (widget.onDelete != null)
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Eliminar',
                    style: TextStyle(color: AppTheme.errorColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Obtiene las iniciales del nombre completo
  String _getInitials() {
    final names = widget.user.fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return widget.user.firstName[0].toUpperCase();
  }
}

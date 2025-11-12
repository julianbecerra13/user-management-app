import 'dart:ui';
import 'package:flutter/material.dart';
import '../../data/models/address.dart';
import '../../core/constants/app_theme.dart';

/// Widget reutilizable para mostrar una tarjeta de dirección con diseño futurista
/// Implementa DRY - evita duplicar código de UI
class AddressCard extends StatefulWidget {
  final Address address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    Key? key,
    required this.address,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppTheme.darkCard.withOpacity(0.6),
                AppTheme.darkSurface.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: _isHovered
                  ? AppTheme.primaryPurple.withOpacity(0.5)
                  : AppTheme.primaryCyan.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: _isHovered
                ? AppTheme.glowShadow(color: AppTheme.primaryPurple)
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
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Ícono de ubicación con gradiente
                    _buildLocationIcon(),
                    const SizedBox(width: 16),
                    // Información de la dirección
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dirección física (principal)
                          if (widget.address.streetAddress.isNotEmpty) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: 14,
                                  color: AppTheme.accentPink,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.address.streetAddress,
                                    style: AppTheme.heading2.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          // Ciudad con efecto shimmer
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                AppTheme.textPrimary,
                                AppTheme.primaryCyan,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              widget.address.city,
                              style: AppTheme.heading2.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Estado/Departamento
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppTheme.primaryGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryCyan.withOpacity(0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.address.state,
                                  style: AppTheme.bodyTextSecondary.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // País
                          Row(
                            children: [
                              Icon(
                                Icons.public,
                                size: 12,
                                color: AppTheme.textHint,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.address.country,
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.textHint,
                                  fontSize: 11,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple.withOpacity(0.3),
            AppTheme.primaryCyan.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.primaryPurple.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppTheme.primaryCyan,
              AppTheme.primaryPurple,
            ],
          ).createShader(bounds),
          child: const Icon(
            Icons.location_on_outlined,
            color: Colors.white,
            size: 28,
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.primaryPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: AppTheme.primaryPurple,
          size: 20,
        ),
        color: AppTheme.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.primaryPurple.withOpacity(0.3),
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
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
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
                    size: 18,
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
}

import 'package:flutter/material.dart';
import '../../data/models/user.dart';
import '../../core/constants/app_theme.dart';
import '../../core/utils/date_formatter.dart';

/// Widget reutilizable para mostrar una tarjeta de usuario
/// Implementa DRY - evita duplicar código de UI
class UserCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    radius: 24,
                    child: Text(
                      _getInitials(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Información del usuario
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: AppTheme.heading2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user.age} años',
                          style: AppTheme.bodyTextSecondary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nacimiento: ${DateFormatter.format(user.birthDate)}',
                          style: AppTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  // Botones de acción
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          onDelete!();
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Eliminar',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              // Información de direcciones
              if (user.addresses.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${user.addresses.length} ${user.addresses.length == 1 ? "dirección" : "direcciones"}',
                        style: AppTheme.bodyTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Obtiene las iniciales del nombre completo
  String _getInitials() {
    final names = user.fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return user.firstName[0].toUpperCase();
  }
}

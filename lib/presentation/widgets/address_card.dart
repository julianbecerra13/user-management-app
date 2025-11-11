import 'package:flutter/material.dart';
import '../../data/models/address.dart';
import '../../core/constants/app_theme.dart';

/// Widget reutilizable para mostrar una tarjeta de dirección
/// Implementa DRY - evita duplicar código de UI
class AddressCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ícono de ubicación
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Información de la dirección
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.city,
                    style: AppTheme.heading2.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.state,
                    style: AppTheme.bodyTextSecondary,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.country,
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
      ),
    );
  }
}

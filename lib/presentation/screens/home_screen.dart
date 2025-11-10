import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';
import '../providers/user_provider.dart';
import '../widgets/user_card.dart';
import '../widgets/empty_state.dart';
import 'user_form_screen.dart';
import 'address_management_screen.dart';

/// Pantalla principal - Lista de usuarios
/// Implementa KISS (Keep It Simple) - interfaz clara y directa
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar usuarios al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.homeTitle),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Mostrar indicador de carga
          if (userProvider.isLoading && !userProvider.hasUsers) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Mostrar error si existe
          if (userProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userProvider.error!,
                    style: AppTheme.bodyTextSecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => userProvider.loadUsers(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Mostrar estado vacío
          if (!userProvider.hasUsers) {
            return EmptyState(
              icon: Icons.people_outline,
              message: AppConstants.noUsersMessage,
              actionLabel: AppConstants.addUserTitle,
              onAction: () => _navigateToUserForm(context),
            );
          }

          // Mostrar lista de usuarios
          return RefreshIndicator(
            onRefresh: () => userProvider.loadUsers(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final user = userProvider.users[index];
                return UserCard(
                  user: user,
                  onTap: () => _navigateToAddresses(context, user.id),
                  onEdit: () => _navigateToUserForm(context, userId: user.id),
                  onDelete: () => _confirmDelete(context, user.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToUserForm(context),
        tooltip: AppConstants.addUserTitle,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Navega al formulario de usuario (crear o editar)
  void _navigateToUserForm(BuildContext context, {String? userId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserFormScreen(userId: userId),
      ),
    );
  }

  /// Navega a la pantalla de gestión de direcciones
  void _navigateToAddresses(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressManagementScreen(userId: userId),
      ),
    );
  }

  /// Confirma la eliminación de un usuario
  void _confirmDelete(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.deleteUserConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(context, userId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text(AppConstants.deleteButton),
          ),
        ],
      ),
    );
  }

  /// Elimina un usuario
  void _deleteUser(BuildContext context, String userId) async {
    final userProvider = context.read<UserProvider>();
    final success = await userProvider.deleteUser(userId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppConstants.userDeletedMessage),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
}

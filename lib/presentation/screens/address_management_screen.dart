import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/address.dart';
import '../../data/models/user.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';
import '../../core/utils/id_generator.dart';
import '../providers/user_provider.dart';
import '../widgets/address_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/location_picker.dart';
import '../widgets/custom_text_field.dart';

/// Pantalla de gestión de direcciones
/// Permite ver, agregar y eliminar direcciones de un usuario
class AddressManagementScreen extends StatefulWidget {
  final String userId;

  const AddressManagementScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final userProvider = context.read<UserProvider>();
    setState(() {
      _user = userProvider.getUserById(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.addressesTitle),
        ),
        body: const Center(
          child: Text('Usuario no encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${_user!.fullName} - ${AppConstants.addressesTitle}'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Actualizar usuario desde el provider
          _user = userProvider.getUserById(widget.userId);

          if (_user == null) {
            return const Center(
              child: Text('Usuario no encontrado'),
            );
          }

          // Mostrar estado vacío si no hay direcciones
          if (_user!.addresses.isEmpty) {
            return EmptyState(
              icon: Icons.location_off,
              message: AppConstants.noAddressesMessage,
              actionLabel: AppConstants.addAddressTitle,
              onAction: () => _showAddAddressDialog(context),
            );
          }

          // Mostrar lista de direcciones
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _user!.addresses.length,
            itemBuilder: (context, index) {
              final address = _user!.addresses[index];
              return AddressCard(
                address: address,
                onDelete: () => _confirmDeleteAddress(context, address.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(context),
        tooltip: AppConstants.addAddressTitle,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Muestra el diálogo para agregar dirección
  void _showAddAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddAddressDialog(userId: widget.userId),
    );
  }

  /// Confirma la eliminación de una dirección
  void _confirmDeleteAddress(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.deleteAddressConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppConstants.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAddress(context, addressId);
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

  /// Elimina una dirección
  void _deleteAddress(BuildContext context, String addressId) async {
    final userProvider = context.read<UserProvider>();
    final success =
        await userProvider.removeAddressFromUser(widget.userId, addressId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppConstants.addressDeletedMessage),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
}

/// Diálogo futurista para agregar dirección
class AddAddressDialog extends StatefulWidget {
  final String userId;

  const AddAddressDialog({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _streetAddressController = TextEditingController();
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  bool _isLoading = false;

  @override
  void dispose() {
    _streetAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              AppTheme.darkCard.withOpacity(0.95),
              AppTheme.darkSurface.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppTheme.primaryCyan.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: AppTheme.glowShadow(color: AppTheme.primaryCyan),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildHeader(),
                // Content
                Flexible(
                  child: _isLoading ? _buildLoadingState() : _buildForm(),
                ),
                // Actions
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient.scale(0.3),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryCyan.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: AppTheme.glowShadow(color: AppTheme.primaryCyan),
            ),
            child: const Icon(
              Icons.add_location_alt,
              size: 24,
              color: AppTheme.darkBackground,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.addAddressTitle,
                  style: AppTheme.heading2.copyWith(
                    fontSize: 18,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete la información de la dirección',
                  style: AppTheme.bodyTextSecondary.copyWith(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryCyan,
                ),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppTheme.primaryGradient.createShader(bounds),
              child: const Text(
                'Guardando dirección...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de dirección física
            CustomTextField(
              label: AppConstants.streetAddressLabel,
              hintText: 'Ej: Calle 123 #45-67, Apto 301',
              controller: _streetAddressController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingrese la dirección física';
                }
                if (value.trim().length < 5) {
                  return 'La dirección debe tener al menos 5 caracteres';
                }
                return null;
              },
              prefixIcon: const Icon(Icons.home_outlined),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Divisor con texto
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.primaryCyan.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.primaryGradient.createShader(bounds),
                    child: const Text(
                      'Ubicación geográfica',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryCyan.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Selector de país, estado y ciudad
            LocationPicker(
              onCountryChanged: (country) {
                setState(() {
                  _selectedCountry = country;
                });
              },
              onStateChanged: (state) {
                setState(() {
                  _selectedState = state;
                });
              },
              onCityChanged: (city) {
                setState(() {
                  _selectedCity = city;
                });
              },
              countryLabel: AppConstants.countryLabel,
              stateLabel: AppConstants.stateLabel,
              cityLabel: AppConstants.cityLabel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryCyan.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botón Cancelar
          Flexible(
            child: Container(
              constraints: const BoxConstraints(minWidth: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.darkCard.withOpacity(0.5),
                    AppTheme.darkSurface.withOpacity(0.5),
                  ],
                ),
                border: Border.all(
                  color: AppTheme.primaryCyan.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading ? null : () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Text(
                      AppConstants.cancelButton,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isLoading
                            ? AppTheme.textHint
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Botón Guardar
          Flexible(
            child: Container(
              constraints: const BoxConstraints(minWidth: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _isLoading
                    ? LinearGradient(
                        colors: [
                          AppTheme.primaryCyan.withOpacity(0.5),
                          AppTheme.primaryPurple.withOpacity(0.5),
                        ],
                      )
                    : AppTheme.primaryGradient,
                boxShadow: _isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: AppTheme.primaryCyan.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading ? null : _saveAddress,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save_outlined,
                          color: AppTheme.darkBackground,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            AppConstants.saveButton.toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.darkBackground,
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Guarda la dirección
  Future<void> _saveAddress() async {
    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar que se hayan seleccionado todos los campos de ubicación
    if (_selectedCountry == null ||
        _selectedCountry!.isEmpty ||
        _selectedState == null ||
        _selectedState!.isEmpty ||
        _selectedCity == null ||
        _selectedCity!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child:
                    Text('Por favor complete todos los campos de ubicación'),
              ),
            ],
          ),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = context.read<UserProvider>();

      // Crear nueva dirección con dirección física
      final address = Address(
        id: IdGenerator.generateAddressId(),
        country: _selectedCountry!,
        state: _selectedState!,
        city: _selectedCity!,
        streetAddress: _streetAddressController.text.trim(),
      );

      final success =
          await userProvider.addAddressToUser(widget.userId, address);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(AppConstants.addressSavedMessage),
                ),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

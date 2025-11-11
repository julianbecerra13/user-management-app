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

/// Diálogo para agregar dirección
class AddAddressDialog extends StatefulWidget {
  final String userId;

  const AddAddressDialog({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppConstants.addAddressTitle),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
            ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text(AppConstants.cancelButton),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveAddress,
          child: const Text(AppConstants.saveButton),
        ),
      ],
    );
  }

  /// Guarda la dirección
  Future<void> _saveAddress() async {
    // Validar que se hayan seleccionado todos los campos
    if (_selectedCountry == null ||
        _selectedCountry!.isEmpty ||
        _selectedState == null ||
        _selectedState!.isEmpty ||
        _selectedCity == null ||
        _selectedCity!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = context.read<UserProvider>();

      // Crear nueva dirección
      final address = Address(
        id: IdGenerator.generateAddressId(),
        country: _selectedCountry!,
        state: _selectedState!,
        city: _selectedCity!,
      );

      final success =
          await userProvider.addAddressToUser(widget.userId, address);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.addressSavedMessage),
            backgroundColor: AppTheme.successColor,
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

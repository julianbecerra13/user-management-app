import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/user.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/id_generator.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_text_field.dart';

/// Pantalla de formulario de usuario
/// Permite crear y editar usuarios
class UserFormScreen extends StatefulWidget {
  final String? userId;

  const UserFormScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  bool get _isEditing => widget.userId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadUserData();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  /// Carga los datos del usuario para edición
  void _loadUserData() {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.getUserById(widget.userId!);

    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _selectedDate = user.birthDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? AppConstants.editUserTitle : AppConstants.addUserTitle,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Campo de nombre
                    CustomTextField(
                      label: AppConstants.nameLabel,
                      hintText: 'Ingrese su nombre',
                      controller: _firstNameController,
                      validator: Validators.validateName,
                      prefixIcon: const Icon(Icons.person),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),

                    // Campo de apellido
                    CustomTextField(
                      label: AppConstants.lastNameLabel,
                      hintText: 'Ingrese su apellido',
                      controller: _lastNameController,
                      validator: Validators.validateLastName,
                      prefixIcon: const Icon(Icons.person_outline),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),

                    // Campo de fecha de nacimiento
                    CustomTextField(
                      label: AppConstants.birthDateLabel,
                      hintText: 'Seleccione su fecha de nacimiento',
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? DateFormatter.format(_selectedDate!)
                            : '',
                      ),
                      validator: (_) =>
                          Validators.validateBirthDate(_selectedDate),
                      prefixIcon: const Icon(Icons.calendar_today),
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 32),

                    // Botón de guardar
                    ElevatedButton(
                      onPressed: _saveUser,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        AppConstants.saveButton,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Muestra el selector de fecha
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateFormatter.yearsAgo(18),
      firstDate: DateFormatter.yearsAgo(AppConstants.maxAge),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Guarda el usuario
  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = context.read<UserProvider>();

      // Crear o actualizar usuario
      User user;
      if (_isEditing) {
        // Editar usuario existente
        final existingUser = userProvider.getUserById(widget.userId!);
        user = existingUser!.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          birthDate: _selectedDate!,
        );
      } else {
        // Crear nuevo usuario
        user = User(
          id: IdGenerator.generateUserId(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          birthDate: _selectedDate!,
        );
      }

      final success = await userProvider.saveUser(user);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.userSavedMessage),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
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

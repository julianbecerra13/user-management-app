import 'dart:ui';
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
import '../widgets/futuristic_date_picker.dart';

/// Pantalla de formulario de usuario con diseño futurista
/// Permite crear y editar usuarios
class UserFormScreen extends StatefulWidget {
  final String? userId;

  const UserFormScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool get _isEditing => widget.userId != null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    if (_isEditing) {
      _loadUserData();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _animationController.dispose();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            _isEditing
                ? AppConstants.editUserTitle
                : AppConstants.addUserTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: IconButton(
          icon: ShaderMask(
            shaderCallback: (bounds) =>
                AppTheme.primaryGradient.createShader(bounds),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.darkCard.withOpacity(0.8),
                AppTheme.darkSurface.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.darkCard.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        'Guardando...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 120, 24, 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header con icono
                        _buildHeader(),
                        const SizedBox(height: 32),

                        // Contenedor del formulario
                        Container(
                          decoration: AppTheme.glassmorphism(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    // Campo de nombre
                                    CustomTextField(
                                      label: AppConstants.nameLabel,
                                      hintText: 'Ej: Juan',
                                      controller: _firstNameController,
                                      validator: Validators.validateName,
                                      prefixIcon:
                                          const Icon(Icons.person_outline),
                                      keyboardType: TextInputType.name,
                                    ),
                                    const SizedBox(height: 20),

                                    // Campo de apellido
                                    CustomTextField(
                                      label: AppConstants.lastNameLabel,
                                      hintText: 'Ej: Pérez',
                                      controller: _lastNameController,
                                      validator: Validators.validateLastName,
                                      prefixIcon:
                                          const Icon(Icons.badge_outlined),
                                      keyboardType: TextInputType.name,
                                    ),
                                    const SizedBox(height: 20),

                                    // Campo de fecha de nacimiento
                                    CustomTextField(
                                      label: AppConstants.birthDateLabel,
                                      hintText: 'Seleccione su fecha',
                                      controller: TextEditingController(
                                        text: _selectedDate != null
                                            ? DateFormatter.format(
                                                _selectedDate!)
                                            : '',
                                      ),
                                      validator: (_) =>
                                          Validators.validateBirthDate(
                                              _selectedDate),
                                      prefixIcon: const Icon(
                                          Icons.calendar_today_outlined),
                                      readOnly: true,
                                      onTap: _selectDate,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Botón de guardar
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            boxShadow: AppTheme.glowShadow(color: AppTheme.primaryCyan),
          ),
          child: const Icon(
            Icons.person_add_alt_1,
            size: 50,
            color: AppTheme.darkBackground,
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            _isEditing ? 'Editar Información' : 'Nuevo Usuario',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isEditing
              ? 'Actualiza los datos del usuario'
              : 'Completa el formulario con los datos',
          style: AppTheme.bodyTextSecondary.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryCyan.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _saveUser,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.save_outlined,
                  color: AppTheme.darkBackground,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.saveButton.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.darkBackground,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Muestra el selector de fecha futurista
  Future<void> _selectDate() async {
    final DateTime? picked = await FuturisticDatePicker.show(
      context: context,
      initialDate: _selectedDate ?? DateFormatter.yearsAgo(18),
      firstDate: DateFormatter.yearsAgo(AppConstants.maxAge),
      lastDate: DateTime.now(),
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
        _showSuccessSnackBar();
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppTheme.darkBackground,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '¡Éxito!',
                      style: AppTheme.bodyText.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppConstants.userSavedMessage,
                      style: AppTheme.bodyTextSecondary.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppTheme.darkCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.successColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

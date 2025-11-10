import '../constants/app_constants.dart';

/// Clase de validadores reutilizables
/// Implementa DRY (Don't Repeat Yourself) centralizando la lógica de validación
class Validators {
  // Prevenir instanciación
  Validators._();

  /// Valida que un campo no esté vacío
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName ${AppConstants.requiredFieldMessage.toLowerCase()}'
          : AppConstants.requiredFieldMessage;
    }
    return null;
  }

  /// Valida el nombre
  static String? validateName(String? value) {
    final requiredError = required(value, fieldName: AppConstants.nameLabel);
    if (requiredError != null) return requiredError;

    final trimmed = value!.trim();
    if (trimmed.length < AppConstants.minNameLength ||
        trimmed.length > AppConstants.maxNameLength) {
      return AppConstants.invalidNameMessage;
    }

    // Solo letras y espacios
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(trimmed)) {
      return AppConstants.invalidNameMessage;
    }

    return null;
  }

  /// Valida el apellido
  static String? validateLastName(String? value) {
    final requiredError =
        required(value, fieldName: AppConstants.lastNameLabel);
    if (requiredError != null) return requiredError;

    final trimmed = value!.trim();
    if (trimmed.length < AppConstants.minNameLength ||
        trimmed.length > AppConstants.maxNameLength) {
      return AppConstants.invalidLastNameMessage;
    }

    // Solo letras y espacios
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(trimmed)) {
      return AppConstants.invalidLastNameMessage;
    }

    return null;
  }

  /// Valida la fecha de nacimiento
  static String? validateBirthDate(DateTime? value) {
    if (value == null) {
      return AppConstants.requiredFieldMessage;
    }

    // No puede ser fecha futura
    if (value.isAfter(DateTime.now())) {
      return AppConstants.futureDateMessage;
    }

    // Calcular edad
    final now = DateTime.now();
    int age = now.year - value.year;
    if (now.month < value.month ||
        (now.month == value.month && now.day < value.day)) {
      age--;
    }

    // Validar rango de edad
    if (age < AppConstants.minAge || age > AppConstants.maxAge) {
      return AppConstants.invalidAgeMessage;
    }

    return null;
  }

  /// Valida que se haya seleccionado un país
  static String? validateCountry(String? value) {
    return required(value, fieldName: AppConstants.countryLabel);
  }

  /// Valida que se haya seleccionado un departamento
  static String? validateState(String? value) {
    return required(value, fieldName: AppConstants.stateLabel);
  }

  /// Valida que se haya seleccionado un municipio
  static String? validateCity(String? value) {
    return required(value, fieldName: AppConstants.cityLabel);
  }
}

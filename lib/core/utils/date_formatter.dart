import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Utilidades para formateo de fechas
/// Centraliza la lógica de formateo (DRY)
class DateFormatter {
  // Prevenir instanciación
  DateFormatter._();

  static final DateFormat _formatter =
      DateFormat(AppConstants.dateFormat, 'es');

  /// Formatea una fecha a string
  static String format(DateTime date) {
    return _formatter.format(date);
  }

  /// Parsea un string a fecha
  static DateTime? parse(String dateString) {
    try {
      return _formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Calcula la edad a partir de una fecha de nacimiento
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Retorna la fecha actual
  static DateTime get now => DateTime.now();

  /// Retorna la fecha de hace X años
  static DateTime yearsAgo(int years) {
    return DateTime.now().subtract(Duration(days: years * 365));
  }
}

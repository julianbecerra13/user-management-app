/// Generador de IDs únicos
/// Centraliza la generación de identificadores (DRY)
class IdGenerator {
  // Prevenir instanciación
  IdGenerator._();

  /// Genera un ID único basado en timestamp y un valor aleatorio
  static String generate() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000).toString();
    return '$timestamp-$random';
  }

  /// Genera un ID para usuario
  static String generateUserId() {
    return 'user_${generate()}';
  }

  /// Genera un ID para dirección
  static String generateAddressId() {
    return 'addr_${generate()}';
  }
}

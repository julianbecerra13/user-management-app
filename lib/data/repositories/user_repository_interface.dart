import '../models/user.dart';

/// Interface del repositorio de usuarios
/// Implementa SOLID: Dependency Inversion Principle
/// La capa de presentación depende de abstracciones, no de implementaciones concretas
abstract class IUserRepository {
  /// Obtiene todos los usuarios
  Future<List<User>> getAllUsers();

  /// Obtiene un usuario por ID
  Future<User?> getUserById(String id);

  /// Guarda un usuario (crear o actualizar)
  Future<void> saveUser(User user);

  /// Elimina un usuario
  Future<void> deleteUser(String id);

  /// Verifica si existe un usuario con el ID dado
  Future<bool> userExists(String id);
}

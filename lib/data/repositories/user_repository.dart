import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../../core/constants/app_constants.dart';
import 'user_repository_interface.dart';

/// Implementación del repositorio de usuarios usando SharedPreferences
/// Implementa SOLID: Single Responsibility - solo maneja persistencia de usuarios
class UserRepository implements IUserRepository {
  final SharedPreferences _prefs;

  UserRepository(this._prefs);

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final usersJson = _prefs.getString(AppConstants.usersStorageKey);
      if (usersJson == null || usersJson.isEmpty) {
        return [];
      }

      final List<dynamic> usersList = jsonDecode(usersJson);
      return usersList
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // En caso de error, retornar lista vacía
      return [];
    }
  }

  @override
  Future<User?> getUserById(String id) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    final users = await getAllUsers();

    // Verificar si el usuario ya existe
    final index = users.indexWhere((u) => u.id == user.id);

    if (index != -1) {
      // Actualizar usuario existente
      users[index] = user;
    } else {
      // Agregar nuevo usuario
      users.add(user);
    }

    // Guardar en SharedPreferences
    final usersJson = jsonEncode(users.map((u) => u.toJson()).toList());
    await _prefs.setString(AppConstants.usersStorageKey, usersJson);
  }

  @override
  Future<void> deleteUser(String id) async {
    final users = await getAllUsers();
    users.removeWhere((user) => user.id == id);

    // Guardar cambios
    final usersJson = jsonEncode(users.map((u) => u.toJson()).toList());
    await _prefs.setString(AppConstants.usersStorageKey, usersJson);
  }

  @override
  Future<bool> userExists(String id) async {
    final user = await getUserById(id);
    return user != null;
  }
}

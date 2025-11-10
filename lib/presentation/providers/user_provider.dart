import 'package:flutter/foundation.dart';
import '../../data/models/user.dart';
import '../../data/models/address.dart';
import '../../data/repositories/user_repository_interface.dart';

/// Provider para gestión de usuarios
/// Implementa SOLID: Single Responsibility - solo maneja el estado de usuarios
class UserProvider with ChangeNotifier {
  final IUserRepository _repository;

  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  UserProvider(this._repository);

  // Getters
  List<User> get users => List.unmodifiable(_users);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUsers => _users.isNotEmpty;

  /// Carga todos los usuarios
  Future<void> loadUsers() async {
    _setLoading(true);
    _clearError();

    try {
      _users = await _repository.getAllUsers();
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar usuarios: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene un usuario por ID
  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Agrega o actualiza un usuario
  Future<bool> saveUser(User user) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.saveUser(user);

      // Actualizar la lista local
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
      } else {
        _users.add(user);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al guardar usuario: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina un usuario
  Future<bool> deleteUser(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al eliminar usuario: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Agrega una dirección a un usuario
  Future<bool> addAddressToUser(String userId, Address address) async {
    final user = getUserById(userId);
    if (user == null) {
      _setError('Usuario no encontrado');
      return false;
    }

    final updatedUser = user.addAddress(address);
    return await saveUser(updatedUser);
  }

  /// Elimina una dirección de un usuario
  Future<bool> removeAddressFromUser(String userId, String addressId) async {
    final user = getUserById(userId);
    if (user == null) {
      _setError('Usuario no encontrado');
      return false;
    }

    final updatedUser = user.removeAddress(addressId);
    return await saveUser(updatedUser);
  }

  /// Actualiza una dirección de un usuario
  Future<bool> updateUserAddress(String userId, Address address) async {
    final user = getUserById(userId);
    if (user == null) {
      _setError('Usuario no encontrado');
      return false;
    }

    final updatedUser = user.updateAddress(address);
    return await saveUser(updatedUser);
  }

  // Métodos privados para manejo de estado
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}

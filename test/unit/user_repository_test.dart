import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management_app/data/models/user.dart';
import 'package:user_management_app/data/models/address.dart';
import 'package:user_management_app/data/repositories/user_repository.dart';

void main() {
  group('UserRepository Tests', () {
    late UserRepository repository;

    setUp(() async {
      // Configurar SharedPreferences con valores iniciales vacíos
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repository = UserRepository(prefs);
    });

    test('getAllUsers debe retornar lista vacía inicialmente', () async {
      final users = await repository.getAllUsers();
      expect(users, isEmpty);
    });

    test('saveUser debe guardar un nuevo usuario', () async {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      await repository.saveUser(user);
      final users = await repository.getAllUsers();

      expect(users.length, 1);
      expect(users.first.id, '1');
      expect(users.first.firstName, 'Juan');
    });

    test('saveUser debe actualizar usuario existente', () async {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      await repository.saveUser(user);

      final updatedUser = user.copyWith(firstName: 'Carlos');
      await repository.saveUser(updatedUser);

      final users = await repository.getAllUsers();
      expect(users.length, 1);
      expect(users.first.firstName, 'Carlos');
    });

    test('getUserById debe retornar usuario correcto', () async {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      await repository.saveUser(user);
      final foundUser = await repository.getUserById('1');

      expect(foundUser, isNotNull);
      expect(foundUser!.id, '1');
      expect(foundUser.firstName, 'Juan');
    });

    test('getUserById debe retornar null si no existe', () async {
      final foundUser = await repository.getUserById('999');
      expect(foundUser, isNull);
    });

    test('deleteUser debe eliminar usuario correctamente', () async {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      await repository.saveUser(user);
      await repository.deleteUser('1');

      final users = await repository.getAllUsers();
      expect(users, isEmpty);
    });

    test('userExists debe retornar true si usuario existe', () async {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      await repository.saveUser(user);
      final exists = await repository.userExists('1');

      expect(exists, isTrue);
    });

    test('userExists debe retornar false si usuario no existe', () async {
      final exists = await repository.userExists('999');
      expect(exists, isFalse);
    });

    test('debe guardar usuario con direcciones', () async {
      final address = Address(
        id: 'addr_1',
        country: 'Colombia',
        state: 'Antioquia',
        city: 'Medellín',
      );

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [address],
      );

      await repository.saveUser(user);
      final users = await repository.getAllUsers();

      expect(users.length, 1);
      expect(users.first.addresses.length, 1);
      expect(users.first.addresses.first.city, 'Medellín');
    });
  });
}

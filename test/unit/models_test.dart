import 'package:flutter_test/flutter_test.dart';
import 'package:user_management_app/data/models/address.dart';
import 'package:user_management_app/data/models/user.dart';

void main() {
  group('Address Model Tests', () {
    test('Address debe crearse correctamente', () {
      final address = Address(
        id: '1',
        country: 'Colombia',
        state: 'Antioquia',
        city: 'Medellín',
      );

      expect(address.id, '1');
      expect(address.country, 'Colombia');
      expect(address.state, 'Antioquia');
      expect(address.city, 'Medellín');
    });

    test('Address toJson debe retornar Map correcto', () {
      final address = Address(
        id: '1',
        country: 'Colombia',
        state: 'Antioquia',
        city: 'Medellín',
      );

      final json = address.toJson();

      expect(json['id'], '1');
      expect(json['country'], 'Colombia');
      expect(json['state'], 'Antioquia');
      expect(json['city'], 'Medellín');
    });

    test('Address fromJson debe crear instancia correcta', () {
      final json = {
        'id': '1',
        'country': 'Colombia',
        'state': 'Antioquia',
        'city': 'Medellín',
      };

      final address = Address.fromJson(json);

      expect(address.id, '1');
      expect(address.country, 'Colombia');
      expect(address.state, 'Antioquia');
      expect(address.city, 'Medellín');
    });

    test('Address fullAddress debe retornar dirección completa', () {
      final address = Address(
        id: '1',
        country: 'Colombia',
        state: 'Antioquia',
        city: 'Medellín',
      );

      expect(address.fullAddress, 'Medellín, Antioquia, Colombia');
    });

    test('Address copyWith debe crear nueva instancia con valores actualizados',
        () {
      final address = Address(
        id: '1',
        country: 'Colombia',
        state: 'Antioquia',
        city: 'Medellín',
      );

      final updated = address.copyWith(city: 'Bogotá', state: 'Cundinamarca');

      expect(updated.id, '1');
      expect(updated.country, 'Colombia');
      expect(updated.state, 'Cundinamarca');
      expect(updated.city, 'Bogotá');
    });
  });

  group('User Model Tests', () {
    test('User debe crearse correctamente', () {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      expect(user.id, '1');
      expect(user.firstName, 'Juan');
      expect(user.lastName, 'Pérez');
      expect(user.birthDate, DateTime(1990, 1, 1));
      expect(user.addresses, isEmpty);
    });

    test('User fullName debe retornar nombre completo', () {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      expect(user.fullName, 'Juan Pérez');
    });

    test('User age debe calcular edad correctamente', () {
      final birthDate = DateTime.now().subtract(const Duration(days: 365 * 25));
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: birthDate,
      );

      expect(user.age, 25);
    });

    test('User toJson debe retornar Map correcto', () {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['firstName'], 'Juan');
      expect(json['lastName'], 'Pérez');
      expect(json['birthDate'], '1990-01-01T00:00:00.000');
      expect(json['addresses'], isEmpty);
    });

    test('User fromJson debe crear instancia correcta', () {
      final json = {
        'id': '1',
        'firstName': 'Juan',
        'lastName': 'Pérez',
        'birthDate': '1990-01-01T00:00:00.000',
        'addresses': [],
      };

      final user = User.fromJson(json);

      expect(user.id, '1');
      expect(user.firstName, 'Juan');
      expect(user.lastName, 'Pérez');
      expect(user.birthDate, DateTime(1990, 1, 1));
    });

    test('User addAddress debe agregar dirección correctamente', () {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      final address = Address(
        id: 'addr_1',
        country: 'Colombia',
        state: 'Antioquia',
        city: 'Medellín',
      );

      final updatedUser = user.addAddress(address);

      expect(updatedUser.addresses.length, 1);
      expect(updatedUser.addresses.first, address);
    });

    test('User removeAddress debe eliminar dirección correctamente', () {
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

      final updatedUser = user.removeAddress('addr_1');

      expect(updatedUser.addresses, isEmpty);
    });

    test('User updateAddress debe actualizar dirección correctamente', () {
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

      final updatedAddress = address.copyWith(city: 'Bogotá');
      final updatedUser = user.updateAddress(updatedAddress);

      expect(updatedUser.addresses.length, 1);
      expect(updatedUser.addresses.first.city, 'Bogotá');
    });
  });
}

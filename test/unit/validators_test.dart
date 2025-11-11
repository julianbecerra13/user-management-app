import 'package:flutter_test/flutter_test.dart';
import 'package:user_management_app/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('required', () {
      test('debe retornar error cuando el valor es null', () {
        final result = Validators.required(null);
        expect(result, isNotNull);
      });

      test('debe retornar error cuando el valor está vacío', () {
        final result = Validators.required('');
        expect(result, isNotNull);
      });

      test('debe retornar error cuando el valor solo tiene espacios', () {
        final result = Validators.required('   ');
        expect(result, isNotNull);
      });

      test('debe retornar null cuando el valor es válido', () {
        final result = Validators.required('valor válido');
        expect(result, isNull);
      });
    });

    group('validateName', () {
      test('debe retornar error cuando el nombre es null', () {
        final result = Validators.validateName(null);
        expect(result, isNotNull);
      });

      test('debe retornar error cuando el nombre es muy corto', () {
        final result = Validators.validateName('A');
        expect(result, isNotNull);
      });

      test('debe retornar error cuando el nombre tiene números', () {
        final result = Validators.validateName('Juan123');
        expect(result, isNotNull);
      });

      test('debe retornar error cuando el nombre tiene caracteres especiales',
          () {
        final result = Validators.validateName('Juan@');
        expect(result, isNotNull);
      });

      test('debe retornar null cuando el nombre es válido', () {
        final result = Validators.validateName('Juan');
        expect(result, isNull);
      });

      test('debe retornar null cuando el nombre tiene tildes', () {
        final result = Validators.validateName('José María');
        expect(result, isNull);
      });

      test('debe retornar null cuando el nombre tiene ñ', () {
        final result = Validators.validateName('Niño');
        expect(result, isNull);
      });
    });

    group('validateLastName', () {
      test('debe retornar error cuando el apellido es null', () {
        final result = Validators.validateLastName(null);
        expect(result, isNotNull);
      });

      test('debe retornar error cuando el apellido es muy corto', () {
        final result = Validators.validateLastName('P');
        expect(result, isNotNull);
      });

      test('debe retornar error cuando el apellido tiene números', () {
        final result = Validators.validateLastName('Pérez123');
        expect(result, isNotNull);
      });

      test('debe retornar null cuando el apellido es válido', () {
        final result = Validators.validateLastName('Pérez');
        expect(result, isNull);
      });
    });

    group('validateBirthDate', () {
      test('debe retornar error cuando la fecha es null', () {
        final result = Validators.validateBirthDate(null);
        expect(result, isNotNull);
      });

      test('debe retornar error cuando la fecha es futura', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        final result = Validators.validateBirthDate(futureDate);
        expect(result, isNotNull);
      });

      test('debe retornar error cuando la edad es inválida (muy viejo)', () {
        // Crear una fecha hace 151 años exactos
        final now = DateTime.now();
        final oldDate = DateTime(now.year - 151, now.month, now.day);
        final result = Validators.validateBirthDate(oldDate);
        expect(result, isNotNull);
      });

      test('debe retornar null cuando la fecha es válida', () {
        final validDate = DateTime.now().subtract(const Duration(days: 365 * 25));
        final result = Validators.validateBirthDate(validDate);
        expect(result, isNull);
      });
    });

    group('validateCountry', () {
      test('debe retornar error cuando el país es null', () {
        final result = Validators.validateCountry(null);
        expect(result, isNotNull);
      });

      test('debe retornar error cuando el país está vacío', () {
        final result = Validators.validateCountry('');
        expect(result, isNotNull);
      });

      test('debe retornar null cuando el país es válido', () {
        final result = Validators.validateCountry('Colombia');
        expect(result, isNull);
      });
    });

    group('validateState', () {
      test('debe retornar error cuando el departamento es null', () {
        final result = Validators.validateState(null);
        expect(result, isNotNull);
      });

      test('debe retornar null cuando el departamento es válido', () {
        final result = Validators.validateState('Antioquia');
        expect(result, isNull);
      });
    });

    group('validateCity', () {
      test('debe retornar error cuando el municipio es null', () {
        final result = Validators.validateCity(null);
        expect(result, isNotNull);
      });

      test('debe retornar null cuando el municipio es válido', () {
        final result = Validators.validateCity('Medellín');
        expect(result, isNull);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:user_management_app/data/models/user.dart';
import 'package:user_management_app/data/models/address.dart';
import 'package:user_management_app/presentation/widgets/user_card.dart';

void main() {
  // Inicializar locale data para los tests
  setUpAll(() async {
    await initializeDateFormatting('es_ES', null);
  });
  group('UserCard Widget Tests', () {
    testWidgets('debe mostrar información del usuario correctamente',
        (WidgetTester tester) async {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserCard(user: user),
          ),
        ),
      );

      // Verificar que se muestra el nombre completo
      expect(find.text('Juan Pérez'), findsOneWidget);
      // Verificar que se muestra la edad
      expect(find.textContaining('años'), findsOneWidget);
      // Verificar que se muestra la fecha de nacimiento
      expect(find.text('01/01/1990'), findsOneWidget);
    });

    testWidgets('debe mostrar iniciales del usuario en el avatar',
        (WidgetTester tester) async {
      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserCard(user: user),
          ),
        ),
      );

      expect(find.text('JP'), findsOneWidget);
    });

    testWidgets('debe mostrar información de direcciones cuando existen',
        (WidgetTester tester) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserCard(user: user),
          ),
        ),
      );

      expect(find.textContaining('dirección'), findsOneWidget);
    });

    testWidgets('debe llamar onTap cuando se toca la tarjeta',
        (WidgetTester tester) async {
      bool wasTapped = false;

      final user = User(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserCard(
              user: user,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      // Buscar el GestureDetector en lugar de InkWell
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(wasTapped, isTrue);
    });
  });
}

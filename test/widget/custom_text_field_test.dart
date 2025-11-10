import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_management_app/presentation/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField Widget Tests', () {
    testWidgets('debe mostrar el label correctamente',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Nombre',
            ),
          ),
        ),
      );

      expect(find.text('Nombre'), findsOneWidget);
    });

    testWidgets('debe mostrar hint text cuando se proporciona',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Nombre',
              hintText: 'Ingrese su nombre',
            ),
          ),
        ),
      );

      expect(find.text('Ingrese su nombre'), findsOneWidget);
    });

    testWidgets('debe mostrar ícono de prefijo cuando se proporciona',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Nombre',
              prefixIcon: Icon(Icons.person),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('debe llamar validador cuando se valida el formulario',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      bool validatorCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                label: 'Nombre',
                validator: (value) {
                  validatorCalled = true;
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      expect(validatorCalled, isTrue);
    });

    testWidgets('debe ser de solo lectura cuando readOnly es true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Fecha',
              readOnly: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.readOnly, isTrue);
    });
  });
}

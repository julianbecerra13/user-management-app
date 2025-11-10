# User Management App

Aplicación móvil desarrollada en Flutter para la gestión de usuarios y sus direcciones físicas.

## Características

- ✅ Crear, editar y eliminar usuarios
- ✅ Gestionar múltiples direcciones por usuario
- ✅ Validación de formularios
- ✅ Persistencia de datos con SharedPreferences
- ✅ Interfaz intuitiva y responsive
- ✅ Selector de país, departamento y municipio

## Arquitectura

El proyecto implementa **Clean Architecture** con separación clara de responsabilidades:

```
lib/
├── core/                 # Constantes, utilidades y configuración
│   ├── constants/        # Constantes de la app (no hardcoded)
│   └── utils/            # Validadores y helpers reutilizables
├── data/                 # Capa de datos
│   ├── models/           # Modelos de datos (User, Address)
│   └── repositories/     # Implementación de repositorios
├── presentation/         # Capa de presentación
│   ├── providers/        # Gestión de estado con Provider
│   ├── screens/          # Pantallas de la aplicación
│   └── widgets/          # Widgets reutilizables
└── main.dart            # Punto de entrada
```

## Principios de Desarrollo

### SOLID

- **S**ingle Responsibility: Cada clase tiene una responsabilidad única
- **O**pen/Closed: Código abierto a extensión, cerrado a modificación
- **L**iskov Substitution: Interfaces y abstracciones bien definidas
- **I**nterface Segregation: Interfaces específicas y cohesivas
- **D**ependency Inversion: Dependencia en abstracciones, no implementaciones

### DRY (Don't Repeat Yourself)

- Validadores centralizados
- Widgets reutilizables
- Constantes compartidas
- Utilidades comunes

### KISS (Keep It Simple, Stupid)

- Código claro y legible
- Soluciones simples y directas
- Sin sobre-ingeniería

### Clean Code

- Nombres descriptivos
- Funciones pequeñas y enfocadas
- Comentarios significativos
- Sin valores hardcoded

## Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo móvil
- **Provider**: Gestión de estado
- **SharedPreferences**: Persistencia de datos local
- **CSC Picker**: Selector de país, estado y ciudad
- **Intl**: Formateo de fechas

## Instalación y Ejecución

### Prerrequisitos

- Flutter SDK (3.0.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Emulador o dispositivo físico

### Pasos

1. Clonar el repositorio:
```bash
git clone <url-del-repositorio>
cd user_management_app
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Ejecutar la aplicación:
```bash
flutter run
```

## Tests

El proyecto incluye tests unitarios y de widgets con buena cobertura.

### Ejecutar tests

```bash
# Todos los tests
flutter test

# Con coverage
flutter test --coverage

# Ver reporte de coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Estructura de tests

```
test/
├── unit/                 # Tests unitarios
│   ├── models_test.dart
│   ├── validators_test.dart
│   └── user_repository_test.dart
└── widget/              # Tests de widgets
    ├── user_card_test.dart
    └── custom_text_field_test.dart
```

## Funcionalidades Principales

### 1. Pantalla Home
- Lista de usuarios registrados
- Búsqueda y filtrado
- Acceso rápido a edición y eliminación
- Estado vacío amigable

### 2. Formulario de Usuario
- Validación en tiempo real
- Campos: Nombre, Apellido, Fecha de Nacimiento
- Selector de fecha con restricciones
- Mensajes de error claros

### 3. Gestión de Direcciones
- Múltiples direcciones por usuario
- Selector de País, Departamento y Municipio
- Agregar y eliminar direcciones
- Vista organizada de direcciones

## Estructura de Datos

### User
```dart
{
  "id": "user_123",
  "firstName": "Juan",
  "lastName": "Pérez",
  "birthDate": "1990-01-01T00:00:00.000",
  "addresses": [...]
}
```

### Address
```dart
{
  "id": "addr_123",
  "country": "Colombia",
  "state": "Antioquia",
  "city": "Medellín"
}
```

## Validaciones

- Nombre y apellido: Solo letras y espacios, mínimo 2 caracteres
- Fecha de nacimiento: No puede ser futura, edad entre 0-150 años
- Direcciones: Todos los campos son requeridos

## Decisiones Técnicas

1. **Provider vs Bloc**: Se eligió Provider por su simplicidad y ser la solución recomendada oficialmente
2. **SharedPreferences**: Suficiente para el alcance del proyecto, fácil de migrar a SQLite si se requiere
3. **CSC Picker**: Proporciona datos reales de ubicaciones geográficas
4. **Clean Architecture**: Facilita mantenibilidad y testing

## Mejoras Futuras

- [ ] Búsqueda y filtrado de usuarios
- [ ] Exportación de datos a CSV/JSON
- [ ] Soporte para múltiples idiomas
- [ ] Temas claro/oscuro
- [ ] Sincronización con backend
- [ ] Validación de duplicados

## Autor

Desarrollado como prueba técnica para Double V Partners NYX.

## Licencia

Este proyecto es de uso privado para fines de evaluación técnica.

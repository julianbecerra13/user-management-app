import 'address.dart';

/// Modelo de usuario
/// Representa un usuario con sus datos personales y direcciones
class User {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<Address> addresses;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    List<Address>? addresses,
  }) : addresses = addresses ?? [];

  /// Crea una instancia desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((addr) => Address.fromJson(addr as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'addresses': addresses.map((addr) => addr.toJson()).toList(),
    };
  }

  /// Crea una copia con valores modificados
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    List<Address>? addresses,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
    );
  }

  /// Nombre completo del usuario
  String get fullName => '$firstName $lastName';

  /// Calcula la edad del usuario
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Agrega una dirección a la lista
  User addAddress(Address address) {
    final updatedAddresses = List<Address>.from(addresses)..add(address);
    return copyWith(addresses: updatedAddresses);
  }

  /// Elimina una dirección de la lista
  User removeAddress(String addressId) {
    final updatedAddresses =
        addresses.where((addr) => addr.id != addressId).toList();
    return copyWith(addresses: updatedAddresses);
  }

  /// Actualiza una dirección existente
  User updateAddress(Address updatedAddress) {
    final updatedAddresses = addresses.map((addr) {
      return addr.id == updatedAddress.id ? updatedAddress : addr;
    }).toList();
    return copyWith(addresses: updatedAddresses);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => fullName;
}

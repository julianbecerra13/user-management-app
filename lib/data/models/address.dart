/// Modelo de dirección
/// Representa una dirección física completa con país, departamento, municipio y dirección física
class Address {
  final String id;
  final String country;
  final String state;
  final String city;
  final String streetAddress; // Dirección física: Calle, número, apartamento, etc.

  Address({
    required this.id,
    required this.country,
    required this.state,
    required this.city,
    this.streetAddress = '', // Valor por defecto para compatibilidad con datos existentes
  });

  /// Crea una instancia desde JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    // Manejo seguro de streetAddress para compatibilidad con datos existentes
    String safeStreetAddress = '';
    try {
      safeStreetAddress = json['streetAddress']?.toString() ??
                          json['street_address']?.toString() ??
                          '';
    } catch (e) {
      safeStreetAddress = '';
    }

    return Address(
      id: json['id'] as String,
      country: json['country'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      streetAddress: safeStreetAddress,
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'state': state,
      'city': city,
      'streetAddress': streetAddress,
    };
  }

  /// Crea una copia con valores modificados
  Address copyWith({
    String? id,
    String? country,
    String? state,
    String? city,
    String? streetAddress,
  }) {
    return Address(
      id: id ?? this.id,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
    );
  }

  /// Representación en texto de la dirección completa
  String get fullAddress {
    if (streetAddress.isEmpty) {
      return '$city, $state, $country';
    }
    return '$streetAddress, $city, $state, $country';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => fullAddress;
}

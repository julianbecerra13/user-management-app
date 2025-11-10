/// Modelo de dirección
/// Representa una dirección física con país, departamento y municipio
class Address {
  final String id;
  final String country;
  final String state;
  final String city;

  Address({
    required this.id,
    required this.country,
    required this.state,
    required this.city,
  });

  /// Crea una instancia desde JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      country: json['country'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
    );
  }

  /// Convierte la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'state': state,
      'city': city,
    };
  }

  /// Crea una copia con valores modificados
  Address copyWith({
    String? id,
    String? country,
    String? state,
    String? city,
  }) {
    return Address(
      id: id ?? this.id,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
    );
  }

  /// Representación en texto de la dirección completa
  String get fullAddress => '$city, $state, $country';

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

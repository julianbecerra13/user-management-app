import 'dart:convert';
import 'package:flutter/services.dart';

/// Servicio para cargar y gestionar datos de ubicaciones desde JSON
class LocationService {
  static LocationData? _cachedData;

  /// Carga los datos de ubicaciones desde el archivo JSON
  static Future<LocationData> loadLocations() async {
    // Retornar datos cacheados si ya existen
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      // Cargar el archivo JSON desde assets
      final String jsonString =
          await rootBundle.loadString('assets/data/locations.json');

      // Parsear el JSON
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Crear el objeto LocationData
      _cachedData = LocationData.fromJson(jsonData);

      return _cachedData!;
    } catch (e) {
      throw Exception('Error al cargar ubicaciones: $e');
    }
  }

  /// Obtiene la lista de países
  static Future<List<String>> getCountries() async {
    final data = await loadLocations();
    return data.countries.map((c) => c.name).toList()..sort();
  }

  /// Obtiene los estados/departamentos de un país
  static Future<List<String>> getStates(String country) async {
    final data = await loadLocations();
    final countryData = data.countries.firstWhere(
      (c) => c.name == country,
      orElse: () => Country(name: '', states: []),
    );
    return countryData.states.map((s) => s.name).toList()..sort();
  }

  /// Obtiene las ciudades de un estado/departamento
  static Future<List<String>> getCities(String country, String state) async {
    final data = await loadLocations();
    final countryData = data.countries.firstWhere(
      (c) => c.name == country,
      orElse: () => Country(name: '', states: []),
    );
    final stateData = countryData.states.firstWhere(
      (s) => s.name == state,
      orElse: () => StateData(name: '', cities: []),
    );
    return List<String>.from(stateData.cities)..sort();
  }

  /// Limpia el cache
  static void clearCache() {
    _cachedData = null;
  }
}

/// Modelo de datos de ubicaciones
class LocationData {
  final List<Country> countries;

  LocationData({required this.countries});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      countries: (json['countries'] as List<dynamic>)
          .map((c) => Country.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Modelo de país
class Country {
  final String name;
  final List<StateData> states;

  Country({required this.name, required this.states});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] as String,
      states: (json['states'] as List<dynamic>)
          .map((s) => StateData.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Modelo de estado/departamento
class StateData {
  final String name;
  final List<String> cities;

  StateData({required this.name, required this.cities});

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      name: json['name'] as String,
      cities: (json['cities'] as List<dynamic>)
          .map((c) => c.toString())
          .toList(),
    );
  }
}

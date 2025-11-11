import 'package:flutter/material.dart';

/// Widget personalizado para seleccionar país, departamento y ciudad
/// Reemplazo de csc_picker por incompatibilidad
class LocationPicker extends StatefulWidget {
  final Function(String?) onCountryChanged;
  final Function(String?) onStateChanged;
  final Function(String?) onCityChanged;
  final String countryLabel;
  final String stateLabel;
  final String cityLabel;

  const LocationPicker({
    Key? key,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.countryLabel,
    required this.stateLabel,
    required this.cityLabel,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  // Lista simplificada de ubicaciones
  static const Map<String, Map<String, List<String>>> locations = {
    'Colombia': {
      'Antioquia': ['Medellín', 'Envigado', 'Itagüí', 'Bello', 'Rionegro'],
      'Cundinamarca': ['Bogotá', 'Soacha', 'Chía', 'Zipaquirá', 'Facatativá'],
      'Valle del Cauca': ['Cali', 'Palmira', 'Buenaventura', 'Tuluá', 'Cartago'],
      'Atlántico': ['Barranquilla', 'Soledad', 'Malambo', 'Sabanalarga', 'Puerto Colombia'],
      'Santander': ['Bucaramanga', 'Floridablanca', 'Girón', 'Piedecuesta', 'Barrancabermeja'],
    },
    'México': {
      'Ciudad de México': ['Ciudad de México', 'Iztapalapa', 'Álvaro Obregón', 'Coyoacán', 'Cuauhtémoc'],
      'Jalisco': ['Guadalajara', 'Zapopan', 'Tlaquepaque', 'Tonalá', 'Puerto Vallarta'],
      'Nuevo León': ['Monterrey', 'San Pedro Garza García', 'Guadalupe', 'San Nicolás de los Garza', 'Apodaca'],
      'Estado de México': ['Ecatepec', 'Nezahualcóyotl', 'Naucalpan', 'Tlalnepantla', 'Toluca'],
    },
    'Argentina': {
      'Buenos Aires': ['Buenos Aires', 'La Plata', 'Mar del Plata', 'Quilmes', 'Avellaneda'],
      'Córdoba': ['Córdoba', 'Villa María', 'Río Cuarto', 'San Francisco', 'Villa Carlos Paz'],
      'Santa Fe': ['Rosario', 'Santa Fe', 'Rafaela', 'Venado Tuerto', 'Reconquista'],
    },
    'España': {
      'Madrid': ['Madrid', 'Móstoles', 'Alcalá de Henares', 'Fuenlabrada', 'Leganés'],
      'Cataluña': ['Barcelona', 'Hospitalet de Llobregat', 'Badalona', 'Sabadell', 'Terrassa'],
      'Andalucía': ['Sevilla', 'Málaga', 'Córdoba', 'Granada', 'Jerez de la Frontera'],
    },
  };

  @override
  Widget build(BuildContext context) {
    final countries = locations.keys.toList();
    countries.sort();

    final states = _selectedCountry != null
        ? (locations[_selectedCountry]?.keys.toList() ?? [])
        : <String>[];
    states.sort();

    final cities = _selectedState != null && _selectedCountry != null
        ? (locations[_selectedCountry]?[_selectedState] ?? [])
        : <String>[];
    cities.sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown de País
        DropdownButtonFormField<String>(
          value: _selectedCountry,
          decoration: InputDecoration(
            labelText: widget.countryLabel,
            border: const OutlineInputBorder(),
          ),
          items: countries.map((country) {
            return DropdownMenuItem(
              value: country,
              child: Text(country),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
              _selectedState = null;
              _selectedCity = null;
            });
            widget.onCountryChanged(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor seleccione un país';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Dropdown de Departamento/Estado
        DropdownButtonFormField<String>(
          value: _selectedState,
          decoration: InputDecoration(
            labelText: widget.stateLabel,
            border: const OutlineInputBorder(),
          ),
          items: states.map((state) {
            return DropdownMenuItem(
              value: state,
              child: Text(state),
            );
          }).toList(),
          onChanged: _selectedCountry == null
              ? null
              : (value) {
                  setState(() {
                    _selectedState = value;
                    _selectedCity = null;
                  });
                  widget.onStateChanged(value);
                },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor seleccione un departamento';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Dropdown de Ciudad
        DropdownButtonFormField<String>(
          value: _selectedCity,
          decoration: InputDecoration(
            labelText: widget.cityLabel,
            border: const OutlineInputBorder(),
          ),
          items: cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: _selectedState == null
              ? null
              : (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                  widget.onCityChanged(value);
                },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor seleccione una ciudad';
            }
            return null;
          },
        ),
      ],
    );
  }
}

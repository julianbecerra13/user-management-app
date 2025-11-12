import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../data/services/location_service.dart';

/// Widget personalizado para seleccionar país, departamento y ciudad con diseño futurista
/// Carga datos completos desde JSON local (17 países, 100+ estados, 800+ ciudades)
class LocationPicker extends StatefulWidget {
  final Function(String?) onCountryChanged;
  final Function(String?) onStateChanged;
  final Function(String?) onCityChanged;
  final String countryLabel;
  final String stateLabel;
  final String cityLabel;
  final String? initialCountry;
  final String? initialState;
  final String? initialCity;

  const LocationPicker({
    Key? key,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.countryLabel,
    required this.stateLabel,
    required this.cityLabel,
    this.initialCountry,
    this.initialState,
    this.initialCity,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  List<String> _countries = [];
  List<String> _states = [];
  List<String> _cities = [];

  bool _isLoadingCountries = true;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _selectedState = widget.initialState;
    _selectedCity = widget.initialCity;
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoadingCountries = true);
    try {
      final countries = await LocationService.getCountries();
      setState(() {
        _countries = countries;
        _isLoadingCountries = false;
      });

      // Si hay país inicial, cargar sus estados
      if (_selectedCountry != null && _selectedCountry!.isNotEmpty) {
        await _loadStates(_selectedCountry!);
      }
    } catch (e) {
      setState(() => _isLoadingCountries = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar países: $e')),
        );
      }
    }
  }

  Future<void> _loadStates(String country) async {
    setState(() => _isLoadingStates = true);
    try {
      final states = await LocationService.getStates(country);
      setState(() {
        _states = states;
        _isLoadingStates = false;
      });

      // Si hay estado inicial, cargar sus ciudades
      if (_selectedState != null && _selectedState!.isNotEmpty) {
        await _loadCities(country, _selectedState!);
      }
    } catch (e) {
      setState(() => _isLoadingStates = false);
    }
  }

  Future<void> _loadCities(String country, String state) async {
    setState(() => _isLoadingCities = true);
    try {
      final cities = await LocationService.getCities(country, state);
      setState(() {
        _cities = cities;
        _isLoadingCities = false;
      });
    } catch (e) {
      setState(() => _isLoadingCities = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown de País
        _buildFuturisticDropdown<String>(
          label: widget.countryLabel,
          value: _selectedCountry,
          items: _countries,
          icon: Icons.public,
          enabled: !_isLoadingCountries && _countries.isNotEmpty,
          isLoading: _isLoadingCountries,
          onChanged: (value) async {
            setState(() {
              _selectedCountry = value;
              _selectedState = null;
              _selectedCity = null;
              _states = [];
              _cities = [];
            });
            widget.onCountryChanged(value);
            if (value != null && value.isNotEmpty) {
              await _loadStates(value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor seleccione un país';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Dropdown de Departamento/Estado
        _buildFuturisticDropdown<String>(
          label: widget.stateLabel,
          value: _selectedState,
          items: _states,
          icon: Icons.location_city,
          enabled: _selectedCountry != null &&
              !_isLoadingStates &&
              _states.isNotEmpty,
          isLoading: _isLoadingStates,
          onChanged: (value) async {
            setState(() {
              _selectedState = value;
              _selectedCity = null;
              _cities = [];
            });
            widget.onStateChanged(value);
            if (value != null &&
                value.isNotEmpty &&
                _selectedCountry != null) {
              await _loadCities(_selectedCountry!, value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor seleccione un departamento';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Dropdown de Ciudad
        _buildFuturisticDropdown<String>(
          label: widget.cityLabel,
          value: _selectedCity,
          items: _cities,
          icon: Icons.location_on,
          enabled:
              _selectedState != null && !_isLoadingCities && _cities.isNotEmpty,
          isLoading: _isLoadingCities,
          onChanged: (value) {
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

  Widget _buildFuturisticDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required IconData icon,
    required void Function(T?)? onChanged,
    required String? Function(T?)? validator,
    required bool enabled,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con gradiente e ícono
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryCyan,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Dropdown con efecto glassmorphism
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                enabled
                    ? AppTheme.darkCard.withValues(alpha: 0.5)
                    : AppTheme.darkCard.withValues(alpha: 0.3),
                enabled
                    ? AppTheme.darkSurface.withValues(alpha: 0.3)
                    : AppTheme.darkSurface.withValues(alpha: 0.2),
              ],
            ),
            border: Border.all(
              color: enabled
                  ? AppTheme.primaryCyan.withValues(alpha: 0.3)
                  : AppTheme.textHint.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: DropdownButtonFormField<T>(
                value: value,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.errorColor,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.errorColor,
                      width: 2,
                    ),
                  ),
                  errorStyle: const TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  hintText: enabled
                      ? 'Seleccione una opción'
                      : 'Seleccione primero la opción anterior',
                  hintStyle: TextStyle(
                    color: AppTheme.textHint.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                dropdownColor: AppTheme.darkCard,
                icon: ShaderMask(
                  shaderCallback: (bounds) =>
                      AppTheme.primaryGradient.createShader(bounds),
                  child: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                items: items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.toString(),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: enabled ? onChanged : null,
                validator: validator,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

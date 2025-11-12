import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_theme.dart';

/// DatePicker futurista personalizado con diseño glassmorphic
class FuturisticDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return _FuturisticDatePickerDialog(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );
      },
    );
  }
}

class _FuturisticDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _FuturisticDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_FuturisticDatePickerDialog> createState() =>
      _FuturisticDatePickerDialogState();
}

class _FuturisticDatePickerDialogState
    extends State<_FuturisticDatePickerDialog> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  Future<void> _showYearMonthPicker() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _YearMonthPickerDialog(
          initialDate: _displayedMonth,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onDateSelected: (DateTime selectedDate) {
            setState(() {
              _displayedMonth = selectedDate;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              AppTheme.darkCard.withOpacity(0.95),
              AppTheme.darkSurface.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppTheme.primaryCyan.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: AppTheme.glowShadow(color: AppTheme.primaryCyan),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildMonthNavigation(),
                _buildCalendarGrid(),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient.scale(0.3),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryCyan.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppTheme.primaryGradient.createShader(bounds),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seleccionar Fecha',
                  style: AppTheme.heading2.copyWith(
                    fontSize: 18,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppTheme.primaryGradient.createShader(bounds),
                  child: Text(
                    DateFormat('dd MMMM yyyy', 'es_ES').format(_selectedDate),
                    style: AppTheme.bodyTextSecondary.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          _buildNavButton(
            icon: Icons.chevron_left,
            onPressed: _previousMonth,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: _showYearMonthPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryCyan.withOpacity(0.2),
                      AppTheme.primaryPurple.withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(
                    color: AppTheme.primaryCyan.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.primaryGradient.createShader(bounds),
                        child: Text(
                          DateFormat('MMMM yyyy', 'es_ES').format(_displayedMonth),
                          style: AppTheme.heading2.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.primaryGradient.createShader(bounds),
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildNavButton(
            icon: Icons.chevron_right,
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryCyan.withOpacity(0.2),
            AppTheme.primaryPurple.withOpacity(0.2),
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryCyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  AppTheme.primaryGradient.createShader(bounds),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstDayOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          // Días de la semana
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['D', 'L', 'M', 'M', 'J', 'V', 'S']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.primaryCyan,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Grilla de días
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday) {
                return const SizedBox();
              }
              final day = index - firstWeekday + 1;
              final date =
                  DateTime(_displayedMonth.year, _displayedMonth.month, day);
              final isSelected = date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;

              return _buildDayCell(date, isSelected, isToday);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime date, bool isSelected, bool isToday) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? AppTheme.primaryGradient
              : (isToday
                  ? LinearGradient(
                      colors: [
                        AppTheme.primaryCyan.withOpacity(0.2),
                        AppTheme.primaryPurple.withOpacity(0.2),
                      ],
                    )
                  : null),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isToday
                    ? AppTheme.primaryCyan.withOpacity(0.5)
                    : Colors.transparent),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryCyan.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: isSelected
                  ? AppTheme.darkBackground
                  : (isToday ? AppTheme.primaryCyan : AppTheme.textPrimary),
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryCyan.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            label: 'Cancelar',
            onPressed: () => Navigator.pop(context),
            isPrimary: false,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Seleccionar',
            onPressed: () => Navigator.pop(context, _selectedDate),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isPrimary
            ? AppTheme.primaryGradient
            : LinearGradient(
                colors: [
                  AppTheme.darkCard.withOpacity(0.5),
                  AppTheme.darkSurface.withOpacity(0.5),
                ],
              ),
        border: Border.all(
          color: isPrimary
              ? Colors.transparent
              : AppTheme.primaryCyan.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppTheme.primaryCyan.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              label,
              style: TextStyle(
                color: isPrimary ? AppTheme.darkBackground : AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Diálogo para seleccionar año y mes directamente
class _YearMonthPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;

  const _YearMonthPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<_YearMonthPickerDialog> createState() => _YearMonthPickerDialogState();
}

class _YearMonthPickerDialogState extends State<_YearMonthPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              AppTheme.darkCard.withOpacity(0.95),
              AppTheme.darkSurface.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppTheme.primaryCyan.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: AppTheme.glowShadow(color: AppTheme.primaryCyan),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildYearMonthSelectors(),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient.scale(0.3),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryCyan.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppTheme.primaryGradient.createShader(bounds),
            child: const Icon(
              Icons.event_outlined,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Seleccionar Mes y Año',
            style: AppTheme.heading2.copyWith(
              fontSize: 18,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearMonthSelectors() {
    final years = List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    ).reversed.toList();

    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Selector de Año
          _buildSelector(
            label: 'Año',
            icon: Icons.calendar_today,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.darkCard.withOpacity(0.5),
                    AppTheme.darkSurface.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: AppTheme.primaryCyan.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    controller: FixedExtentScrollController(
                      initialItem: years.indexOf(_selectedYear),
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedYear = years[index];
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: years.length,
                      builder: (context, index) {
                        final year = years[index];
                        final isSelected = year == _selectedYear;
                        return Center(
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryCyan
                                  : AppTheme.textSecondary,
                              fontSize: isSelected ? 24 : 18,
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Selector de Mes
          _buildSelector(
            label: 'Mes',
            icon: Icons.event_note,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.darkCard.withOpacity(0.5),
                    AppTheme.darkSurface.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    controller: FixedExtentScrollController(
                      initialItem: _selectedMonth - 1,
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedMonth = index + 1;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: months.length,
                      builder: (context, index) {
                        final month = months[index];
                        final isSelected = index + 1 == _selectedMonth;
                        return Center(
                          child: Text(
                            month,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryPurple
                                  : AppTheme.textSecondary,
                              fontSize: isSelected ? 20 : 16,
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelector({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            ],
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryCyan.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            label: 'Cancelar',
            onPressed: () => Navigator.pop(context),
            isPrimary: false,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Aplicar',
            onPressed: () {
              final selectedDate = DateTime(_selectedYear, _selectedMonth);
              widget.onDateSelected(selectedDate);
              Navigator.pop(context);
            },
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isPrimary
            ? AppTheme.primaryGradient
            : LinearGradient(
                colors: [
                  AppTheme.darkCard.withOpacity(0.5),
                  AppTheme.darkSurface.withOpacity(0.5),
                ],
              ),
        border: Border.all(
          color: isPrimary
              ? Colors.transparent
              : AppTheme.primaryCyan.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppTheme.primaryCyan.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              label,
              style: TextStyle(
                color: isPrimary ? AppTheme.darkBackground : AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

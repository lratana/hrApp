import 'package:flutter/material.dart';
import 'package:flutter_application_1/appbar_decoration.dart';
import 'package:flutter_application_1/screens/timesheet_entries_screen.dart';
import 'package:intl/intl.dart';

class TimesheetDay {
  final DateTime date;
  double regularHours;
  double overtimeHours;
  String notes;
  String projectCode;
  bool isSubmitted;

  TimesheetDay({
    required this.date,
    this.regularHours = 0,
    this.overtimeHours = 0,
    this.notes = '',
    this.projectCode = 'General Work',
    this.isSubmitted = false,
  });

  double get totalHours => regularHours + overtimeHours;

  bool get hasEntries => regularHours > 0 || overtimeHours > 0;
}

class TimesheetScreen extends StatefulWidget {
  const TimesheetScreen({super.key});

  @override
  State<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends State<TimesheetScreen> {
  DateTime _selectedWeek = DateTime.now();
  List<TimesheetDay> _weekDays = [];
  bool _isSubmitting = false;
  bool _isWeekSubmitted = false;

  final List<String> _projectCodes = [
    'General Work',
    'Project Alpha',
    'Project Beta',
    'Client Meeting',
    'Training',
    'Administrative',
    'Research',
    'Development',
  ];

  @override
  void initState() {
    super.initState();
    _initializeWeek();
  }

  void _initializeWeek() {
    final startOfWeek = _getStartOfWeek(_selectedWeek);
    _weekDays = List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      // Pre-populate some sample data for demonstration
      if (date.isBefore(DateTime.now()) && date.weekday <= 5) {
        return TimesheetDay(
          date: date,
          regularHours: 8.0,
          overtimeHours: 0.0,
          notes: '',
          projectCode: 'General Work',
          isSubmitted: true,
        );
      }
      return TimesheetDay(date: date);
    });

    // Check if entire week is submitted
    _isWeekSubmitted = _weekDays.every((day) => day.isSubmitted);
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _previousWeek() {
    setState(() {
      _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
      _initializeWeek();
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedWeek = _selectedWeek.add(const Duration(days: 7));
      _initializeWeek();
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      _selectedWeek = DateTime.now();
      _initializeWeek();
    });
  }

  double get _totalWeekHours {
    return _weekDays.fold(0, (sum, day) => sum + day.totalHours);
  }

  double get _totalRegularHours {
    return _weekDays.fold(0, (sum, day) => sum + day.regularHours);
  }

  double get _totalOvertimeHours {
    return _weekDays.fold(0, (sum, day) => sum + day.overtimeHours);
  }

  void _editDayEntry(TimesheetDay day) {
    if (day.isSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot edit submitted entries'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _EditDayEntrySheet(
        day: day,
        projectCodes: _projectCodes,
        onSave: () {
          setState(() {});
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _submitTimesheet() async {
    // Check if there are any entries
    if (!_weekDays.any((day) => day.hasEntries)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one timesheet entry'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      // Mark all days as submitted
      for (var day in _weekDays) {
        if (day.hasEntries) {
          day.isSubmitted = true;
        }
      }
      _isWeekSubmitted = true;
    });

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64,
                color: Color(0xFF48BB78),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Timesheet Submitted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3E5C),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Total Hours: ${_totalWeekHours.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF2E7D95),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your timesheet has been submitted successfully and is pending approval.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D95),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final startOfWeek = _getStartOfWeek(_selectedWeek);
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: decoration(),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Timesheet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.history, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TimesheetEntriesScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Week Navigation
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: _previousWeek,
                            color: const Color(0xFF2E7D95),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d, yyyy').format(endOfWeek)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E3E5C),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                TextButton.icon(
                                  onPressed: _goToCurrentWeek,
                                  icon: const Icon(Icons.today, size: 16),
                                  label: const Text('Current Week'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF2E7D95),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: _nextWeek,
                            color: const Color(0xFF2E7D95),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Summary Card
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SummaryItem(
                            label: 'Total',
                            hours: _totalWeekHours,
                            icon: Icons.access_time,
                            color: const Color(0xFF2E7D95),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: _SummaryItem(
                            label: 'Regular',
                            hours: _totalRegularHours,
                            icon: Icons.schedule,
                            color: const Color(0xFF48BB78),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: _SummaryItem(
                            label: 'Overtime',
                            hours: _totalOvertimeHours,
                            icon: Icons.access_time_filled,
                            color: const Color(0xFFED8936),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Days List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _weekDays.length,
              itemBuilder: (context, index) {
                final day = _weekDays[index];
                final isToday =
                    day.date.day == DateTime.now().day &&
                    day.date.month == DateTime.now().month &&
                    day.date.year == DateTime.now().year;
                final isWeekend = day.date.weekday >= 6;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isToday
                        ? Border.all(color: const Color(0xFF2E7D95), width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _editDayEntry(day),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Date Column
                            Container(
                              width: 60,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isWeekend
                                    ? Colors.grey[100]
                                    : const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat('EEE').format(day.date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isWeekend
                                          ? Colors.grey[600]
                                          : const Color(0xFF2E7D95),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('d').format(day.date),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isWeekend
                                          ? Colors.grey[600]
                                          : const Color(0xFF2E7D95),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Hours Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (day.hasEntries) ...[
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.work_outline,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            day.projectCode,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2E3E5C),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _HourBadge(
                                          label: 'Regular',
                                          hours: day.regularHours,
                                          color: const Color(0xFF48BB78),
                                        ),
                                        if (day.overtimeHours > 0) ...[
                                          const SizedBox(width: 8),
                                          _HourBadge(
                                            label: 'OT',
                                            hours: day.overtimeHours,
                                            color: const Color(0xFFED8936),
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (day.notes.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        day.notes,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ] else ...[
                                    Text(
                                      'No entries',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tap to add',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Status Icon
                            Column(
                              children: [
                                if (day.isSubmitted)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE8F5E9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF48BB78),
                                      size: 20,
                                    ),
                                  )
                                else if (day.hasEntries)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF5F0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Color(0xFFED8936),
                                      size: 20,
                                    ),
                                  )
                                else
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey[400],
                                  ),
                                if (day.hasEntries) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '${day.totalHours.toStringAsFixed(1)}h',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D95),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Submit Button
          if (!_isWeekSubmitted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitTimesheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D95),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Submit Timesheet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double hours;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.hours,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          '${hours.toStringAsFixed(1)}h',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _HourBadge extends StatelessWidget {
  final String label;
  final double hours;
  final Color color;

  const _HourBadge({
    required this.label,
    required this.hours,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${hours.toStringAsFixed(1)}h',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditDayEntrySheet extends StatefulWidget {
  final TimesheetDay day;
  final List<String> projectCodes;
  final VoidCallback onSave;

  const _EditDayEntrySheet({
    required this.day,
    required this.projectCodes,
    required this.onSave,
  });

  @override
  State<_EditDayEntrySheet> createState() => _EditDayEntrySheetState();
}

class _EditDayEntrySheetState extends State<_EditDayEntrySheet> {
  late TextEditingController _regularHoursController;
  late TextEditingController _overtimeHoursController;
  late TextEditingController _notesController;
  late String _selectedProject;

  @override
  void initState() {
    super.initState();
    _regularHoursController = TextEditingController(
      text: widget.day.regularHours > 0
          ? widget.day.regularHours.toString()
          : '',
    );
    _overtimeHoursController = TextEditingController(
      text: widget.day.overtimeHours > 0
          ? widget.day.overtimeHours.toString()
          : '',
    );
    _notesController = TextEditingController(text: widget.day.notes);
    _selectedProject = widget.day.projectCode;
  }

  @override
  void dispose() {
    _regularHoursController.dispose();
    _overtimeHoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final regularHours = double.tryParse(_regularHoursController.text) ?? 0;
    final overtimeHours = double.tryParse(_overtimeHoursController.text) ?? 0;

    if (regularHours < 0 || regularHours > 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Regular hours must be between 0 and 24'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (overtimeHours < 0 || overtimeHours > 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Overtime hours must be between 0 and 24'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.day.regularHours = regularHours;
    widget.day.overtimeHours = overtimeHours;
    widget.day.notes = _notesController.text;
    widget.day.projectCode = _selectedProject;

    widget.onSave();
  }

  void _delete() {
    widget.day.regularHours = 0;
    widget.day.overtimeHours = 0;
    widget.day.notes = '';
    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMM d').format(widget.day.date),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Project Selector
          const Text(
            'Project/Job Code',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedProject,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.work_outline,
                color: Color(0xFF2E7D95),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: widget.projectCodes
                .map((code) => DropdownMenuItem(value: code, child: Text(code)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedProject = value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Hours Input
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Regular Hours',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3E5C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _regularHoursController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.0',
                        prefixIcon: const Icon(
                          Icons.schedule,
                          color: Color(0xFF48BB78),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overtime Hours',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3E5C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _overtimeHoursController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.0',
                        prefixIcon: const Icon(
                          Icons.access_time_filled,
                          color: Color(0xFFED8936),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notes
          const Text(
            'Notes (Optional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add any notes about this day...',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              if (widget.day.hasEntries)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _delete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              if (widget.day.hasEntries) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF2E7D95),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

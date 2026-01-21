import 'package:flutter/material.dart';
import 'package:flutter_application_1/appbar_decoration.dart';
import 'package:intl/intl.dart';

class TimesheetEntry {
  final DateTime date;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final String jobCode;
  final String status; // 'completed', 'in-progress', 'pending'

  TimesheetEntry({
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.jobCode,
    required this.status,
  });

  Duration get totalHours {
    if (clockIn != null && clockOut != null) {
      return clockOut!.difference(clockIn!);
    }
    return Duration.zero;
  }

  String get formattedHours {
    final hours = totalHours.inHours;
    final minutes = totalHours.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

class TimesheetEntriesScreen extends StatefulWidget {
  const TimesheetEntriesScreen({super.key});

  @override
  State<TimesheetEntriesScreen> createState() => _TimesheetEntriesScreenState();
}

class _TimesheetEntriesScreenState extends State<TimesheetEntriesScreen> {
  String _selectedFilter = 'This Week';
  final List<String> _filterOptions = [
    'Today',
    'This Week',
    'This Month',
    'All',
  ];

  // Sample timesheet data
  final List<TimesheetEntry> _timesheetEntries = [
    TimesheetEntry(
      date: DateTime(2026, 1, 21),
      clockIn: DateTime(2026, 1, 21, 9, 0),
      clockOut: DateTime(2026, 1, 21, 16, 45),
      jobCode: 'General Work',
      status: 'completed',
    ),
    TimesheetEntry(
      date: DateTime(2026, 1, 20),
      clockIn: DateTime(2026, 1, 20, 8, 30),
      clockOut: DateTime(2026, 1, 20, 17, 15),
      jobCode: 'General Work',
      status: 'completed',
    ),
    TimesheetEntry(
      date: DateTime(2026, 1, 19),
      clockIn: DateTime(2026, 1, 19, 9, 15),
      clockOut: DateTime(2026, 1, 19, 17, 0),
      jobCode: 'Remote Work',
      status: 'completed',
    ),
    TimesheetEntry(
      date: DateTime(2026, 1, 18),
      clockIn: DateTime(2026, 1, 18, 8, 45),
      clockOut: DateTime(2026, 1, 18, 16, 30),
      jobCode: 'Field Work',
      status: 'completed',
    ),
    TimesheetEntry(
      date: DateTime(2026, 1, 17),
      clockIn: DateTime(2026, 1, 17, 9, 0),
      clockOut: DateTime(2026, 1, 17, 17, 0),
      jobCode: 'General Work',
      status: 'completed',
    ),
    TimesheetEntry(
      date: DateTime(2026, 1, 16),
      clockIn: DateTime(2026, 1, 16, 8, 30),
      clockOut: DateTime(2026, 1, 16, 16, 45),
      jobCode: 'Office Work',
      status: 'completed',
    ),
    TimesheetEntry(
      date: DateTime(2026, 1, 15),
      clockIn: DateTime(2026, 1, 15, 9, 0),
      clockOut: DateTime(2026, 1, 15, 17, 30),
      jobCode: 'Client Meeting',
      status: 'completed',
    ),
  ];

  List<TimesheetEntry> get _filteredEntries {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Today':
        return _timesheetEntries
            .where(
              (entry) =>
                  entry.date.year == now.year &&
                  entry.date.month == now.month &&
                  entry.date.day == now.day,
            )
            .toList();
      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return _timesheetEntries
            .where(
              (entry) => entry.date.isAfter(
                startOfWeek.subtract(const Duration(days: 1)),
              ),
            )
            .toList();
      case 'This Month':
        return _timesheetEntries
            .where(
              (entry) =>
                  entry.date.year == now.year && entry.date.month == now.month,
            )
            .toList();
      default:
        return _timesheetEntries;
    }
  }

  Duration get _totalHours {
    return _filteredEntries.fold(
      Duration.zero,
      (sum, entry) => sum + entry.totalHours,
    );
  }

  String _formatTotalHours(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Timesheet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._filterOptions.map(
              (option) => ListTile(
                leading: Icon(
                  Icons.calendar_today,
                  color: const Color(0xFF2E7D95),
                ),
                title: Text(option),
                trailing: _selectedFilter == option
                    ? const Icon(Icons.check, color: Color(0xFF2E7D95))
                    : null,
                onTap: () {
                  setState(() => _selectedFilter = option);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in-progress':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'in-progress':
        return 'In Progress';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            'Timesheet Entries',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          onPressed: _showFilterOptions,
                        ),
                      ],
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedFilter,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTotalHours(_totalHours),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D95),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: Color(0xFF2E7D95),
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _SummaryItem(
                                label: 'Entries',
                                value: '${_filteredEntries.length}',
                                icon: Icons.list,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _SummaryItem(
                                label: 'Avg/Day',
                                value: _filteredEntries.isEmpty
                                    ? '0h'
                                    : _formatTotalHours(
                                        Duration(
                                          minutes:
                                              _totalHours.inMinutes ~/
                                              _filteredEntries.length,
                                        ),
                                      ),
                                icon: Icons.trending_up,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Entries List
          Expanded(
            child: _filteredEntries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No timesheet entries found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try selecting a different filter',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _filteredEntries[index];
                      final isToday =
                          entry.date.day == DateTime.now().day &&
                          entry.date.month == DateTime.now().month &&
                          entry.date.year == DateTime.now().year;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isToday
                              ? Border.all(
                                  color: const Color(0xFF2E7D95),
                                  width: 2,
                                )
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
                            onTap: () {
                              _showEntryDetails(entry);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Date and Status Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: const Color(0xFF2E7D95),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat(
                                              'EEE, MMM d, yyyy',
                                            ).format(entry.date),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2E3E5C),
                                            ),
                                          ),
                                          if (isToday) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF2E7D95),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'TODAY',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            entry.status,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          _getStatusText(entry.status),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _getStatusColor(
                                              entry.status,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Job Code
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.work_outline,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        entry.jobCode,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Time Details Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _TimeDetailItem(
                                          icon: Icons.login,
                                          label: 'Clock In',
                                          time: entry.clockIn != null
                                              ? DateFormat(
                                                  'hh:mm a',
                                                ).format(entry.clockIn!)
                                              : '--:--',
                                          color: const Color(0xFF5FA463),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: Colors.grey[300],
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                      ),
                                      Expanded(
                                        child: _TimeDetailItem(
                                          icon: Icons.logout,
                                          label: 'Clock Out',
                                          time: entry.clockOut != null
                                              ? DateFormat(
                                                  'hh:mm a',
                                                ).format(entry.clockOut!)
                                              : '--:--',
                                          color: const Color(0xFF4A90E2),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: Colors.grey[300],
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                      ),
                                      Expanded(
                                        child: _TimeDetailItem(
                                          icon: Icons.schedule,
                                          label: 'Total',
                                          time: entry.formattedHours,
                                          color: const Color(0xFF2E7D95),
                                        ),
                                      ),
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
        ],
      ),
    );
  }

  void _showEntryDetails(TimesheetEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Entry Details',
                  style: TextStyle(
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
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: DateFormat('EEEE, MMMM d, yyyy').format(entry.date),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.work_outline,
              label: 'Job Code',
              value: entry.jobCode,
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.login,
              label: 'Clock In',
              value: entry.clockIn != null
                  ? DateFormat('hh:mm a').format(entry.clockIn!)
                  : 'Not clocked in',
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.logout,
              label: 'Clock Out',
              value: entry.clockOut != null
                  ? DateFormat('hh:mm a').format(entry.clockOut!)
                  : 'Not clocked out',
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.schedule,
              label: 'Total Hours',
              value: entry.formattedHours,
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.check_circle,
              label: 'Status',
              value: _getStatusText(entry.status),
              valueColor: _getStatusColor(entry.status),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Edit entry logic
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF2E7D95)),
                      foregroundColor: const Color(0xFF2E7D95),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Export entry logic
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Export'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF2E7D95),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2E7D95)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3E5C),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _TimeDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;

  const _TimeDetailItem({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF2E7D95)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? const Color(0xFF2E3E5C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

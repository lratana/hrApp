import 'package:flutter/material.dart';
import 'package:flutter_application_1/appbar_decoration.dart';
import 'package:intl/intl.dart';

class RequestItem {
  final String id;
  final String type; // 'leave', 'expense', 'timeoff', 'overtime'
  final String title;
  final String description;
  final DateTime submittedDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status; // 'pending', 'approved', 'rejected', 'cancelled'
  final double? amount;
  final int? days;

  RequestItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.submittedDate,
    this.startDate,
    this.endDate,
    required this.status,
    this.amount,
    this.days,
  });
}

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Approved',
    'Rejected',
  ];

  // Sample requests data
  final List<RequestItem> _allRequests = [
    RequestItem(
      id: 'REQ-001',
      type: 'leave',
      title: 'Vacation Leave',
      description: 'Family vacation trip to Florida',
      submittedDate: DateTime(2026, 1, 15),
      startDate: DateTime(2026, 5, 10),
      endDate: DateTime(2026, 5, 15),
      status: 'pending',
      days: 5,
    ),
    RequestItem(
      id: 'REQ-002',
      type: 'expense',
      title: 'Client Meeting Lunch',
      description: 'Business lunch with potential client',
      submittedDate: DateTime(2026, 1, 18),
      status: 'approved',
      amount: 125.50,
    ),
    RequestItem(
      id: 'REQ-003',
      type: 'leave',
      title: 'Sick Leave',
      description: 'Medical appointment',
      submittedDate: DateTime(2026, 1, 10),
      startDate: DateTime(2026, 1, 12),
      endDate: DateTime(2026, 1, 12),
      status: 'approved',
      days: 1,
    ),
    RequestItem(
      id: 'REQ-004',
      type: 'overtime',
      title: 'Overtime Request',
      description: 'Project deadline work',
      submittedDate: DateTime(2026, 1, 8),
      startDate: DateTime(2026, 1, 20),
      status: 'rejected',
      days: 2,
    ),
    RequestItem(
      id: 'REQ-005',
      type: 'expense',
      title: 'Travel Expense',
      description: 'Flight to client site',
      submittedDate: DateTime(2026, 1, 5),
      status: 'approved',
      amount: 450.00,
    ),
    RequestItem(
      id: 'REQ-006',
      type: 'leave',
      title: 'Personal Leave',
      description: 'Personal matters',
      submittedDate: DateTime(2025, 12, 28),
      startDate: DateTime(2026, 2, 5),
      endDate: DateTime(2026, 2, 6),
      status: 'pending',
      days: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RequestItem> _getFilteredRequests(int tabIndex) {
    List<RequestItem> requests = _allRequests;

    // Filter by tab
    switch (tabIndex) {
      case 1:
        requests = requests.where((r) => r.type == 'leave').toList();
        break;
      case 2:
        requests = requests.where((r) => r.type == 'expense').toList();
        break;
      case 3:
        requests = requests.where((r) => r.type == 'overtime').toList();
        break;
      // case 0 shows all requests (no filtering by type)
    }

    // Filter by status
    if (_selectedFilter != 'All') {
      requests = requests
          .where((r) => r.status.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    return requests..sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
  }

  Map<String, int> get _requestStats {
    return {
      'total': _allRequests.length,
      'pending': _allRequests.where((r) => r.status == 'pending').length,
      'approved': _allRequests.where((r) => r.status == 'approved').length,
      'rejected': _allRequests.where((r) => r.status == 'rejected').length,
    };
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFED8936);
      case 'approved':
        return const Color(0xFF48BB78);
      case 'rejected':
        return const Color(0xFFE53E3E);
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'leave':
        return Icons.beach_access;
      case 'expense':
        return Icons.receipt_long;
      case 'overtime':
        return Icons.access_time_filled;
      case 'timeoff':
        return Icons.event_available;
      default:
        return Icons.description;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'leave':
        return 'Leave Request';
      case 'expense':
        return 'Expense Claim';
      case 'overtime':
        return 'Overtime Request';
      case 'timeoff':
        return 'Time Off';
      default:
        return 'Request';
    }
  }

  void _showRequestDetails(RequestItem request) {
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3E5C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${request.id}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
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
              icon: Icons.category,
              label: 'Type',
              value: _getTypeLabel(request.type),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.info_outline,
              label: 'Status',
              value: request.status.toUpperCase(),
              valueColor: _getStatusColor(request.status),
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Submitted',
              value: DateFormat('MMM d, yyyy').format(request.submittedDate),
            ),
            if (request.startDate != null) ...[
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.event,
                label: 'Period',
                value: request.endDate != null
                    ? '${DateFormat('MMM d').format(request.startDate!)} - ${DateFormat('MMM d, yyyy').format(request.endDate!)}'
                    : DateFormat('MMM d, yyyy').format(request.startDate!),
              ),
            ],
            if (request.days != null) ...[
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.access_time,
                label: 'Duration',
                value: '${request.days} day${request.days! > 1 ? 's' : ''}',
              ),
            ],
            if (request.amount != null) ...[
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.attach_money,
                label: 'Amount',
                value: '\$${request.amount!.toStringAsFixed(2)}',
                valueColor: const Color(0xFF2E7D95),
              ),
            ],
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.notes,
              label: 'Description',
              value: request.description,
            ),
            const SizedBox(height: 24),
            if (request.status == 'pending')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Cancel request logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request cancelled'),
                            backgroundColor: Colors.grey,
                          ),
                        );
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel Request'),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Edit request logic
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
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
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Close'),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _requestStats;

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
                            'My Requests',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            setState(() => _selectedFilter = value);
                          },
                          itemBuilder: (context) => _filterOptions
                              .map(
                                (filter) => PopupMenuItem(
                                  value: filter,
                                  child: Row(
                                    children: [
                                      if (_selectedFilter == filter)
                                        const Icon(
                                          Icons.check,
                                          color: Color(0xFF2E7D95),
                                        )
                                      else
                                        const SizedBox(width: 24),
                                      const SizedBox(width: 8),
                                      Text(filter),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  // Stats Cards
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Total',
                            count: stats['total']!,
                            color: const Color(0xFF2E7D95),
                            icon: Icons.list_alt,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Pending',
                            count: stats['pending']!,
                            color: const Color(0xFFED8936),
                            icon: Icons.pending_actions,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Approved',
                            count: stats['approved']!,
                            color: const Color(0xFF48BB78),
                            icon: Icons.check_circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  Container(
                    color: Colors.white.withOpacity(0.1),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      onTap: (_) => setState(() {
                        // Refresh filtered requests on tab change
                      }),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Leave'),
                        Tab(text: 'Expense'),
                        Tab(text: 'Overtime'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Requests List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(4, (tabIndex) {
                final filteredRequests = _getFilteredRequests(tabIndex);
                return filteredRequests.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No requests found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try changing the filter',
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
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, idx) {
                          final request = filteredRequests[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                                onTap: () => _showRequestDetails(request),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                request.status,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              _getTypeIcon(request.type),
                                              color: _getStatusColor(
                                                request.status,
                                              ),
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  request.title,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF2E3E5C),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _getTypeLabel(request.type),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                request.status,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              request.status.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: _getStatusColor(
                                                  request.status,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        request.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Submitted: ${DateFormat('MMM d, yyyy').format(request.submittedDate)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const Spacer(),
                                          if (request.days != null)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 14,
                                                  color: Colors.grey[500],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${request.days} day${request.days! > 1 ? 's' : ''}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (request.amount != null)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.attach_money,
                                                  size: 14,
                                                  color: Colors.grey[500],
                                                ),
                                                Text(
                                                  '\$${request.amount!.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF2E7D95),
                                                  ),
                                                ),
                                              ],
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
                      );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show new request options
          _showNewRequestOptions();
        },
        backgroundColor: const Color(0xFF2E7D95),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
    );
  }

  void _showNewRequestOptions() {
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
              'New Request',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3E5C),
              ),
            ),
            const SizedBox(height: 20),
            _NewRequestTile(
              icon: Icons.beach_access,
              title: 'Request Leave',
              subtitle: 'Vacation, sick leave, etc.',
              color: const Color(0xFF48BB78),
              onTap: () {
                Navigator.pop(context);
                // Navigate to request leave screen
              },
            ),
            _NewRequestTile(
              icon: Icons.receipt_long,
              title: 'Submit Expense',
              subtitle: 'Travel, meals, supplies',
              color: const Color(0xFFED8936),
              onTap: () {
                Navigator.pop(context);
                // Navigate to submit expense screen
              },
            ),
            _NewRequestTile(
              icon: Icons.access_time_filled,
              title: 'Overtime Request',
              subtitle: 'Request overtime approval',
              color: const Color(0xFF2E7D95),
              onTap: () {
                Navigator.pop(context);
                // Navigate to overtime request screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
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

class _NewRequestTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _NewRequestTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E3E5C),
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

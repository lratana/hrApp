import 'package:flutter/material.dart';
import 'package:flutter_application_1/appbar_decoration.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filterType = 'All';

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'type': 'leave',
      'icon': Icons.event_available,
      'color': const Color(0xFF10B981),
      'title': 'Leave Approved',
      'description': 'Your vacation leave from May 10–15 has been approved.',
      'timestamp': '5 min ago',
      'isRead': false,
    },
    {
      'id': 2,
      'type': 'task',
      'icon': Icons.assignment,
      'color': const Color(0xFF3B82F6),
      'title': 'New Task Assigned',
      'description': 'You have been assigned a new task by Jessica.',
      'timestamp': '1 hour ago',
      'isRead': false,
    },
    {
      'id': 3,
      'type': 'team',
      'icon': Icons.people,
      'color': const Color(0xFF8B5CF6),
      'title': 'Team Update',
      'description': 'Mike D. joined the Remote Development Team.',
      'timestamp': '3 hours ago',
      'isRead': false,
    },
    {
      'id': 4,
      'type': 'expense',
      'icon': Icons.attach_money,
      'color': const Color(0xFFF59E0B),
      'title': 'Expense Approved',
      'description': 'Your expense claim of \$240 has been approved.',
      'timestamp': 'Yesterday',
      'isRead': true,
    },
    {
      'id': 5,
      'type': 'system',
      'icon': Icons.notifications_active,
      'color': const Color(0xFFEF4444),
      'title': 'Meeting Reminder',
      'description': 'Team standup meeting starts in 30 minutes.',
      'timestamp': 'Yesterday',
      'isRead': true,
    },
    {
      'id': 6,
      'type': 'task',
      'icon': Icons.check_circle,
      'color': const Color(0xFF10B981),
      'title': 'Timesheet Submitted',
      'description':
          'Your timesheet for Week 2 has been submitted successfully.',
      'timestamp': 'Jan 12, 2026',
      'isRead': true,
    },
    {
      'id': 7,
      'type': 'leave',
      'icon': Icons.event_note,
      'color': const Color(0xFF6366F1),
      'title': 'Leave Request Pending',
      'description': 'Your leave request is awaiting manager approval.',
      'timestamp': 'Jan 11, 2026',
      'isRead': true,
    },
    {
      'id': 8,
      'type': 'system',
      'icon': Icons.info,
      'color': const Color(0xFF06B6D4),
      'title': 'System Maintenance',
      'description':
          'Scheduled system maintenance on Jan 20, 2026 from 2-4 AM.',
      'timestamp': 'Jan 10, 2026',
      'isRead': true,
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
  }

  void _toggleRead(int id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n['id'] == id);
      notification['isRead'] = !notification['isRead'];
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
    });
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_filterType == 'All') {
      return _notifications;
    }
    return _notifications
        .where((n) => n['type'] == _filterType.toLowerCase())
        .toList();
  }

  int get _unreadCount {
    return _notifications.where((n) => n['isRead'] == false).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Header
          Container(
            decoration: decoration(),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$_unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _markAllAsRead,
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Filter Chips
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildFilterChip('All'),
                        _buildFilterChip('Leave'),
                        _buildFilterChip('Task'),
                        _buildFilterChip('Team'),
                        _buildFilterChip('Expense'),
                        _buildFilterChip('System'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filterType == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filterType = label;
          });
        },
        backgroundColor: Colors.white.withOpacity(0.2),
        selectedColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF3B82C8) : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        checkmarkColor: const Color(0xFF3B82C8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    return Dismissible(
      key: Key(notification['id'].toString()),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        child: const Row(
          children: [
            Icon(Icons.check, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Mark as Read',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete, color: Colors.white, size: 28),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _toggleRead(notification['id']);
          return false;
        } else {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Notification'),
                content: const Text(
                  'Are you sure you want to delete this notification?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _deleteNotification(notification['id']);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Notification deleted')));
        }
      },
      child: GestureDetector(
        onTap: () {
          if (!isRead) {
            _toggleRead(notification['id']);
          }
          // Navigate to details page
        },
        onLongPress: () {
          _showNotificationOptions(context, notification);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRead
                  ? Colors.grey.withOpacity(0.2)
                  : const Color(0xFF3B82F6).withOpacity(0.3),
              width: isRead ? 1 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (notification['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  notification['icon'] as IconData,
                  color: notification['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notification['timestamp'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
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
    );
  }

  void _showNotificationOptions(
    BuildContext context,
    Map<String, dynamic> notification,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  notification['isRead']
                      ? Icons.mark_email_unread
                      : Icons.mark_email_read,
                  color: const Color(0xFF3B82F6),
                ),
                title: Text(
                  notification['isRead'] ? 'Mark as Unread' : 'Mark as Read',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _toggleRead(notification['id']);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteNotification(notification['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification deleted')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: Color(0xFF6B7280)),
                title: const Text('Archive'),
                onTap: () {
                  Navigator.pop(context);
                  // Archive functionality
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

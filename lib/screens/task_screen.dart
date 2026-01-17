// Tasks Screen
import 'package:flutter/material.dart';
import 'package:flutter_application_1/appbar_decoration.dart';
import 'package:flutter_application_1/screens/notification_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          decoration: decoration(),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Tasks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: const Text(
                                '2',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF2E7D95),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF2E7D95),
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Pending'),
                      Tab(text: 'Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTaskList(),
              _buildTaskList(),
              _buildCompletedList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          // Pending Tasks Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Pending Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Task Items
          _TaskCard(
            onTap: () => {},
            icon: Icons.description,
            iconColor: const Color(0xFF3182CE),
            iconBackground: const Color(0xFFBEE3F8),
            title: 'Complete Onboarding Forms',
            dueDate: 'Due Today',
            dueDateColor: const Color(0xFFED8936),
            dueDateBackground: const Color(0xFFED8936),
            assignedTo: 'Emily R.',
            priority: 'High',
          ),
          _TaskCard(
            onTap: () => {},
            icon: Icons.play_circle_outline,
            iconColor: const Color(0xFF3182CE),
            iconBackground: const Color(0xFFBEE3F8),
            title: 'Schedule Training Session',
            dueDate: 'Due Apr 28',
            dueDateColor: const Color(0xFF3182CE),
            dueDateBackground: const Color(0xFF3182CE),
            assignedTo: 'Mike D.',
            priority: null,
          ),
          _TaskCard(
            onTap: () => {},
            icon: Icons.check_circle_outline,
            iconColor: const Color(0xFF48BB78),
            iconBackground: const Color(0xFFC6F6D5),
            title: 'Review Weekly Timesheets',
            dueDate: 'Due Apr 30',
            dueDateColor: const Color(0xFF3182CE),
            dueDateBackground: const Color(0xFF3182CE),
            assignedTo: 'Sarah T.',
            priority: null,
          ),
          _TaskCard(
            onTap: () => {},
            icon: Icons.attach_money,
            iconColor: const Color(0xFFED8936),
            iconBackground: const Color(0xFFFFF5F0),
            title: 'Approve Expense Reports',
            dueDate: 'Due Apr 27',
            dueDateColor: const Color(0xFF48BB78),
            dueDateBackground: const Color(0xFF48BB78),
            assignedTo: 'Jessica',
            priority: null,
          ),
          _TaskCard(
            onTap: () => {},
            icon: Icons.description,
            iconColor: const Color(0xFF3182CE),
            iconBackground: const Color(0xFFBEE3F8),
            title: 'Update Employee Handbook',
            dueDate: 'Overdue',
            dueDateColor: const Color(0xFFED8936),
            dueDateBackground: const Color(0xFFED8936),
            assignedTo: 'David W.',
            priority: 'High',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCompletedList() {
    return const Center(child: Text('No completed tasks'));
  }
}

class _TaskCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String dueDate;
  final Color dueDateColor;
  final Color dueDateBackground;
  final String assignedTo;
  final String? priority;
  final Function()? onTap;
  const _TaskCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.dueDate,
    required this.dueDateColor,
    required this.dueDateBackground,
    required this.assignedTo,
    this.priority,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
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
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: dueDateBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            dueDate,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dueDate,
                      style: TextStyle(
                        fontSize: 14,
                        color: dueDateColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Assigned to $assignedTo',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        if (priority != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.flag,
                                  size: 14,
                                  color: Color(0xFFED8936),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  priority!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFED8936),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.grey[600],
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
}

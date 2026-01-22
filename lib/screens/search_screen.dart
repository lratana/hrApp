import 'package:flutter/material.dart';
import 'package:flutter_application_1/appbar_decoration.dart';

class SearchResult {
  final String id;
  final String type; // 'employee', 'request', 'document', 'task', 'leave'
  final String title;
  final String subtitle;
  final String? description;
  final IconData icon;
  final Color color;

  SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.description,
    required this.icon,
    required this.color,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isSearching = false;

  final List<String> _filterCategories = [
    'All',
    'Employees',
    'Requests',
    'Documents',
    'Tasks',
  ];

  // Sample search data
  final List<SearchResult> _allResults = [
    SearchResult(
      id: '1',
      type: 'employee',
      title: 'Jessica Martinez',
      subtitle: 'HR Manager',
      description: 'Human Resources Department',
      icon: Icons.person,
      color: const Color(0xFF2E7D95),
    ),
    SearchResult(
      id: '2',
      type: 'employee',
      title: 'John Smith',
      subtitle: 'Senior Developer',
      description: 'Engineering Department',
      icon: Icons.person,
      color: const Color(0xFF2E7D95),
    ),
    SearchResult(
      id: '3',
      type: 'request',
      title: 'Vacation Leave Request',
      subtitle: 'REQ-001 • Pending',
      description: 'May 10 - May 15, 2026',
      icon: Icons.beach_access,
      color: const Color(0xFF48BB78),
    ),
    SearchResult(
      id: '4',
      type: 'request',
      title: 'Expense Claim - Travel',
      subtitle: 'REQ-005 • Approved',
      description: '\$450.00',
      icon: Icons.receipt_long,
      color: const Color(0xFFED8936),
    ),
    SearchResult(
      id: '5',
      type: 'document',
      title: 'Employee Handbook 2026',
      subtitle: 'Policy Document',
      description: 'Updated January 2026',
      icon: Icons.description,
      color: const Color(0xFF9F7AEA),
    ),
    SearchResult(
      id: '6',
      type: 'document',
      title: 'Timesheet Policy',
      subtitle: 'HR Policy',
      description: 'Timesheet submission guidelines',
      icon: Icons.policy,
      color: const Color(0xFF9F7AEA),
    ),
    SearchResult(
      id: '7',
      type: 'task',
      title: 'Complete Q1 Performance Review',
      subtitle: 'Due: Feb 15, 2026',
      description: 'High Priority',
      icon: Icons.task_alt,
      color: const Color(0xFF4A90E2),
    ),
    SearchResult(
      id: '8',
      type: 'task',
      title: 'Submit Monthly Report',
      subtitle: 'Due: Jan 31, 2026',
      description: 'Medium Priority',
      icon: Icons.assignment,
      color: const Color(0xFF4A90E2),
    ),
    SearchResult(
      id: '9',
      type: 'employee',
      title: 'Sarah Johnson',
      subtitle: 'Marketing Director',
      description: 'Marketing Department',
      icon: Icons.person,
      color: const Color(0xFF2E7D95),
    ),
    SearchResult(
      id: '10',
      type: 'request',
      title: 'Sick Leave Request',
      subtitle: 'REQ-003 • Approved',
      description: 'Jan 12, 2026',
      icon: Icons.medical_services,
      color: const Color(0xFF48BB78),
    ),
  ];

  List<String> get _recentSearches => [
    'vacation leave',
    'timesheet',
    'expense report',
    'employee handbook',
  ];

  List<String> get _popularSearches => [
    'Leave balance',
    'Payslip',
    'Team directory',
    'Company policies',
    'Benefits',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SearchResult> get _filteredResults {
    if (_searchQuery.isEmpty) return [];

    var results = _allResults.where((result) {
      final matchesQuery =
          result.title.toLowerCase().contains(_searchQuery) ||
          result.subtitle.toLowerCase().contains(_searchQuery) ||
          (result.description?.toLowerCase().contains(_searchQuery) ?? false);

      if (_selectedFilter == 'All') return matchesQuery;

      final matchesFilter =
          _selectedFilter.toLowerCase() == '${result.type}s' ||
          (_selectedFilter == 'Employees' && result.type == 'employee') ||
          (_selectedFilter == 'Requests' && result.type == 'request') ||
          (_selectedFilter == 'Documents' && result.type == 'document') ||
          (_selectedFilter == 'Tasks' && result.type == 'task');

      return matchesQuery && matchesFilter;
    }).toList();

    return results;
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _isSearching = query.isNotEmpty;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _isSearching = false;
    });
  }

  void _selectSearchSuggestion(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header with search bar
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
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: _performSearch,
                              decoration: InputDecoration(
                                hintText: 'Search HR Portal...',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF2E7D95),
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: _clearSearch,
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Filter chips
                  if (_isSearching)
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filterCategories.length,
                        itemBuilder: (context, index) {
                          final filter = _filterCategories[index];
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() => _selectedFilter = filter);
                              },
                              backgroundColor: Colors.white.withOpacity(0.2),
                              selectedColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF2E7D95)
                                    : Colors.grey,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Search results or suggestions
          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : _buildSearchSuggestions(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or filters',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredResults.length,
      itemBuilder: (context, index) {
        final result = _filteredResults[index];
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
              onTap: () {
                // Navigate to detail screen based on type
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${result.title}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: result.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(result.icon, color: result.color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3E5C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            result.subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (result.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              result.description!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.history, color: Color(0xFF2E7D95), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._recentSearches.map(
              (search) => _SearchSuggestionTile(
                icon: Icons.history,
                title: search,
                onTap: () => _selectSearchSuggestion(search),
                onDelete: () {
                  // Remove from recent searches
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Popular Searches
          Row(
            children: [
              const Icon(Icons.trending_up, color: Color(0xFF2E7D95), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Popular Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((search) {
              return ActionChip(
                label: Text(search),
                onPressed: () => _selectSearchSuggestion(search),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey[300]!),
                labelStyle: const TextStyle(color: Color(0xFF2E3E5C)),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Quick Access Categories
          const Row(
            children: [
              Icon(Icons.grid_view, color: Color(0xFF2E7D95), size: 20),
              SizedBox(width: 8),
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _QuickAccessCard(
                icon: Icons.people,
                title: 'Employees',
                color: const Color(0xFF2E7D95),
                onTap: () => _selectSearchSuggestion('employees'),
              ),
              _QuickAccessCard(
                icon: Icons.description,
                title: 'Documents',
                color: const Color(0xFF9F7AEA),
                onTap: () => _selectSearchSuggestion('documents'),
              ),
              _QuickAccessCard(
                icon: Icons.task_alt,
                title: 'Tasks',
                color: const Color(0xFF4A90E2),
                onTap: () => _selectSearchSuggestion('tasks'),
              ),
              _QuickAccessCard(
                icon: Icons.beach_access,
                title: 'Leave',
                color: const Color(0xFF48BB78),
                onTap: () => _selectSearchSuggestion('leave'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchSuggestionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _SearchSuggestionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3E5C),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

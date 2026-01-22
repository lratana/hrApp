import 'package:flutter/material.dart';
import 'package:flutter_application_1/appbar_decoration.dart';
import 'package:flutter_application_1/providers/textsize_logic.dart';
import 'package:flutter_application_1/providers/theme_logic.dart';
import 'package:flutter_application_1/screens/notification_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeLogic, TextsizeLogic>(
      builder: (context, themeLogic, textsizeLogic, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Column(
            children: [
              // Header
              Container(
                decoration: decoration(),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
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
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // User Profile Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(
                                0xFFFF6B6B,
                              ).withOpacity(0.2),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xFFFF6B6B),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ratana',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'HR Manager',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4A90D9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'In Office',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Contact Details Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF2D3748),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Ratana.long814@gmail.com",
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Phone
                            Text(
                              'Phone',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF2D3748),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "+855 96 72 75 814",
                                        prefixIcon: Icon(
                                          Icons.phone_outlined,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Department
                            Text(
                              'Department',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2D3748),
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Human Resources",
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Location
                            Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2D3748),
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phnom Penh, Cambodia",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Settings Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingsItem(
                              icon: Icons.notifications_outlined,
                              title: 'Notifications',
                              onTap: () {
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                );
                              },
                            ),
                            Divider(height: 1, color: Colors.grey[200]),
                            _buildSettingsItem(
                              icon: Icons.lock_outline,
                              title: 'Change Password',
                              onTap: () {},
                            ),
                            Divider(height: 1, color: Colors.grey[200]),
                            _buildSettingsItem(
                              icon: Icons.mode_night_outlined,
                              title: 'Settings Mode',
                              onTap: () {
                                // Handle settings mode tap
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Settings Mode'),
                                      content: const Text(
                                        'Select your preferred theme mode.',
                                      ),
                                      actions: [
                                        ListTile(
                                          title: const Text('Light Mode'),
                                          leading: const Icon(Icons.light_mode),
                                          trailing: Icon(
                                            themeLogic.themeIndex == 2
                                                ? Icons.check_circle
                                                : null,
                                          ),
                                          onTap: () {
                                            themeLogic.changeToLight();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('Dark Mode'),
                                          leading: const Icon(Icons.dark_mode),
                                          trailing: Icon(
                                            themeLogic.themeIndex == 1
                                                ? Icons.check_circle
                                                : null,
                                          ),
                                          onTap: () {
                                            themeLogic.changeToDark();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('System Mode'),
                                          leading: Icon(Icons.settings),
                                          trailing: Icon(
                                            themeLogic.themeIndex == 0
                                                ? Icons.check_circle
                                                : null,
                                          ),
                                          onTap: () {
                                            themeLogic.changeToSystem();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            Divider(height: 1, color: Colors.grey[200]),
                            _buildSettingsItem(
                              icon: Icons.text_fields_outlined,
                              title: 'Font Size',
                              onTap: () {
                                // Handle font size tap
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Font Size'),
                                      content: const Text(
                                        'Adjust the font size for better readability.',
                                      ),

                                      actions: [
                                        _buildFontSizeSlider(),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            Divider(height: 1, color: Colors.grey[200]),
                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                // Handle logout action
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _currentScale = 1;

  Widget _buildFontSizeSlider() {
    _currentScale = context.read<TextsizeLogic>().scaleIndex.toDouble();
    int div = TextsizeLogic.MAX_SCALE - TextsizeLogic.MIN_SCALE;
    return Slider(
      value: _currentScale,
      min: TextsizeLogic.MIN_SCALE.toDouble(),
      max: TextsizeLogic.MAX_SCALE.toDouble(),
      divisions: div,
      label: _currentScale.toInt().toString(),
      onChanged: (value) {
        setState(() {
          _currentScale = value;
        });
        context.read<TextsizeLogic>().changeScaleIndex(value.toInt());
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4A90D9), size: 24),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

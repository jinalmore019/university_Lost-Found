import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../admin/admin_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person, size: 40),
            title: Text(user.name),
            subtitle: Text(user.email),
          ),
          const Divider(),
          const Text('My Posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                if (user.role == 'admin') ...[
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings, color: Colors.red),
                    title: const Text('Admin Dashboard', style: TextStyle(color: Colors.red)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
                    },
                  ),
                  const Divider(),
                ],
                const ListTile(
                  title: Text('Lost: Blue Backpack'),
                  subtitle: Text('Status: Pending'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                const ListTile(
                  title: Text('Found: Calculator'),
                  subtitle: Text('Status: Returned'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

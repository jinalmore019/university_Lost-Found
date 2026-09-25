import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _userCount = 0;
  int _lostCount = 0;
  int _foundCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLiveStats();
  }

  Future<void> _fetchLiveStats() async {
    try {
      final usersSnap = await FirebaseFirestore.instance.collection('users').get();
      final lostSnap = await FirebaseFirestore.instance.collection('lost_items').get();
      final foundSnap = await FirebaseFirestore.instance.collection('found_items').get();

      if (mounted) {
        setState(() {
          _userCount = usersSnap.docs.length;
          _lostCount = lostSnap.docs.length;
          _foundCount = foundSnap.docs.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Live System Statistics',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: _buildStatCards(),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Claims Management is coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.gavel),
                    label: const Text('Manage Claims'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User Management is coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.people),
                    label: const Text('Manage Users'),
                  ),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildStatCards() {
    final stats = [
      {'title': 'Total Users', 'count': _userCount.toString(), 'icon': Icons.person, 'color': Colors.blue},
      {'title': 'Lost Items', 'count': _lostCount.toString(), 'icon': Icons.search_off, 'color': Colors.red},
      {'title': 'Found Items', 'count': _foundCount.toString(), 'icon': Icons.check_circle_outline, 'color': Colors.green},
      {'title': 'Pending Claims', 'count': '0', 'icon': Icons.pending_actions, 'color': Colors.orange},
    ];

    return stats.map((stat) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(stat['icon'] as IconData, size: 40, color: stat['color'] as Color),
            const SizedBox(height: 8),
            Text(
              stat['count'] as String,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(stat['title'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      );
    }).toList();
  }
}

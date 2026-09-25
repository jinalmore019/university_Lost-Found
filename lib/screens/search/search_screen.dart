import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _filterStatus = 'All'; // 'All', 'Lost', 'Found'

  void _performSearch() {
    // In a real app, query ItemProvider or Firestore
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Searching for "${_searchController.text}" in $_filterStatus items...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search keywords...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filterStatus,
                  items: <String>['All', 'Lost', 'Found'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _filterStatus = val!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('Search'),
            ),
            const Divider(),
            const Expanded(
              child: Center(child: Text('Search results will appear here.')),
            )
          ],
        ),
      ),
    );
  }
}

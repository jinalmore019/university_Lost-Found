import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/item_provider.dart';
import 'claim_item_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Color(0xFF6366F1),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Lost Items'),
              Tab(text: 'Found Items'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildLostItems(context),
                _buildFoundItems(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLostItems(BuildContext context) {
    final items = Provider.of<ItemProvider>(context).lostItems;
    if (items.isEmpty) {
      return const Center(child: Text("No lost items reported."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lost: ${item.itemName}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.grey),
                      onPressed: () {
                        Share.share('I found a missing ${item.itemName} at ${item.location}. Check the DDU Lost & Found App!');
                      },
                    )
                  ],
                ),
                Text('Category: ${item.category} | Color: ${item.color}'),
                Text('Location: ${item.location}'),
                Text('Date: ${item.lostDate.toLocal().toString().split(' ')[0]}'),
                const SizedBox(height: 8),
                Text(item.description, style: const TextStyle(color: Colors.grey)),
                if (item.imageUrl.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(item.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                ],
                const SizedBox(height: 16),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(item.ownerId).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final userMap = snapshot.data!.data() as Map<String, dynamic>?;
                    if (userMap == null) return const SizedBox();
                    final phone = userMap['phone'] ?? '';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => launchUrl(Uri.parse('tel:$phone')),
                          icon: const Icon(Icons.call, color: Colors.green),
                          label: const Text('Call'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => launchUrl(Uri.parse('https://wa.me/$phone')),
                          icon: const Icon(Icons.chat),
                          label: const Text('WhatsApp'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFoundItems(BuildContext context) {
    final items = Provider.of<ItemProvider>(context).foundItems;
    if (items.isEmpty) {
      return const Center(child: Text("No found items reported."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Found: ${item.category}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.grey),
                      onPressed: () {
                        Share.share('A ${item.category} was found at ${item.location}. Claim it on the DDU Lost & Found App!');
                      },
                    )
                  ],
                ),
                Text('Location: ${item.location}'),
                Text('Date: ${item.foundDate.toLocal().toString().split(' ')[0]}'),
                const SizedBox(height: 8),
                Text(item.publicDescription, style: const TextStyle(color: Colors.grey)),
                if (item.imageUrl.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(item.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                ],
                const SizedBox(height: 16),
                if (!item.publicDescription.contains('📍 Item is deposited at:'))
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClaimItemScreen(item: item),
                          ),
                        );
                      },
                      child: const Text('Claim This Item'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

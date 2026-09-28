import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/models.dart';

class ManageClaimsScreen extends StatelessWidget {
  const ManageClaimsScreen({super.key});

  void _sendNotification(String userId, String title, String body) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': userId,
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  void _updateClaimStatus(BuildContext context, Claim claim, String newStatus) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      
      final claimRef = FirebaseFirestore.instance.collection('claims').doc(claim.claimId);
      batch.update(claimRef, {'status': newStatus});

      if (newStatus == 'APPROVED') {
        final itemRef = FirebaseFirestore.instance.collection('found_items').doc(claim.itemId);
        batch.update(itemRef, {'status': 'CLAIM_APPROVED'});
        
        // Notify Claimant
        _sendNotification(
          claim.claimantId,
          'Claim Approved!',
          'Your claim for a found item has been approved. You can now contact the finder.',
        );
        
        // Notify Finder
        _sendNotification(
          claim.finderId,
          'Item Claimed!',
          'Someone has successfully claimed the item you found. Please check your items to coordinate handover.',
        );
      } else if (newStatus == 'REJECTED') {
         final itemRef = FirebaseFirestore.instance.collection('found_items').doc(claim.itemId);
         batch.update(itemRef, {'status': 'FOUND'}); // Revert to found
         
         // Notify Claimant
         _sendNotification(
          claim.claimantId,
          'Claim Rejected',
          'Your claim for a found item was rejected by the admin. The answers did not match.',
        );
      }

      await batch.commit();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Claim $newStatus')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Claims'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('claims').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading claims'));
          }
          
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No claims found'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final claim = Claim.fromMap(doc.data() as Map<String, dynamic>, doc.id);
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Claim ID: ${claim.claimId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text('Status: ${claim.status}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: claim.status == 'PENDING' ? Colors.orange : (claim.status == 'APPROVED' ? Colors.green : Colors.red)
                      )),
                      const SizedBox(height: 8),
                      const Text('Answers provided:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...claim.answers.map((a) => Text('- $a')).toList(),
                      const SizedBox(height: 12),
                      if (claim.status == 'PENDING')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _updateClaimStatus(context, claim, 'REJECTED'),
                              child: const Text('Reject', style: TextStyle(color: Colors.red)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                              onPressed: () => _updateClaimStatus(context, claim, 'APPROVED'),
                              child: const Text('Approve'),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

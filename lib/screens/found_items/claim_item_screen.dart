import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/models.dart';

class ClaimItemScreen extends StatefulWidget {
  final FoundItem item;
  const ClaimItemScreen({super.key, required this.item});

  @override
  _ClaimItemScreenState createState() => _ClaimItemScreenState();
}

class _ClaimItemScreenState extends State<ClaimItemScreen> {
  final List<TextEditingController> _answerControllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.item.verificationQuestions.length; i++) {
      _answerControllers.add(TextEditingController());
    }
  }

  void _submitClaim() async {
    int score = 0;
    List<String> userAnswers = [];
    for (var i = 0; i < widget.item.verificationQuestions.length; i++) {
      String answer = _answerControllers[i].text.trim();
      userAnswers.add(answer);
      if (answer.toLowerCase() ==
          widget.item.verificationQuestions[i].answer.toLowerCase()) {
        score++;
      }
    }

    // Determine status (For now, let's keep it PENDING so admin can review)
    String resultText;
    if (score == widget.item.verificationQuestions.length) {
      resultText = '✅ Verification Passed! Claim submitted to admin.';
    } else if (score > 0) {
      resultText = '⚠️ Partial match. Additional verification required.';
    } else {
      resultText = '❌ Verification Failed. Weak Match but submitted for admin review.';
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Claim newClaim = Claim(
          claimId: '', // Firebase will generate
          itemId: widget.item.itemId,
          claimantId: user.uid,
          finderId: widget.item.finderId,
          answers: userAnswers,
          status: 'PENDING',
          contactShared: false,
          finderHandoverConfirm: false,
          claimantHandoverConfirm: false,
          createdAt: DateTime.now(),
        );

        await FirebaseFirestore.instance.collection('claims').add(newClaim.toMap());
        
        // Change status of item to CLAIM_PENDING
        await FirebaseFirestore.instance.collection('found_items').doc(widget.item.itemId).update({'status': 'CLAIM_PENDING'});
        
        // Notify Admins
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': 'admin', // assuming a way to query admin notifications
          'title': 'New Claim Submitted',
          'body': 'A new claim was submitted for item: ${widget.item.category}',
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e) {
      print('Error saving claim: $e');
      resultText = '❌ Error submitting claim. Please try again.';
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Verification Result'),
          content: Text(resultText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // close screen
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ownership Verification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Answer these questions to prove ownership for the ${widget.item.category}.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...widget.item.verificationQuestions.asMap().entries.map((entry) {
              int index = entry.key;
              VerificationQuestion q = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _answerControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Q${index + 1}: ${q.question}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitClaim,
              child: const Text('Submit Claim'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
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

  void _submitClaim() {
    int score = 0;
    for (var i = 0; i < widget.item.verificationQuestions.length; i++) {
      if (_answerControllers[i].text.trim().toLowerCase() ==
          widget.item.verificationQuestions[i].answer.toLowerCase()) {
        score++;
      }
    }

    String resultText;
    if (score == widget.item.verificationQuestions.length) {
      resultText = '✅ Verification Passed! Claim submitted to admin.';
    } else if (score > 0) {
      resultText = '⚠️ Partial match. Additional verification required.';
    } else {
      resultText = '❌ Verification Failed. Weak Match.';
    }

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

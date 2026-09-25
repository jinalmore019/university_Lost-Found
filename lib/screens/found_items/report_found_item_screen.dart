import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../providers/auth_provider.dart';
import '../../providers/item_provider.dart';
import '../../models/models.dart';

class ReportFoundItemScreen extends StatefulWidget {
  const ReportFoundItemScreen({super.key});

  @override
  _ReportFoundItemScreenState createState() => _ReportFoundItemScreenState();
}

class _ReportFoundItemScreenState extends State<ReportFoundItemScreen> {
  final _categoryController = TextEditingController();
  final _publicDescriptionController = TextEditingController();
  String _selectedLocation = 'CE Department';
  final List<String> _locations = [
    'CE Department',
    'IT Department',
    'EC Department',
    'IC Department',
    'CH Department',
    'CL Department',
    'MBA Department',
    'Library',
    'Canteen',
    'Main Ground',
    'Admin Block',
    'Hostel',
    'Other'
  ];

  String _depositLocation = 'Kept with me';
  final List<String> _depositLocations = [
    'Kept with me',
    'Deposited at Library',
    'Deposited at Security Desk',
    'Deposited at HOD Office',
    'Deposited at Admin Block'
  ];

  final List<Map<String, TextEditingController>> _questions = [];
  File? _image;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  void _addQuestion() {
    setState(() {
      _questions.add({
        'question': TextEditingController(),
        'answer': TextEditingController(),
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() async {
    if (_categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Category')));
      return;
    }

    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user == null) return;

    setState(() {
      _isUploading = true;
    });

    String imageUrl = '';
    try {
      if (_image != null) {
        final bytes = await _image!.readAsBytes();
        final base64Image = base64Encode(bytes);
        
        final response = await http.post(
          Uri.parse('https://api.imgbb.com/1/upload'),
          body: {
            'key': '301129267137aa212463f1631c6592f3',
            'image': base64Image,
          },
        );
        
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          imageUrl = jsonResponse['data']['url'];
        } else {
          throw Exception('Failed to upload image');
        }
      }

      List<VerificationQuestion> vqs = _questions.map((q) {
        return VerificationQuestion(question: q['question']!.text, answer: q['answer']!.text);
      }).toList();

      String finalDescription = _publicDescriptionController.text;
      if (_depositLocation != 'Kept with me') {
        finalDescription += '\n\n📍 Item is deposited at: $_depositLocation';
        
        if (_depositLocation == 'Deposited at HOD Office') {
          finalDescription += '\n📞 Please contact the respective HOD Sir to collect your item.';
        } else if (_depositLocation == 'Deposited at Admin Block') {
          finalDescription += '\n📞 Please contact the Admin Office to collect your item.';
        } else if (_depositLocation == 'Deposited at Library') {
          finalDescription += '\n📞 Please contact the Librarian to collect your item.';
        } else if (_depositLocation == 'Deposited at Security Desk') {
          finalDescription += '\n📞 Please contact the Security Guard to collect your item.';
        }
      }

      final newItem = FoundItem(
        itemId: '',
        finderId: user.userId,
        category: _categoryController.text,
        location: _selectedLocation,
        foundDate: DateTime.now(),
        publicDescription: finalDescription,
        imageUrl: imageUrl,
        status: 'FOUND',
        verificationQuestions: vqs,
      );

      await Provider.of<ItemProvider>(context, listen: false).addFoundItem(newItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Found Item Reported Successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Found Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Public Information (Visible to everyone)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Upload Item Photo (Optional)', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category (e.g., Pouch)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedLocation,
              decoration: const InputDecoration(labelText: 'Location Found', border: OutlineInputBorder()),
              items: _locations.map((String val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedLocation = val!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _publicDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Public Description',
                hintText: 'Keep it vague. Do NOT reveal exact color or brand.',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _depositLocation,
              decoration: const InputDecoration(labelText: 'Where is the item currently?', border: OutlineInputBorder()),
              items: _depositLocations.map((String val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _depositLocation = val!;
                });
              },
            ),
            if (_depositLocation == 'Kept with me') ...[
              const SizedBox(height: 24),
              const Text(
                'Private Verification Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Add questions that only the true owner can answer.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ..._questions.asMap().entries.map((entry) {
                int index = entry.key;
                var q = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Question ${index + 1}'),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _questions.removeAt(index);
                                });
                              },
                            )
                          ],
                        ),
                        TextField(
                          controller: q['question'],
                          decoration: const InputDecoration(labelText: 'Question'),
                        ),
                        TextField(
                          controller: q['answer'],
                          decoration: const InputDecoration(labelText: 'Expected Answer'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Add Question'),
              ),
            ],
            const SizedBox(height: 24),
            _isUploading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Submit Found Report', style: TextStyle(fontSize: 16)),
                  ),
          ],
        ),
      ),
    );
  }
}

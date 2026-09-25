import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../providers/auth_provider.dart';
import '../../providers/item_provider.dart';
import '../../models/models.dart';

class ReportLostItemScreen extends StatefulWidget {
  const ReportLostItemScreen({super.key});

  @override
  _ReportLostItemScreenState createState() => _ReportLostItemScreenState();
}

class _ReportLostItemScreenState extends State<ReportLostItemScreen> {
  final _itemNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _colorController = TextEditingController();
  final _descriptionController = TextEditingController();
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

  File? _image;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

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
    if (_itemNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Item Name')));
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

      final newItem = LostItem(
        itemId: '',
        ownerId: user.userId,
        itemName: _itemNameController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
        color: _colorController.text,
        location: _selectedLocation,
        lostDate: DateTime.now(),
        imageUrl: imageUrl,
        status: 'LOST',
      );

      await Provider.of<ItemProvider>(context, listen: false).addLostItem(newItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lost Item Reported Successfully!')),
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
      appBar: AppBar(title: const Text('Report Lost Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Provide as much detail as possible to help us find a match.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
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
            TextField(controller: _itemNameController, decoration: const InputDecoration(labelText: 'Item Name (e.g., Wallet)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category (e.g., Personal)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _colorController, decoration: const InputDecoration(labelText: 'Color (e.g., Black)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedLocation,
              decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
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
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3),
            const SizedBox(height: 24),
            _isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Submit Lost Report', style: TextStyle(fontSize: 16)),
                  ),
          ],
        ),
      ),
    );
  }
}

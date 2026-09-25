import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class ItemProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<FoundItem> _foundItems = [];
  List<LostItem> _lostItems = [];
  bool _isLoading = false;

  List<FoundItem> get foundItems => _foundItems;
  List<LostItem> get lostItems => _lostItems;
  bool get isLoading => _isLoading;

  ItemProvider() {
    fetchFoundItems();
    fetchLostItems();
  }

  Future<void> fetchFoundItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('found_items').get();
      _foundItems = snapshot.docs.map((doc) => FoundItem.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Error fetching found items: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchLostItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('lost_items').get();
      _lostItems = snapshot.docs.map((doc) => LostItem.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Error fetching lost items: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFoundItem(FoundItem item) async {
    try {
      await _firestore.collection('found_items').add(item.toMap());
      await fetchFoundItems();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addLostItem(LostItem item) async {
    try {
      await _firestore.collection('lost_items').add(item.toMap());
      await fetchLostItems();
    } catch (e) {
      print(e);
    }
  }
}

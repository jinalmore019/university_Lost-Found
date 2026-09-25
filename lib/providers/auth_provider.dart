import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  String _getRoleFromEmail(String email) {
    final lowerEmail = email.toLowerCase();
    if (lowerEmail.contains('admin') || 
        lowerEmail.contains('security') || 
        lowerEmail.contains('hod') || 
        lowerEmail.contains('library') || 
        lowerEmail.contains('librarian')) {
      return 'admin';
    }
    return 'user';
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        final doc = await _firestore.collection('users').doc(cred.user!.uid).get();
        if (doc.exists) {
          _currentUser = UserModel.fromMap(doc.data()!, doc.id);
        } else {
          _currentUser = UserModel(
            userId: cred.user!.uid,
            name: cred.user!.displayName ?? 'User',
            email: email,
            phone: '',
            role: _getRoleFromEmail(email),
            createdAt: DateTime.now(),
          );
        }
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
    return "Login failed. Please check credentials.";
  }

  Future<String?> register(String name, String email, String phone, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        await cred.user!.updateDisplayName(name);
        
        // Save to Firestore so other users can see contact info
        UserModel newUser = UserModel(
          userId: cred.user!.uid,
          name: name,
          email: email,
          phone: phone,
          role: _getRoleFromEmail(email),
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(newUser.toMap());

        // User wants to login manually after registration
        await _auth.signOut();
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
    return "Registration failed. Please try again.";
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}

// lib/services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user ID
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Fetch user data
  static Future<Map<String, dynamic>> fetchUserData() async {
    String? userId = getCurrentUserId();
    if (userId == null) {
      return {'firstName': ''};
    }
    try {
      final userDoc = await _firestore.collection("users").doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return {'firstName': ''};
    } on FirebaseException catch (e) {
      // Common: permission-denied when Firestore rules block reads
      return {
        'firstName': _auth.currentUser?.displayName ?? '',
        '_error': e.code,
      };
    } catch (e) {
      return {'firstName': _auth.currentUser?.displayName ?? ''};
    }
  }

  // Sign out user
  static Future<void> logout() async {
    await _auth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteGuard {
  /// Memeriksa akses berdasarkan peran (role)
  /// [requiredRole]: 'matrix_owner', 'seller', dll.
  static Future<String?> checkAccess(BuildContext context, GoRouterState state, String requiredRole) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String currentPath = state.matchedLocation;

    // 1. Jika belum login, arahkan ke login
    if (currentUser == null) {
      return currentPath == '/login' ? null : '/login';
    }

    // 2. Ambil data user dari Firestore untuk cek role
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final String userRole = userDoc.exists ? (userDoc.get('role') ?? '') : '';

      // 3. Jika role tidak sesuai, logout paksa dan ke login
      if (userRole != requiredRole) {
        await FirebaseAuth.instance.signOut();
        return '/login';
      }
    } catch (e) {
      debugPrint('Error pengecekan role: $e');
      return '/login';
    }

    // 4. Jika semua valid, akses diizinkan
    return null;
  }
}
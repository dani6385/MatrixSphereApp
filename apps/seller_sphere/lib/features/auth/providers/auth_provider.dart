
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_sphere/models/shop_model.dart';
import 'package:seller_sphere/services/firebase_rtdb_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();

  User? _user;
  Shop? _shop;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDemoMode = false;

  User? get user => _user;
  Shop? get shop => _shop;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isDemoMode => _isDemoMode;

  AuthProvider() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      _user = firebaseUser;
      if (_user != null) {
        _listenToShopData(_user!.uid);
      } else {
        // Jika logout, pastikan mode demo juga nonaktif
        _shop = null;
        notifyListeners();
      }
    });
  }

  void _listenToShopData(String userId) {
    _rtdbService.getShopStreamByUid(userId).listen((shop) {
      _shop = shop;
      notifyListeners();
    });
  }

  void enterDemoMode() {
    _isDemoMode = true;
    _user = null; // Pastikan tidak ada user yang login saat mode demo
    _shop = null;
    notifyListeners();
  }

  void exitDemoMode() {
    _isDemoMode = false;
    notifyListeners();
  }

  Future<void> _setLoading(bool value) async {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, String shopName) async {
    await _setLoading(true);
    _setErrorMessage(null);
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      if (_user != null) {
        // Create a new shop entry in Realtime Database
        final newShop = Shop(
          id: _user!.uid,
          ownerId: _user!.uid,
          name: shopName,
          email: email,
          createdAt: DateTime.now(),
        );
        await _rtdbService.createShop(newShop);
        _shop = newShop;
      }
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(e.message);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      await _setLoading(false);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _setLoading(true);
    _setErrorMessage(null);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      if (_user != null) {
        _listenToShopData(_user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(e.message);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      await _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _setLoading(true);
    _setErrorMessage(null);
    try {
      await _auth.signOut();
      _user = null;
      _shop = null;
      _isDemoMode = false; // Keluar dari mode demo saat sign out
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(e.message);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      await _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    await _setLoading(true);
    _setErrorMessage(null);
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(e.message);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      await _setLoading(false);
    }
  }
}
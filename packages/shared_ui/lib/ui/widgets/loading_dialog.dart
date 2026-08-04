
import 'package:flutter/material.dart';

class LoadingDialog {
  static  bool _isShowing = false;
  static BuildContext? _dialogContext;
  static void show(BuildContext context) {
    if (_isShowing) {
      return;
    }
    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        _dialogContext = dialogContext;
        return const PopScope(
          canPop: false, // Prevent dialog from being dismissed by back button
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    if (_isShowing && _dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
      _isShowing = false;
      _dialogContext = null;
    }
  }
}
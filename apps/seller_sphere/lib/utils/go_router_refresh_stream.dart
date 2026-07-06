import 'dart:async';
import 'package:flutter/foundation.dart';

/// A [Listenable] that notifies listeners when a [Stream] emits a value.
///
/// This is used to trigger a GoRouter redirect when the authentication state
/// changes.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream].
  ///
  /// Every time the [stream] emits a value, this [ChangeNotifier] will notify
  /// its listeners.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

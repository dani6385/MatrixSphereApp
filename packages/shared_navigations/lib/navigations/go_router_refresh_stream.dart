import 'dart:async';

import 'package:flutter/foundation.dart';

/// A [Listenable] that notifies listeners when a [Stream] emits a value.
///
/// This class is useful for using a stream with APIs that require a [Listenable].
/// For example, it can be used to trigger a refresh of a GoRouter when a
/// stream (like authentication state changes) emits a new value.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream] that listens to the given [stream].
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
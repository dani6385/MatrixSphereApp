import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Enum untuk menentukan arah animasi geser (slide).
enum SlideDirection { left, right, top, bottom }

/// Kelas transisi kustom untuk membuat halaman yang masuk dengan animasi geser (slide) dari kanan.
///
/// Ini membungkus `CustomTransitionPage` untuk membuatnya dapat digunakan kembali.
class SlideTransitionPage<T> extends CustomTransitionPage<T> {
  SlideTransitionPage({
    required super.child,
    this.direction = SlideDirection.right, // Default ke kanan
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Tentukan offset awal berdasarkan arah yang dipilih
            late final Offset begin;
            switch (direction) {
              case SlideDirection.left:
                begin = const Offset(-1.0, 0.0);
                break;
              case SlideDirection.right:
                begin = const Offset(1.0, 0.0);
                break;
              case SlideDirection.top:
                begin = const Offset(0.0, -1.0);
                break;
              case SlideDirection.bottom:
                begin = const Offset(0.0, 1.0);
                break;
            }

            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.easeInOut));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

  final SlideDirection direction;
}

/// Kelas transisi kustom untuk membuat halaman yang masuk dengan animasi memudar (fade).
class FadeTransitionPage<T> extends CustomTransitionPage<T> {
  FadeTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeIn).animate(animation),
              child: child,
            );
          },
        );
}
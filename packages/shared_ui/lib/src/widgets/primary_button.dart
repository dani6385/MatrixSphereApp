import 'package:flutter/material.dart';

/// A primary, full-width button with a loading state.
///
/// This button is based on [FilledButton] and is designed for the main
/// call-to-action in a view. It automatically handles a loading state
/// where it shows a progress indicator and becomes disabled.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
  });

  /// The callback that is called when the button is tapped.
  /// If `null` or if `isLoading` is true, the button will be disabled.
  final VoidCallback? onPressed;

  /// The widget below this widget in the tree, typically a [Text] widget.
  final Widget child;

  /// Whether to show a loading indicator. Defaults to false.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : child,
      ),
    );
  }
}
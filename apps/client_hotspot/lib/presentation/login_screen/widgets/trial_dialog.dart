import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:client_hotspot/routes/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

class TrialDialog extends StatefulWidget {
  const TrialDialog({super.key});

  @override
  State<TrialDialog> createState() => _TrialDialogState();
}

class _TrialDialogState extends State<TrialDialog> {
  double _sliderValue = 0.0;
  bool _isActivated = false;

  void _activateTrial() async {
    setState(() => _isActivated = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      context.go(AppRoutes.homeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.5,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sesi Trial',
                style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Geser untuk mendapatkan akses internet gratis selama 5 menit.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              _isActivated
                  ? const CircularProgressIndicator()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 40.0,
                          trackShape: const RoundedRectSliderTrackShape(),
                          activeTrackColor: AppTheme.primary.withAlpha(5),
                          inactiveTrackColor: Colors.transparent,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 20.0),
                          thumbColor: AppTheme.primary,
                          overlayColor: AppTheme.primary.withAlpha(32),
                        ),
                        child: Slider(
                          value: _sliderValue,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            setState(() => _sliderValue = value);
                          },
                          onChangeEnd: (value) {
                            if (value > 0.9) {
                              _activateTrial();
                            } else {
                              setState(() => _sliderValue = 0.0);
                            }
                          },
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
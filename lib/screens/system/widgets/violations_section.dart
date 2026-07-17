import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../../models/violation_model.dart';
import 'violation_card.dart';

class ViolationsSection extends StatefulWidget {
  const ViolationsSection({super.key});

  @override
  State<ViolationsSection> createState() => _ViolationsSectionState();
}

class _ViolationsSectionState extends State<ViolationsSection> {
  late Future<List<Violation>> _violationsFuture;

  @override
  void initState() {
    super.initState();
    _violationsFuture = _fetchViolations();
  }

  Future<List<Violation>> _fetchViolations() async {
    final ref = FirebaseDatabase.instance.ref('system/pelanggaran');
    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value != null) {
      final List<Violation> violations = [];
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        violations.add(Violation.fromMap(key, value));
      });
      return violations;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PEMANTAUAN PELANGGARAN',
            style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        const SizedBox(height: AppSpacing.md),
        FutureBuilder<List<Violation>>(
          future: _violationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: kDarkSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Tidak ada data pelanggaran yang terdeteksi.',
                  style: textTheme.bodyMedium?.copyWith(color: kDarkTextSecondary),
                ),
              );
            }

            final violations = snapshot.data!;
            return ListView.builder(
              itemCount: violations.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final violation = violations[index];
                return ViolationCard(
                  sellerName: violation.sellerName,
                  complaint: violation.complaint,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

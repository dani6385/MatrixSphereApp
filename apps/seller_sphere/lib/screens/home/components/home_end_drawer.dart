
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: kDarkBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: kAccent,
                  child: Icon(Icons.person, size: 40, color: kLightTextPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Filter Kehadiran',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: kLightTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Pilihan filter data kehadiran',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kLightTextSecondary,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: kLightTextPrimary),
            title: const Text('Filter Tanggal', style: TextStyle(color: kLightTextPrimary)),
            onTap: () {
              // Implementasi filter tanggal
              // Misalnya, tampilkan date picker
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  // Lakukan sesuatu dengan tanggal yang dipilih
                  _logger.i('Tanggal dipilih: $selectedDate');
                  // Anda bisa memicu pembaruan data di HomeScreen
                  // atau menggunakan provider untuk mengelola state filter.
                }
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.filter_list, color: kLightTextPrimary),
            title: const Text('Filter Status', style: TextStyle(color: kLightTextPrimary)),
            onTap: () {
              // Implementasi filter status
              // Misalnya, tampilkan dialog atau bottom sheet untuk memilih status
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    color: kDarkSecondary,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Pilih Status Kehadiran',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: kLightTextPrimary),
                        ),
                        const Divider(color: kLightTextSecondary),
                        ListTile(
                          title: const Text('Hadir', style: TextStyle(color: kLightTextPrimary)),
                          onTap: () {
                            _logger.i('Filter status: Hadir');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Terlambat', style: TextStyle(color: kLightTextPrimary)),
                          onTap: () {
                            _logger.i('Filter status: Terlambat');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Absen', style: TextStyle(color: kLightTextPrimary)),
                          
            onTap: () {
              // Lakukan sesuatu dengan status "Absen"
              _logger.i('Filter status: Absen');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Semua Status', style: TextStyle(color: kLightTextPrimary)),
            onTap: () {
              _logger.i('Filter status: Semua Status');
              Navigator.pop(context);
            },
          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

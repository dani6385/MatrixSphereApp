import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DeviceInfoWidget extends StatelessWidget {
  final String packageName;
  final String ipAddress;
  final String macAddress;
  final String gateway;
  final String dns;
  final String sessionStart;
  final bool isTablet;

  const DeviceInfoWidget({
    required this.packageName,
    required this.ipAddress,
    required this.macAddress,
    required this.gateway,
    required this.dns,
    required this.sessionStart,
    required this.isTablet,
    super.key,
  });

  void _copyToClipboard(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    Fluttertoast.showToast(
      msg: '$label disalin',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _DeviceItem(
        icon: Icons.inventory_2_outlined,
        label: 'Paket',
        value: packageName,
        copyable: false,
      ),
      _DeviceItem(
        icon: Icons.lan_outlined,
        label: 'IP Address',
        value: ipAddress,
        copyable: true,
      ),
      _DeviceItem(
        icon: Icons.devices_rounded,
        label: 'MAC Address',
        value: macAddress,
        copyable: true,
      ),
      _DeviceItem(
        icon: Icons.router_outlined,
        label: 'Gateway',
        value: gateway,
        copyable: true,
      ),
      _DeviceItem(
        icon: Icons.dns_outlined,
        label: 'DNS Server',
        value: dns,
        copyable: true,
      ),
      _DeviceItem(
        icon: Icons.schedule_rounded,
        label: 'Mulai Sesi',
        value: sessionStart,
        copyable: false,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Informasi Perangkat',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          if (isTablet)
            _buildTabletGrid(context, items)
          else
            _buildPhoneList(context, items),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildPhoneList(BuildContext context, List<_DeviceItem> items) {
    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        return Column(
          children: [
            if (i > 0)
              const Divider(height: 1, indent: 52, color: Color(0xFFF0F0F0)),
            _DeviceInfoRow(
              item: item,
              onCopy: item.copyable
                  ? () => _copyToClipboard(context, item.value, item.label)
                  : null,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabletGrid(BuildContext context, List<_DeviceItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return _DeviceInfoRow(
          item: item,
          onCopy: item.copyable
              ? () => _copyToClipboard(context, item.value, item.label)
              : null,
        );
      },
    );
  }
}

class _DeviceItem {
  final IconData icon;
  final String label;
  final String value;
  final bool copyable;

  const _DeviceItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.copyable,
  });
}

class _DeviceInfoRow extends StatelessWidget {
  final _DeviceItem item;
  final VoidCallback? onCopy;

  const _DeviceInfoRow({required this.item, this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: AppTheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  item.value,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          if (onCopy != null)
            InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

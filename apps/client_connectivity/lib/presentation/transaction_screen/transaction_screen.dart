import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_ui/shared_ui.dart';

enum TransactionStatus { all, success, pending, failed }

class _Transaction {
  final String id;
  final String voucherCode;
  final String packageName;
  final double amount;
  final DateTime date;
  final TransactionStatus status;

  const _Transaction({
    required this.id,
    required this.voucherCode,
    required this.packageName,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TransactionStatus _selectedStatus = TransactionStatus.all;
  DateTimeRange? _selectedDateRange;

  static final List<_Transaction> _allTransactions = [
    _Transaction(
      id: 'TRX-20260627-001',
      voucherCode: 'VCH-A1B2C3',
      packageName: 'Paket Harian 1GB',
      amount: 5000,
      date: DateTime(2026, 6, 27, 14, 32),
      status: TransactionStatus.success,
    ),
    _Transaction(
      id: 'TRX-20260626-002',
      voucherCode: 'VCH-D4E5F6',
      packageName: 'Paket 3 Jam Unlimited',
      amount: 3000,
      date: DateTime(2026, 6, 26, 9, 15),
      status: TransactionStatus.success,
    ),
    _Transaction(
      id: 'TRX-20260625-003',
      voucherCode: 'VCH-G7H8I9',
      packageName: 'Paket Mingguan 5GB',
      amount: 25000,
      date: DateTime(2026, 6, 25, 18, 50),
      status: TransactionStatus.pending,
    ),
    _Transaction(
      id: 'TRX-20260624-004',
      voucherCode: 'VCH-J1K2L3',
      packageName: 'Paket Harian 1GB',
      amount: 5000,
      date: DateTime(2026, 6, 24, 11, 5),
      status: TransactionStatus.failed,
    ),
    _Transaction(
      id: 'TRX-20260622-005',
      voucherCode: 'VCH-M4N5O6',
      packageName: 'Paket 1 Jam',
      amount: 2000,
      date: DateTime(2026, 6, 22, 7, 45),
      status: TransactionStatus.success,
    ),
    _Transaction(
      id: 'TRX-20260620-006',
      voucherCode: 'VCH-P7Q8R9',
      packageName: 'Paket Mingguan 5GB',
      amount: 25000,
      date: DateTime(2026, 6, 20, 16, 20),
      status: TransactionStatus.success,
    ),
    _Transaction(
      id: 'TRX-20260618-007',
      voucherCode: 'VCH-S1T2U3',
      packageName: 'Paket 3 Jam Unlimited',
      amount: 3000,
      date: DateTime(2026, 6, 18, 13, 10),
      status: TransactionStatus.failed,
    ),
    _Transaction(
      id: 'TRX-20260615-008',
      voucherCode: 'VCH-V4W5X6',
      packageName: 'Paket Harian 1GB',
      amount: 5000,
      date: DateTime(2026, 6, 15, 20, 0),
      status: TransactionStatus.success,
    ),
    _Transaction(
      id: 'TRX-20260610-009',
      voucherCode: 'VCH-Y7Z8A9',
      packageName: 'Paket 1 Jam',
      amount: 2000,
      date: DateTime(2026, 6, 10, 8, 30),
      status: TransactionStatus.pending,
    ),
    _Transaction(
      id: 'TRX-20260605-010',
      voucherCode: 'VCH-B1C2D3',
      packageName: 'Paket Mingguan 5GB',
      amount: 25000,
      date: DateTime(2026, 6, 5, 15, 55),
      status: TransactionStatus.success,
    ),
  ];

  List<_Transaction> get _filteredTransactions {
    return _allTransactions.where((t) {
      final statusMatch =
          _selectedStatus == TransactionStatus.all ||
          t.status == _selectedStatus;
      final dateMatch =
          _selectedDateRange == null ||
          (!t.date.isBefore(_selectedDateRange!.start) &&
              !t.date.isAfter(
                _selectedDateRange!.end.add(const Duration(days: 1)),
              ));
      return statusMatch && dateMatch;
    }).toList();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: now,
      initialDateRange:
          _selectedDateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  void _clearDateRange() {
    setState(() => _selectedDateRange = null);
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }

  String _formatCurrency(double amount) {
    final str = amount.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildFilters(),
            const SizedBox(height: 4),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        bottomPadding + 88,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _TransactionCard(
                        transaction: filtered[index],
                        formatDate: _formatDate,
                        formatCurrency: _formatCurrency,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Transaksi',
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pembelian voucher & paket internet',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: const Color(0xFF5C5C5C),
                  ),
                ),
              ],
            ),
          ),
          _buildDateRangeButton(),
        ],
      ),
    );
  }

  Widget _buildDateRangeButton() {
    final hasRange = _selectedDateRange != null;
    return GestureDetector(
      onTap: _pickDateRange,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasRange ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasRange ? AppTheme.primary : const Color(0xFFDDDDDD),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 16,
              color: hasRange ? Colors.white : AppTheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              hasRange ? _shortDateRange() : 'Filter Tanggal',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: hasRange ? Colors.white : AppTheme.primary,
              ),
            ),
            if (hasRange) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _clearDateRange,
                child: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _shortDateRange() {
    if (_selectedDateRange == null) return '';
    final s = _selectedDateRange!.start;
    final e = _selectedDateRange!.end;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${s.day} ${months[s.month - 1]} – ${e.day} ${months[e.month - 1]}';
  }

  Widget _buildFilters() {
    final statuses = [
      (TransactionStatus.all, 'Semua'),
      (TransactionStatus.success, 'Sukses'),
      (TransactionStatus.pending, 'Pending'),
      (TransactionStatus.failed, 'Gagal'),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statuses.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (status, label) = statuses[index];
          final isSelected = _selectedStatus == status;
          return GestureDetector(
            onTap: () => setState(() => _selectedStatus = status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primary
                      : const Color(0xFFDDDDDD),
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF5C5C5C),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 36,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada transaksi',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coba ubah filter atau rentang tanggal',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final _Transaction transaction;
  final String Function(DateTime) formatDate;
  final String Function(double) formatCurrency;

  const _TransactionCard({
    required this.transaction,
    required this.formatDate,
    required this.formatCurrency,
  });

  Color get _statusColor {
    switch (transaction.status) {
      case TransactionStatus.success:
        return AppTheme.success;
      case TransactionStatus.pending:
        return AppTheme.warning;
      case TransactionStatus.failed:
        return AppTheme.error;
      case TransactionStatus.all:
        return AppTheme.primary;
    }
  }

  Color get _statusBg {
    switch (transaction.status) {
      case TransactionStatus.success:
        return const Color(0xFFE8F5E9);
      case TransactionStatus.pending:
        return const Color(0xFFFFF8E1);
      case TransactionStatus.failed:
        return const Color(0xFFFFEBEE);
      case TransactionStatus.all:
        return AppTheme.primary;
    }
  }

  IconData get _statusIcon {
    switch (transaction.status) {
      case TransactionStatus.success:
        return Icons.check_circle_rounded;
      case TransactionStatus.pending:
        return Icons.access_time_rounded;
      case TransactionStatus.failed:
        return Icons.cancel_rounded;
      case TransactionStatus.all:
        return Icons.receipt_long_rounded;
    }
  }

  String get _statusLabel {
    switch (transaction.status) {
      case TransactionStatus.success:
        return 'Sukses';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Gagal';
      case TransactionStatus.all:
        return 'Semua';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_rounded,
                    color: AppTheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.packageName,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        transaction.voucherCode,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: const Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, size: 12, color: _statusColor),
                      const SizedBox(width: 4),
                      Text(
                        _statusLabel,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: const Color(0xFFF0F0F0)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Tanggal',
                    value: formatDate(transaction.date),
                  ),
                ),
                _InfoItem(
                  icon: Icons.payments_rounded,
                  label: 'Jumlah',
                  value: formatCurrency(transaction.amount),
                  valueColor: AppTheme.primary,
                  valueBold: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.tag_rounded,
                  size: 12,
                  color: Color(0xFFBBBBBB),
                ),
                const SizedBox(width: 4),
                Text(
                  transaction.id,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFFBBBBBB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF9E9E9E)),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: const Color(0xFF9E9E9E),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

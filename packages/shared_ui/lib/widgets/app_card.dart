import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_spacing.dart';
import 'package:shared_ui/theme/app_style.dart';
import 'package:shared_ui/theme/app_theme.dart';

enum AppCardVariant {
  elevated,
  outlined,
  filled,
}

class AppCard extends StatelessWidget {
  /// Konten utama di dalam card
  final Widget? child;

  /// Judul card (opsional jika menggunakan child kustom)
  final String? title;

  /// Subjudul atau deskripsi card
  final String? subtitle;

  /// Widget di sebelah kiri header (ikon/avatar)
  final Widget? leading;

  /// Widget di sebelah kanan header (misal: Badge, Menu, IconButton)
  final Widget? trailing;

  /// Aksi atau tombol di bagian bawah card
  final List<Widget>? actions;

  /// Aksi ketika card diklik
  final VoidCallback? onTap;

  /// Varian tampilan card: elevated, outlined, atau filled
  final AppCardVariant variant;

  /// Padding dalam card
  final EdgeInsetsGeometry? padding;

  /// Margin luar card
  final EdgeInsetsGeometry? margin;

  /// Border radius custom (default: 12.0)
  final double borderRadius;

  /// Warna latar belakang custom (opsional)
  final Color? backgroundColor;

  /// Warna border custom (opsional)
  final Color? borderColor;

  /// Ketinggian elevasi (untuk varian elevated)
  final double elevation;

  const AppCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions,
    this.onTap,
    this.variant = AppCardVariant.filled,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
    this.elevation = 2.0,
  });

  /// Factory constructor cepat untuk tipe Outlined Card
  const AppCard.outlined({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
  })  : variant = AppCardVariant.outlined,
        elevation = 0;

  /// Factory constructor cepat untuk tipe Elevated Card
  const AppCard.elevated({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
    this.elevation = 3.0,
  }) : variant = AppCardVariant.elevated;

  @override
  Widget build(BuildContext context) {
    final defaultBgColor = backgroundColor ?? context.surface;
    final defaultBorderColor = borderColor ?? context.outline;
    final radius = BorderRadius.circular(borderRadius);

    BoxDecoration decoration;
    switch (variant) {
      case AppCardVariant.outlined:
        decoration = BoxDecoration(
          color: defaultBgColor,
          borderRadius: radius,
          border: Border.all(color: defaultBorderColor, width: 1),
        );
        break;
      case AppCardVariant.elevated:
        decoration = BoxDecoration(
          color: defaultBgColor,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.08),
              blurRadius: elevation * 3,
              offset: Offset(0, elevation),
            ),
          ],
        );
        break;
      case AppCardVariant.filled:
        decoration = BoxDecoration(
          color: defaultBgColor,
          borderRadius: radius,
        );
        break;
    }

    final hasHeader = title != null || subtitle != null || leading != null || trailing != null;
    final hasActions = actions != null && actions!.isNotEmpty;

    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header Section ---
        if (hasHeader) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: AppStyles.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.onSurface,
                            ) ??
                            TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: context.onSurface,
                            ),
                      ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: AppStyles.bodySmall?.copyWith(
                              color: context.onSurfaceVariant,
                            ) ??
                            TextStyle(
                              fontSize: 12,
                              color: context.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.xs),
                trailing!,
              ],
            ],
          ),
          if (child != null) const SizedBox(height: AppSpacing.sm),
        ],

        // --- Body / Child Section ---
        if (child != null) child!,

        // --- Footer / Actions Section ---
        if (hasActions) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!
                .map((action) => Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.xs),
                      child: action,
                    ))
                .toList(),
          ),
        ],
      ],
    );

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: cardContent,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingsRow extends StatelessWidget {
  final String text;
  // final String imagePath;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.text,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Icon / Image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 24, color: colorScheme.primary),
            ),

            const Gap(16),

            // Title
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            // Trailing Widget (Switch, Arrow, Text, etc.)
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: 26,
              ),
          ],
        ),
      ),
    );
  }
}

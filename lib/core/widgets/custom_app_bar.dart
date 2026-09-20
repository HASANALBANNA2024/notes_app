import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? action;
  final Color backgroundColor;
  final Color textColor;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.subtitle,
      this.leadingIcon,
      this.onLeadingPressed,
      this.action,
      this.backgroundColor = Colors.white,
      this.textColor = const Color(0xFF161B26)});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0.5,
      centerTitle: false,
      leading: leadingIcon != null
          ? IconButton(
              onPressed: onLeadingPressed ?? () => Navigator.maybePop(context),
              icon: leadingIcon!)
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(
              height: 2,
            ),
            Text(
              subtitle!,
              style: TextStyle(
                  color: textColor.withValues(alpha: 0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
            )
          ]
        ],
      ),
      actions: action,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

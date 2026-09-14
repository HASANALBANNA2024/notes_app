import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onLeadingTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.onLeadingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE3E6EC), width: 1),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              /// Leading Widget (Back button or Custom Icon)
              if (leading != null) ...[
                GestureDetector(
                  onTap: onLeadingTap ?? () => Navigator.maybePop(context),
                  child: _buildIconButton(child: leading!),
                ),
                const SizedBox(width: 12),
              ],

              /// Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF161B26),
                  ),
                ),
              ),

              /// Action Buttons
              if (actions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!.map((action) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: action,
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
  static Widget buildActionIcon({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF161B26),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildIconButton({required Widget child}) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: child),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
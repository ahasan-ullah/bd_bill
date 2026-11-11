import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool showBackButton;

  const AppHeader({
    super.key,
    this.leading,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: showBackButton,
      leading: leading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 24,
            color: AppColors.primary,
            colorBlendMode: BlendMode.srcIn,
            errorBuilder: (_, _, _) => const Icon(
              Icons.bolt,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'BD Bill',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

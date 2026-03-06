import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/layout_controller.dart';
import 'package:nurul_huda_mobile/views/home/home_page.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  static const _green = Color(0xFF1B7A3E);
  static const _grey = Color(0xFFB0B8C1);

  @override
  Widget build(BuildContext context) {
    final LayoutController controller = Get.put(LayoutController());

    final List<Widget> pages = [
      const HomePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Obx(() => pages[controller.tabIndex.value]),
      bottomNavigationBar: Obx(
        () => _buildBottomNav(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
        ),
      ),
    );
  }

  Widget _buildBottomNav({
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              _buildNavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.menu_book_outlined,
                activeIcon: Icons.menu_book_rounded,
                label: 'Wirid',
                onTap: onTap,
              ),
              _buildNavItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.account_balance_outlined,
                activeIcon: Icons.account_balance_rounded,
                label: 'Mondok',
                onTap: onTap,
              ),

              // ── Center Button (Beranda) ──
              _buildCenterNavItem(
                index: 2,
                currentIndex: currentIndex,
                onTap: onTap,
              ),

              _buildNavItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.help_outline_rounded,
                activeIcon: Icons.help_rounded,
                label: 'Bantuan',
                onTap: onTap,
              ),
              _buildNavItem(
                index: 4,
                currentIndex: currentIndex,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profil',
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required ValueChanged<int> onTap,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      isSelected ? _green.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? _green : _grey,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? _green : _grey,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavItem({
    required int index,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            width: isSelected ? 62 : 56,
            height: isSelected ? 62 : 56,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF0D4A24), Color(0xFF25A355)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _green.withOpacity(isSelected ? 0.5 : 0.3),
                  blurRadius: isSelected ? 20 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.home_rounded,
              color: Colors.white,
              size: isSelected ? 30 : 26,
            ),
          ),
        ),
      ),
    );
  }
}

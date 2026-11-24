import 'package:flutter/material.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/features/auth/presentation/pages/login_page.dart';
import 'package:tilet/features/checkout/presentation/pages/edit_address_page.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forest,
      child: Column(
        children: [
          // Deep Forest Green Profile Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
              child: Row(
                children: [
                  // Gold-Bordered Avatar
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      color: AppColors.cream.withOpacity(0.14),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.goldBorder,
                        width: 1.6,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'SK',
                        style: TextStyle(
                          color: AppColors.goldLight,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // User Info
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamawit Kebede',
                          style: TextStyle(
                            color: AppColors.cream,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'selam@tilet.et  •  +251 911 234 567',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            color: Color(0xFFD8D0BE),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rising Warm Cream Sheet
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                children: [
                  const _SectionLabel('My Shopping'),
                  const SizedBox(height: 10),
                  _AccountMenuGroup(
                    children: [
                      _AccountMenuTile(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        subtitle: 'Track active & past Kemis orders',
                        onTap: () {},
                      ),
                      const Divider(color: AppColors.line, height: 1),
                      _AccountMenuTile(
                        icon: Icons.straighten_rounded,
                        title: 'Saved Measurements',
                        subtitle: 'Custom Fit tailoring profile',
                        onTap: () {},
                      ),
                      const Divider(color: AppColors.line, height: 1),
                      _AccountMenuTile(
                        icon: Icons.location_on_outlined,
                        title: 'Delivery Addresses',
                        subtitle: 'Bole, Addis Ababa',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditAddressPage(
                              initialCity: 'Bole, Addis Ababa',
                              initialAddressLine:
                                  'Cameroon St, House 14 • +251 911 234 567',
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: AppColors.line, height: 1),
                      _AccountMenuTile(
                        icon: Icons.credit_card_outlined,
                        title: 'Payment Methods',
                        subtitle: 'Chapa & Stripe',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  const _SectionLabel('Preferences'),
                  const SizedBox(height: 10),
                  _AccountMenuGroup(
                    children: [
                      _AccountMenuTile(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        subtitle: 'Order updates & new arrivals',
                        onTap: () {},
                      ),
                      const Divider(color: AppColors.line, height: 1),
                      _AccountMenuTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        subtitle: 'Sizing guide & contact us',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  // Log Out Button
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout_rounded, size: 19),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.forest,
                        side: const BorderSide(
                          color: AppColors.forest,
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.forest,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _AccountMenuGroup extends StatelessWidget {
  const _AccountMenuGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(children: children),
    );
  }
}

class _AccountMenuTile extends StatelessWidget {
  const _AccountMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.forest, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Arial',
          color: AppColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Arial',
          color: AppColors.muted,
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.gold,
      ),
    );
  }
}
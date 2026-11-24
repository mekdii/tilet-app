import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tilet/core/theme/app_colors.dart';
import 'package:tilet/core/widgets/textile_footer.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({
    super.key,
    required this.initialCity,
    required this.initialAddressLine,
  });

  final String initialCity;
  final String initialAddressLine;

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;
  late final TextEditingController _phoneController;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.initialCity);

    // Split "Cameroon St, House 14 • +251 911 234 567" if formatted that way
    final parts = widget.initialAddressLine.split('•');
    _streetController = TextEditingController(
      text: parts.isNotEmpty ? parts[0].trim() : '',
    );
    _phoneController = TextEditingController(
      text: parts.length > 1 ? parts[1].trim() : '+251 ',
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final city = _cityController.text.trim();
    final street = _streetController.text.trim();
    final phone = _phoneController.text.trim();

    Navigator.pop(context, {
      'city': city,
      'addressLine': '$street • $phone',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.forest,
        body: Column(
          children: [
            // Deep Forest Green Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 18, 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.cream,
                      ),
                    ),
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // Balances the back arrow
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
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
                    children: [
                      _AddressField(
                        label: 'City / Sub-city',
                        hint: 'e.g. Bole, Addis Ababa',
                        icon: Icons.location_city_rounded,
                        controller: _cityController,
                      ),
                      const SizedBox(height: 16),
                      _AddressField(
                        label: 'Street & House / Building',
                        hint: 'e.g. Cameroon St, House 14',
                        icon: Icons.home_outlined,
                        controller: _streetController,
                      ),
                      const SizedBox(height: 16),
                      _AddressField(
                        label: 'Phone Number',
                        hint: '+251 911 234 567',
                        icon: Icons.phone_outlined,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _AddressField(
                        label: 'Delivery Note (Optional)',
                        hint: 'Landmark, gate color, or call on arrival',
                        icon: Icons.notes_rounded,
                        controller: _noteController,
                        required: false,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Sticky Save Button + Tilet Footer
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.cream,
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 12),
              child: SizedBox(
                height: 54,
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: AppColors.goldLight,
                    side: const BorderSide(
                      color: AppColors.goldBorder,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Save Address',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const TextileFooter(height: 36),
          ],
        ),
      ),
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.required = true,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool required;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Arial',
            color: AppColors.forest,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: 'Arial',
            color: AppColors.ink,
            fontSize: 14,
          ),
          validator: required
              ? (value) => (value == null || value.trim().isEmpty)
                  ? 'Please enter $label'
                  : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.forest, size: 20),
            filled: true,
            fillColor: AppColors.paper,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppColors.forest,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
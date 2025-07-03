import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidgets {
  static InputDecoration inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.teal),
      contentPadding: const EdgeInsets.all(8),
      filled: true,
      fillColor: Colors.white.withAlpha(200),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF248277)),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static Widget buildInputField(TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: inputDecoration(icon),
    );
  }

  static Widget buildInputFieldCustom(TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: inputDecoration(icon),
    );
  }

  static Widget buildNumericInput(
      TextEditingController controller,
      IconData icon, {
        bool readOnly = false,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
      decoration: inputDecoration(icon),
    );
  }

  static Widget buildDigitsOnlyInput(
      TextEditingController controller,
      IconData icon, {
        bool readOnly = false,
      }) {
    return buildNumericInput(
      controller,
      icon,
      readOnly: readOnly,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  static Widget buildRadioSelector({
    required BuildContext context,
    required String tipo,
    required bool? groupValue,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: groupValue,
            activeColor: Colors.blue,
            onChanged: onChanged,
          ),
          const Text('Real', style: TextStyle(color: Colors.black)),
          Radio<bool>(
            value: false,
            groupValue: groupValue,
            activeColor: Colors.red,
            onChanged: onChanged,
          ),
          const Text('Estimado', style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
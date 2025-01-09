import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const FilterButton({
    required this.label,
    required this.onPressed,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Color.fromRGBO(239, 239, 239, 0.8) : const Color.fromRGBO(39, 39, 39, 1).withOpacity(0.92),
        foregroundColor: isActive ? const Color.fromRGBO(39, 39, 39, 1).withOpacity(0.92) : Color.fromRGBO(239, 239, 239, 0.8),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Text(label),
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(Icons.close, size: 16),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CollectMoneyPopup extends StatelessWidget {
  final String amount;

  const CollectMoneyPopup({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text('Collect Money'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Please collect the following amount:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close the popup
          child: const Text('Close'),
        ),
      ],
    );
  }
}

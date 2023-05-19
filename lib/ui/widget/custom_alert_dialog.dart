import 'package:flutter/material.dart';

import '../../value/color.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title, message;
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(.8),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "OK",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
          ),
        )
      ],
    );
  }
}

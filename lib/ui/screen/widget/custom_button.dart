import 'package:flutter/material.dart';

import '../../../value/color.dart';

enum ButtonType { primary, secondary }

class CustomButton extends StatelessWidget {
  final ButtonType buttonType;
  final String text;
  final Function() onTap;
  const CustomButton({
    super.key,
    this.buttonType = ButtonType.primary,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Material(
        borderRadius: BorderRadius.circular(27),
        color: buttonType == ButtonType.primary ? primaryColor : secondaryColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(27),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

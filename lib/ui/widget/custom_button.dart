import 'package:flutter/material.dart';

import '../../value/color.dart';

enum ButtonType { primary, secondary, tertiary }

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final ButtonType buttonType;
  final String text;
  final Function() onTap;
  const CustomButton({
    super.key,
    this.buttonType = ButtonType.primary,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Material(
        borderRadius: BorderRadius.circular(27),
        color: buttonType == ButtonType.primary
            ? primaryColor
            : buttonType == ButtonType.secondary
                ? secondaryColor
                : Colors.black,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(27),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: isLoading
                ? const LinearProgressIndicator()
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: buttonType == ButtonType.tertiary
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../value/color.dart';

class CustomIconTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final IconData iconData;
  final bool isActive;
  const CustomIconTextButton({
    super.key,
    required this.text,
    required this.iconData,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: isActive ? iconActiveColor : secondaryColor,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: isActive ? iconActiveColor : secondaryColor,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}

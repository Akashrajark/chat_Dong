import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Function() onTap;
  const CustomListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
              "https://marketplace.canva.com/EAFEits4-uw/1/0/400w/canva-boy-cartoon-gamer-animated-twitch-profile-photo-Pk-dGK9pdQg.jpg"),
        ),
        contentPadding: const EdgeInsets.all(0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              "00:21",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Text(
            "UrWelcome",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Column(
        children: [
          Material(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Story",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white60,
                            ),
                      ),
                      Text(
                        "See All",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white60,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Material(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(100),
                        child: const Padding(
                          padding: EdgeInsets.all(18),
                          child: Icon(
                            Icons.add,
                            color: Colors.white12,
                            size: 50,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              color: Colors.white,
              child: Row(
                children: [],
              ),
            ),
          )
        ],
      ),
    );
  }
}

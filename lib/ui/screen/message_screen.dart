import 'package:chat_app/ui/screen/chat_screen.dart';
import 'package:chat_app/ui/widget/custom_alert_dialog.dart';
import 'package:chat_app/ui/widget/custom_listtile.dart';
import 'package:chat_app/value/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Chat",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [TextFormField()],
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                "add chat",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .where("uid",
                              isNotEqualTo:
                                  FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .asStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            return Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  List<
                                          QueryDocumentSnapshot<
                                              Map<String, dynamic>>> item =
                                      snapshot.data!.docs;
                                  return CustomListTile(
                                    title: item[index]["name"],
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            reciverid: item[index]["uid"],
                                            name: item[index]["name"],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: snapshot.data!.docs.length,
                              ),
                            );
                          } else {
                            return Center(
                                child: Text(
                              "no Data",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.black),
                            ));
                          }
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const CustomAlertDialog(
                              title: "Something went wrong", message: "");
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

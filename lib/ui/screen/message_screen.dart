import 'package:chat_app/ui/screen/chat_screen.dart';
import 'package:chat_app/ui/widget/custom_alert_dialog.dart';
import 'package:chat_app/ui/widget/custom_listtile.dart';
import 'package:chat_app/value/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<dynamic> ids = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final customStream = FirebaseFirestore.instance.collection("chatbox").where(
      "id",
      arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid]).snapshots();
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
                    ),
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
                                builder: (context) => CustomDialogbox(
                                    db: db, auth: auth, ids: ids),
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
                      stream: customStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            return Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  List<dynamic> newids = snapshot
                                      .data!.docs[index]["id"] as List<dynamic>;

                                  ids.addAll(newids);
                                  newids.remove(auth.currentUser!.uid);

                                  return CustomListTile2(
                                    otherid: newids.first,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            otherid: newids.first,
                                            chatbox: snapshot
                                                .data!.docs[index].reference.id,
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
                                "No Data",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.black),
                              ),
                            );
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

class CustomDialogbox extends StatelessWidget {
  final FirebaseFirestore db;
  final FirebaseAuth auth;
  final List? ids;
  const CustomDialogbox({
    super.key,
    required this.db,
    required this.auth,
    required this.ids,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      child: Dialog(
        insetPadding: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  Center(
                    child: Text(
                      "Search",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(1),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: primaryColor,
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              StreamBuilder(
                stream: db
                    .collection("Users")
                    .where(
                      "uid",
                      isNotEqualTo: auth.currentUser!.uid,
                    )
                    .get()
                    .asStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(10.0),
                          itemBuilder: (context, index) {
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                item = snapshot.data!.docs;

                            if (ids == null ||
                                !ids!.contains(item[index]["uid"])) {
                              return CustomListTile(
                                title: item[index]["name"],
                                onTap: () {
                                  db.collection("chatbox").add(
                                    {
                                      "id": [
                                        item[index]["uid"],
                                        auth.currentUser!.uid
                                      ],
                                      "time": DateTime.now(),
                                    },
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(),
                          itemCount: snapshot.data!.docs.length,
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "No Data",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black),
                        ),
                      );
                    }
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }
}

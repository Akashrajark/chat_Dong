import 'package:chat_app/value/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ChatScreen extends StatefulWidget {
  final String reciverid, name;
  const ChatScreen({
    super.key,
    required this.reciverid,
    required this.name,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 80,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Users").snapshots(),
            builder: (context, snapshot) {
              Logger().wtf("$snapshot");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.data != null) {
                final List<QueryDocumentSnapshot<Map<String, dynamic>>> item =
                    snapshot.data!.docs;
                return ListView.separated(
                  reverse: true,
                  itemBuilder: (context, index) => Customchat(
                    messageText: item[index].data()["message"],
                    mainAxisAlignment: MainAxisAlignment.center,
                    color: primaryColor,
                  ),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: item.length,
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else {
                return const Center(child: Text("sajndnknjsdk"));
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: TextFormField(
          controller: messageC,
          decoration: InputDecoration(
            fillColor: Colors.grey.shade200,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Material(
                borderRadius: BorderRadius.circular(100),
                color: Colors.purple.withOpacity(0.3),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.mic,
                    color: Colors.deepPurple,
                    size: 23,
                  ),
                ),
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Material(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blue.withOpacity(0.3),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    FirebaseFirestore.instance.collection("message").add({
                      "message": messageC.text,
                      "time": DateTime.now(),
                      "id": [
                        widget.reciverid,
                        FirebaseAuth.instance.currentUser!.uid
                      ]
                    });
                    messageC.clear();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.blueAccent,
                      size: 23,
                    ),
                  ),
                ),
              ),
            ),
            hintText: "Message...",
            hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(25.0),
          ),
        ),
      ),
    );
  }
}

class Customchat extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final String messageText;
  final Color color;
  const Customchat({
    super.key,
    required this.messageText,
    required this.mainAxisAlignment,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          borderRadius: BorderRadius.circular(10),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(messageText),
          ),
        ),
      ],
    );
  }
}

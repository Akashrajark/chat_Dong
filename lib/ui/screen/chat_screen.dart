import 'package:chat_app/value/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatbox;
  const ChatScreen({
    super.key,
    required this.chatbox,
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
            stream: FirebaseFirestore.instance
                .collection("chatbox")
                .doc(widget.chatbox)
                .collection("chat")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  final List<QueryDocumentSnapshot<Map<String, dynamic>>> item =
                      snapshot.data!.docs;
                  return ListView.separated(
                    padding:
                        const EdgeInsets.only(bottom: 100, right: 10, left: 10),
                    reverse: true,
                    itemBuilder: (context, index) => item[index].data()["id"] ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? Customchat(
                            messageText: item[index].data()["message"],
                            mainAxisAlignment: MainAxisAlignment.end,
                            color: Colors.grey.withOpacity(0.17),
                          )
                        : Customchat(
                            messageText: item[index].data()["message"],
                            mainAxisAlignment: MainAxisAlignment.start,
                            color: primaryColor,
                          ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 5,
                    ),
                    itemCount: item.length,
                  );
                } else {
                  return const Center(child: Text("NO Data"));
                }
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else {
                return const Center(child: Text("someting went wrong "));
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
                    FirebaseFirestore.instance
                        .collection("chatbox")
                        .doc(widget.chatbox)
                        .collection("chat")
                        .add({
                      "message": messageC.text,
                      "time": DateTime.now(),
                      "id": FirebaseAuth.instance.currentUser!.uid
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
            child: Text(
              messageText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}

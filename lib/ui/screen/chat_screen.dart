import 'package:chat_app/value/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String otherid;
  final String chatbox;
  const ChatScreen({
    super.key,
    required this.chatbox,
    required this.otherid,
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
        title: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            color: primaryColor,
            child: Image.network(
              "https://marketplace.canva.com/EAFEits4-uw/1/0/400w/canva-boy-cartoon-gamer-animated-twitch-profile-photo-Pk-dGK9pdQg.jpg",
              height: 50,
              width: 50,
            ),
          ),
        ),
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
                .orderBy("time", descending: true)
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
                    itemBuilder: (context, index) => Customchat(
                      messageText: item[index].data()["message"],
                      isActiveUser: item[index].data()["id"] ==
                          FirebaseAuth.instance.currentUser!.uid,
                      time: item[index].data()["time"],
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
                    if (messageC.text.trim() != "") {
                      FirebaseFirestore.instance
                          .collection("chatbox")
                          .doc(widget.chatbox)
                          .collection("chat")
                          .add({
                        "message": messageC.text,
                        "time": DateTime.now(),
                        "id": FirebaseAuth.instance.currentUser!.uid
                      });
                    }
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
  final String messageText;
  final Timestamp time;
  final bool isActiveUser;
  const Customchat({
    super.key,
    required this.messageText,
    required this.time,
    required this.isActiveUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isActiveUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Material(
          borderRadius: BorderRadius.circular(30),
          color: isActiveUser ? Colors.grey.withOpacity(0.17) : primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              messageText,
              textAlign: isActiveUser ? TextAlign.end : TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Text(
            "${time.toDate().hour}:${time.toDate().minute}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

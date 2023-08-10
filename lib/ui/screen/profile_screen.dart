import 'package:chat_app/bloc/profile/profile_bloc.dart';
import 'package:chat_app/ui/screen/getstarted.dart';
import 'package:chat_app/util/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  bool isObsecu = false;
  @override
  void initState() {
    super.initState();
    _emailController.text = user!.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is SignInSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.black,
                    height: 150,
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
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            const Text(
                              "Akash",
                            ),
                            CustomProfileTile(
                              onTap: () async {
                                final usersList = await FirebaseFirestore
                                    .instance
                                    .collection("Users")
                                    .doc(user!.uid)
                                    .get();
                                nameController.text = usersList["name"];
                                if (usersList["bio"] != null) {
                                  bioController.text = usersList["bio"];
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: Form(
                                            key: formKey,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Edit Profile",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
                                                    controller: nameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: "Name",
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    controller: bioController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: "bio",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                              },
                              leading: Icons.edit,
                              trailing: Icons.arrow_forward_ios,
                              title: "Edit Profile",
                            ),
                            CustomProfileTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: ((_) => Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Form(
                                            key: formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Reset Password",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    IconButton(
                                                      color: Colors.black,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.red,
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  4.0),
                                                          child:
                                                              Icon(Icons.close),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  readOnly: true,
                                                  validator: validateEmail,
                                                  controller: _emailController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  decoration:
                                                      const InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.email_rounded,
                                                    ),
                                                    hintText: 'Email Address',
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  validator: validatePassword,
                                                  controller:
                                                      currentPasswordController,
                                                  obscureText: isObsecu,
                                                  decoration: InputDecoration(
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isObsecu = !isObsecu;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        isObsecu
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                      ),
                                                    ),
                                                    prefixIcon:
                                                        const Icon(Icons.lock),
                                                    hintText: 'Password',
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  obscureText: isObsecu,
                                                  validator: validatePassword,
                                                  controller:
                                                      newPasswordController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "New Password",
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  obscureText: isObsecu,
                                                  validator: validatePassword,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "Confirm New Password",
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomButton(
                                                  isLoading: state
                                                      is SignInLoadingState,
                                                  buttonType:
                                                      ButtonType.tertiary,
                                                  text: "Save",
                                                  onTap: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      BlocProvider.of<ProfileBloc>(
                                                              context)
                                                          .add(ProfileChangePasswordEvent(
                                                              email:
                                                                  _emailController
                                                                      .text
                                                                      .trim(),
                                                              password:
                                                                  currentPasswordController
                                                                      .text
                                                                      .trim(),
                                                              newPassword:
                                                                  newPasswordController
                                                                      .text
                                                                      .trim()));
                                                      currentPasswordController
                                                          .clear();

                                                      newPasswordController
                                                          .clear();
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                );
                              },
                              leading: Icons.lock,
                              trailing: Icons.arrow_forward_ios,
                              title: "Change password",
                            ),
                            CustomProfileTile(
                              onTap: () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(ProfileEventLogOut(null));
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GetStarted(),
                                    ),
                                    (route) => false);
                              },
                              leading: Icons.logout,
                              title: "Log out",
                              trailing: Icons.arrow_forward_ios,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: const BorderSide(
                      width: 4,
                      color: Colors.white,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      "https://marketplace.canva.com/EAFEits4-uw/1/0/400w/canva-boy-cartoon-gamer-animated-twitch-profile-photo-Pk-dGK9pdQg.jpg",
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomProfileTile extends StatelessWidget {
  final Function() onTap;
  final IconData leading, trailing;
  final String title;
  const CustomProfileTile({
    super.key,
    required this.onTap,
    required this.leading,
    required this.trailing,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(leading),
      title: Text(title),
      trailing: Icon(trailing),
    );
  }
}

import 'package:chat_app/bloc/auth/sign_in/sign_in_bloc.dart';
import 'package:chat_app/ui/screen/home_screen.dart';
import 'package:chat_app/ui/screen/signup_screen.dart';
import 'package:chat_app/ui/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/custom_alert_dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObsecur = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInFailureState) {
            showDialog(
              context: context,
              builder: (context) => const CustomAlertDialog(
                title: "Sing In Failed",
                message: "",
              ),
            );
          } else if (state is SignInSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Image.asset(
                  "assets/bg.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Flexible(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Sign In',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "enter a email";
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_rounded,
                                    ),
                                    hintText: 'Email',
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "enter a password";
                                    }
                                    return null;
                                  },
                                  controller: _passwordController,
                                  obscureText: isObsecur,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {});
                                        isObsecur = !isObsecur;
                                      },
                                      icon: Icon(
                                        isObsecur
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                    prefixIcon: const Icon(Icons.lock),
                                    hintText: 'Password',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  isLoading: state is SignInLoadingState,
                                  text: "Sign In",
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<SignInBloc>(context).add(
                                        SignInEvent(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Don't have an Account?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  buttonType: ButtonType.secondary,
                                  text: "Sign up",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

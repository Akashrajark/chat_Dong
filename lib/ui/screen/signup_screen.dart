import 'package:chat_app/bloc/auth/sign_up/sign_up_bloc.dart';
import 'package:chat_app/ui/screen/signin_screen.dart';
import 'package:chat_app/util/validator.dart';
import 'package:chat_app/value/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widget/custom_alert_dialog.dart';
import 'home_screen.dart';
import '../widget/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObsecu = true;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(),
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: "Sign Up Failed",
                message: state.message,
              ),
            );
          } else if (state is SignUpSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColor,
            extendBodyBehindAppBar: true,
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
                                  'Sign Up',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: validateName,
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                    hintText: 'Full Name',
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  validator: validateEmail,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_rounded,
                                    ),
                                    hintText: 'Email Address',
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  validator: validatePassword,
                                  controller: _passwordController,
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
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                    prefixIcon: const Icon(Icons.lock),
                                    hintText: 'Password',
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: isObsecu,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Confirm Password',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (value !=
                                        _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  isLoading: state is SignUpLoadingState,
                                  text: "Sign Up",
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<SignUpBloc>(context).add(
                                        SignUpEvent(
                                          name: _nameController.text.trim(),
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
                                  "Already have an Account?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen(),
                                      ),
                                    );
                                  },
                                  text: 'Sign In',
                                  buttonType: ButtonType.secondary,
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

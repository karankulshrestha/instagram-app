import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_input_field.dart';

import '../responses/mobile_screen_layout.dart';
import '../responses/responsive_layout_screen.dart';
import '../responses/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        file: _image!);

    if (res != 'success') {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, context);
    } else {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                SvgPicture.asset(
                  'assets/logo.svg',
                  colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  height: 64,
                ),
                const SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter you password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    textEditingController: _bioController,
                    hintText: 'Enter your bio',
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('Sign up'),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Don't have an account?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: const Text(
                          "Sign In.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

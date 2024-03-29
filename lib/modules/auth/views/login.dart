import 'package:crud_flutter/providers/auth/auth_provider.dart';
import 'package:crud_flutter/repositories/auth/auth_repository.dart';
import 'package:crud_flutter/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameContoller = TextEditingController();
  String? _usrnameErr;
  final _authRepository = AuthRepository();

  void _validateInput() {
    setState(() {
      if (_usernameContoller.text.isEmpty) {
        _usrnameErr = 'Username tidak boleh kosong';
      } else {
        _usrnameErr = null; // Reset error message if username is not empty
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/login.png',
                  height: 300,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          const Text(
                            'Masuk',
                            style:
                                TextStyle(fontFamily: 'popbold', fontSize: 30),
                          ),
                          const Text(
                            'Halo, selamat datang kembali. Masukkan username anda pada inputan dibawah ini!',
                            style:
                                TextStyle(fontFamily: 'popmed', fontSize: 15),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            maxLines: 1,
                            maxLength: 30,
                            minLines: 1,
                            controller: _usernameContoller,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                label: Text('Username'),
                                errorText: _usrnameErr,
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Dengan masuk, maka Anda menyetujui segala syarat dan ketentuan yang berlaku.',
                            style:
                                TextStyle(fontFamily: 'popmed', fontSize: 12),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () async {
                                  _validateInput();
                                  if (_usrnameErr == null) {
                                    _authRepository
                                        .saveUserInfo(_usernameContoller.text);
                                    Navigator.pushNamed(
                                        context, AppRoutes.homeScreen);
                                  }
                                },
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(double.infinity, 50)),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.black)),
                                child: Text(
                                  'Masuk sekarang',
                                  style: TextStyle(
                                      fontFamily: 'popmed',
                                      color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

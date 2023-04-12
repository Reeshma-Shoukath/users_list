import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:userslist/list.dart';
import 'package:userslist/models/user_model.dart';

class RegisterProvider with ChangeNotifier {
  String _email = '';
  String _password = '';

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

// For submit Form http Post

  void _submitForm() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final url = Uri.https('reqres.in', '/api/register');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacementNamed('/list');
    } else {
      // show Dialog if any error occurs
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text(responseData['error']),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Register Page',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 253, 140, 130),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover)),
          child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 150),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  offset: Offset(1, 1),
                                  color: Colors.grey.withOpacity(1)),
                            ]),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          onChanged: (value) =>
                              registerProvider.setEmail(value),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  offset: Offset(1, 1),
                                  color: Colors.grey.withOpacity(1)),
                            ]),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          onChanged: (value) =>
                              registerProvider.setPassword(value),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 175, 169),
                          borderRadius: BorderRadius.circular(8)),
                      child: TextButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ])),
        ));
  }
}

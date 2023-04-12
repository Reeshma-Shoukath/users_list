import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:userslist/models/list_model.dart';
import 'package:userslist/register.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<User> _users = [];

//For Get Data from API and Sort in Ascending Order
  Future<void> _fetchUsers() async {
    final response = await http
        .get(Uri.parse('https://reqres.in/api/users?page=1&per_page=12'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final usersData = jsonData['data'];
      setState(() {
        _users = usersData.map<User>((user) => User.fromJson(user)).toList();
        _users.sort((a, b) => a.firstName.compareTo(b.firstName));
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Page',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 253, 140, 130),
      ),
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _users.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        _users.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

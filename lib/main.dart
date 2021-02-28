import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String formValue = '';
  List<String> myList = List<String>();
  final _formkey = GlobalKey<FormFieldState>();

  Future<List> getStringList() async {
    final prefs = await SharedPreferences.getInstance();
    List newList = prefs.getStringList('my_string_list_key');
    if (newList == null) {
      return [];
    }
    return newList;
  }

  Future<void> updateList(List<String> updatedList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("my_string_list_key", updatedList);
  }

  Future<void> startup() async {
    List oldlist = await getStringList();
    setState(() {
      myList = oldlist;
    });
  }

  @override
  void initState() {
    super.initState();

    startup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Text(
              'My ToDo',
              style: TextStyle(
                fontSize: 54,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              key: _formkey,
              onChanged: (value) {
                formValue = value;
              },
              decoration: InputDecoration(
                  hintText: 'Write your ToDo',
                  hintStyle: TextStyle(fontSize: 25)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 5),
            child: RaisedButton(
              onPressed: () {
                if (formValue != '') {
                  myList.add(formValue);
                  updateList(myList);
                  formValue = '';
                  _formkey.currentState.reset();
                  setState(() {});
                }
              },
              child: Text('Create a ToDo'),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: ListView.builder(
              itemCount: myList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(myList[index]),
                  onDismissed: (dir) {
                    myList.removeAt(index);
                    updateList(myList);
                  },
                  child: ListTile(
                    title: Text(myList[index]),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

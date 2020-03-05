

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqlite/Database/DBHelper.dart';
import 'package:sqlite/Model/Contact.dart';
import 'package:sqlite/contact_list.dart';

void main() => runApp(MyApp());

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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Contact contact = new Contact();

  String name ,phone;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

//  get submitContact => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    key: scaffoldKey,
      appBar: AppBar(title: Text("Create contact"),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.view_list),
            tooltip: "view list",
            onPressed: (){
              startContactList();
            }),
      ],
      ),
      body: Padding(padding: EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Name"),
              validator: (val) => val.length == 0 ?"Enter your name": null,
              onSaved: (val) => this.name = val,
            ),

            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Phone"),
              validator: (val) => val.length == 0 ?"Enter your phone": null,
              onSaved: (val) => this.phone = val,
            ),

            Container(
              margin: EdgeInsets.only(top:10.0),
              child: RaisedButton(
                child: Text("add new contact"),
              onPressed: submitContact,
              ),
            ),

          ],
        ),
      ),
      ),
    );
  }

  void startContactList() {

    Navigator.push(context, new MaterialPageRoute(builder: (context)=> MyContactList()
    ),
    );

  }

  void submitContact() {

    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    }else{
      return null;
    }
    var contact = Contact();
    contact.name = name ;
    contact.phone = phone;

    var dbHelper = DBHelper();
    dbHelper.addNewContact(contact);
    Fluttertoast.showToast(msg: "Contact was saved",toastLength: Toast.LENGTH_SHORT,backgroundColor: Colors.green,textColor: Colors.yellow);


  }
}


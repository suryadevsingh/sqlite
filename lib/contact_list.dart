


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqlite/Database/DBHelper.dart';
import 'package:sqlite/Model/Contact.dart';

Future<List<Contact>> getContactsFromDB()async{
  var dbHelper = DBHelper();
  Future<List<Contact>> contacts =dbHelper.getContacts();
  return contacts;
}

class MyContactList extends StatefulWidget {

  @override
  _MyContactListState createState() => _MyContactListState();
}

class _MyContactListState extends State<MyContactList> {

  final controller_name = new TextEditingController();
  final controller_phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Contact List"),
    ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contact>>(
          future:  getContactsFromDB(),
          builder: (context, snapshot){
            if (snapshot.data != null){
              if (snapshot.hasData) {

                return ListView.builder(
                itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
                  return new Row(
                    children: <Widget>[

                      Expanded(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(snapshot.data[index].name,style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ),
                            Text(snapshot.data[index].phone,style: TextStyle(color: Colors.grey),
                            ),

                        ],
                        ),
                      ),


                      GestureDetector(
                        onTap: (){

                          showDialog(context: context, builder: (_) => new AlertDialog(contentPadding: EdgeInsets.all(16.0),
                          content: Row(
                            children: <Widget>[
                            Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                autofocus: true,
                                decoration: InputDecoration(hintText: "${snapshot.data[index].name}"),
                              controller: controller_name,
                              ),

                              TextFormField(
                                autofocus: false,
                                decoration: InputDecoration(hintText: "${snapshot.data[index].phone}"),
                                controller: controller_phone,
                              ),

                            ],
                            ),
                            ),
                              ],
                          ),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text("cancel")
                              ),
                              FlatButton(
                                  onPressed: (){
                                   var dbHelper =DBHelper();
                                   Contact contact = new Contact();
                                   contact.id = snapshot.data[index].id;

                                   contact.name = controller_name.text !=""?controller_name.text:snapshot.data[index].name;

                                   contact.phone = controller_phone.text !=""?controller_phone.text:snapshot.data[index].phone;

                                   dbHelper.updateContact(contact);
                                   Navigator.pop(context);
                                   setState(() {
                                     getContactsFromDB();
                                   });

                                  },
                                  child: Text("update")
                              ),

                            ],
                          ),

                          );
                        },
                        child: Icon(Icons.update,color: Colors.red,),
                      ),
                      GestureDetector(
                        onTap: (){
                          var dbHelper =DBHelper();
                          dbHelper.deleteContact(snapshot.data[index]);
                          Fluttertoast.showToast(msg: "contact was deleted",toastLength: Toast.LENGTH_SHORT,backgroundColor: Colors.purple,textColor: Colors.yellow);

                          setState(() {
                            getContactsFromDB();
                          });
                        },
                        child: Icon(Icons.delete,color: Colors.red,),
                      ),


                    ],
                  );
                  }

                );

              }
            }
            return Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
super.initState();
  }


}

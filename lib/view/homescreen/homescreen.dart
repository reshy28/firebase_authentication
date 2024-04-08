import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/view/homescreen/loginScreen/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController namecontroller = TextEditingController();
    TextEditingController phonecontroller = TextEditingController();
    //to  reference of firebase data 1
    CollectionReference Collectionreference =
        FirebaseFirestore.instance.collection("class1");
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false);
                },
                icon: Icon(Icons.exit_to_app))
          ],
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.arrow_forward_ios_outlined),
            ),
          )),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 32, 29, 29),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      "https://images.pexels.com/photos/884788/pexels-photo-884788.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                ),
              ),
              arrowColor: Colors.green,
              accountName: Text("reshy"),
              accountEmail: Text("rasheedrahee827@gmail.com"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://images.pexels.com/photos/1269968/pexels-photo-1269968.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                      ),
                    ),
                    height: 60,
                    width: 300,
                    //   color: Colors.amber,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: namecontroller,
              decoration: InputDecoration(enabledBorder: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: phonecontroller,
              decoration: InputDecoration(enabledBorder: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Collectionreference.add(
                    {"Name": namecontroller.text, "ph": phonecontroller.text});
              },
              child: Text("add "),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: StreamBuilder(
              stream: Collectionreference.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("error");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot classSnap =
                          snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(classSnap["Name"]),
                        subtitle: Text(classSnap["ph"].toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Collectionreference.doc(classSnap.id).set({
                                    "Name": namecontroller.text,
                                    "ph": phonecontroller.text
                                  });
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  //delete id
                                  Collectionreference.doc(classSnap.id)
                                      .delete();
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}

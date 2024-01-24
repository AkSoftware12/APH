import 'package:aph/UploadImage/load_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class AddData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("geeksforgeeks"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('driver_details').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Container(
                child: Column(
                  children: [
                    Center(child: Text(document['age'])),
                    Center(child: Text(document['phone_no'])),
                    Center(child: Text(document['name'])),
                    Center(child: Text(document['driving_licence'])),
                    Center(child: Text(document['address'])),
                    Container(
                      child: Image.network(document['image']),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

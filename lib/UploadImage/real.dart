import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RealtimeDatabaseInsert extends StatefulWidget {
  RealtimeDatabaseInsert({Key? key}) : super(key: key);

  @override
  State<RealtimeDatabaseInsert> createState() => _RealtimeDatabaseInsertState();
}

class _RealtimeDatabaseInsertState extends State<RealtimeDatabaseInsert> {
  var nameController = new TextEditingController();

  var ageController = new TextEditingController();

  var dlController = new TextEditingController();

  var adController = new TextEditingController();

  var phnController = new TextEditingController();

  final firestore = FirebaseFirestore.instance;

  File? _image;

  get data => null;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Insert Driver Details',
                      style: TextStyle(fontSize: 28),
                    ),
                    Text("Add Data"),
                    Container(
                      height: 150,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: _image == null
                                    ? Text('No image selected.')
                                    : Image.file(_image!),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  // Single file picked
                                  PlatformFile file = result.files.first;
                                  _image = File(file.path!);
                                }
                              },
                              child: Text('Select file'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: nameController,
                      maxLength: 15,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: dlController,
                      maxLength: 20,
                      decoration: InputDecoration(
                          labelText: 'Driving Licencse Number',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: adController,
                      decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: phnController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Phone No.',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty &&
                            ageController.text.isNotEmpty &&
                            dlController.text.isNotEmpty &&
                            adController.text.isNotEmpty &&
                            phnController.text.isNotEmpty
                        && _image.toString().isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmation"),
                                content: Text(
                                    "Are you sure you want to submit these details?"),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.amber),
                                    ),
                                    onPressed: () {
                                      nameController.clear();
                                      ageController.clear();
                                      dlController.clear();
                                      adController.clear();
                                      phnController.clear();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.amber),
                                    ),
                                    onPressed: () async {
                                      // Upload image file to Firebase Storage
                                      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
                                      var storageRef = FirebaseStorage.instance.ref().child('driver_images/$imageName.jpg');
                                      var uploadTask = storageRef.putFile(_image!);
                                      var downloadUrl = await (await uploadTask).ref.getDownloadURL();


                                      firestore.collection("all_posts").add({
                                        "title": nameController.text,
                                        "date": ageController.text,
                                        "comment": dlController.text,
                                        "type": adController.text,
                                        // "phone_no": phnController.text,
                                        // Add image reference to document
                                        "url": downloadUrl.toString(),
                                      });

                                      // firestore.collection("driver_details").add({
                                      //   "name": nameController.text,
                                      //   "age": ageController.text,
                                      //   "driving_licence": dlController.text,
                                      //   "address": adController.text,
                                      //   "phone_no": phnController.text,
                                      //   // Add image reference to document
                                      //   "image": downloadUrl.toString()
                                      // });
                                      Navigator.of(context).pop();
                                      nameController.clear();
                                      ageController.clear();
                                      dlController.clear();
                                      adController.clear();
                                      phnController.clear();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        "Submit Details",
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

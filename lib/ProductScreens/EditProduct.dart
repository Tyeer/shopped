import 'dart:io';

import 'package:chat2/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();


  CollectionReference editproducts= FirebaseFirestore.instance.collection('products');
  Future<void> EditProduct(id, name, location, price, productStatus, description, quantity, condition, category ){
    var dateformat = DateFormat('MMM d, yyyy');
    String date = dateformat.format(DateTime.now()).toString();
    return editproducts.doc(id).update({
      "name": name,
      "price": price,
      "location": location,
      "category": category,
      "description": description,
      "quantity": quantity,
      "condition": condition,
      "productStatus": productStatus,

      "dateAdded" :date,

    }).then((value) => print("${name} details updated successfully")).catchError((error)=>print("${name} details failed to updated: $error"));
  }


  final TextEditingController quantityController = TextEditingController();



  File? _image;
  Future<void> _openImagePicker() async {
    final _picker = ImagePicker();
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
        title: const Center(child: Text('Edit Product'),),
      ),

        body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
    child: ListView(
    children: [

    FutureBuilder<DocumentSnapshot <Map<String, dynamic>>>(
    future: FirebaseFirestore.instance.collection('products').doc(widget.id).get(),
    builder: (_, snapshot) {
      if (snapshot.hasError) {
        print("something is wrong here");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator(),);
      }
      var data = snapshot.data!.data();
      var name= data!['name'];
      var location= data!['location'];
      var price= data!['price'];
      var description= data!['description'];
      var quantity= data!['quantity'];
      var category= data!['category'];
      var condition= data!['condition'];
      var productStatus = data!['productStatus'];

      return
        Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Photo",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium + 3),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        _openImagePicker();
                      },
                      child: Container(
                          height: 30,
                          width: 150,
                          decoration: BoxDecoration(
                            color: SecondaryDarkGrey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Change photo",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: textMedium)),
                            ],
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _openImagePicker();
                  },
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: _image != null
                                ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                                : const Text("No image selected"),
                          )),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    initialValue: name,
                    autofocus: false,
                    onChanged: (value)=> name = value,
                    //SubjectName = value,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Product title required ';
                      }
                    },

                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    initialValue: price,
                    autofocus: false,
                    onChanged: (value)=> price = value,
                    //SubjectName = value,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Product price required ';
                      }
                    },

                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    initialValue: location,
                    autofocus: false,
                    onChanged: (value)=> location =value,
                    //SubjectName = value,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Location required ';
                      }
                    },

                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    initialValue: category,
                    autofocus: false,
                    onChanged: (value)=> category = value,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Category Required ';
                      }
                    },

                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    initialValue: condition,
                    autofocus: false,
                    onChanged: (value)=> condition = value,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Condition Required ';
                      }
                    },

                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    initialValue: productStatus,
                    autofocus: false,
                    onChanged: (value)=> productStatus = value,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Status Required ';
                      }
                    },

                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    initialValue: quantity,
                    autofocus: false,
                    onChanged: (value)=> quantity = value,
                    //SubjectName = value,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Quantity required ';
                      }
                    },

                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    initialValue: description,
                    autofocus: false,
                    onChanged: (value)=> description = value,
                    //SubjectName = value,
                    decoration: const InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintStyle: TextStyle(fontSize: textMedium),
                        hintText: "Title"),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Description required ';
                      }
                    },

                  ),
                ),
                const SizedBox(
                  height: 10,
                ),



                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()){
                        EditProduct (widget.id, name, location, price, productStatus, description, quantity, condition, category);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: PrimaryBlueOcean,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: textMedium,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
    })

    ]))



    );
  }
}

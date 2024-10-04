import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wishlist_app/database/db_wishlist_app.dart';
import 'package:wishlist_app/views/main_page.dart';

class EditDeleteWish extends StatefulWidget {
  const EditDeleteWish(
      {required this.listId,
      required this.wish,
      required this.price,
      required this.quantity,
      required this.picdata,
      required this.targetDate,
      super.key});
  final int listId;
  final String wish;
  final String price;
  final int quantity;
  final Uint8List picdata;
  final String targetDate;

  @override
  State<EditDeleteWish> createState() =>
      _EditDeleteWishState(listId, wish, price, quantity, picdata, targetDate);
}

class _EditDeleteWishState extends State<EditDeleteWish> {
  _EditDeleteWishState(this.listId, this.wish, this.price, this.quantity,
      this.picdata, this.targetDate);
  TextEditingController _wishController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final int listId;
  final String wish;
  final String price;
  final int quantity;
  final Uint8List picdata;
  final String targetDate;
  Uint8List? _imageBytes;
  Uint8List? _bytes;
  int _qtyValue = 1;

  @override
  void initState() {
    super.initState();
    _wishController.text = wish;
    _priceController.text = price;
    _dateController.text = targetDate;
    _qtyValue = quantity;
    _bytes = picdata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(
          "Edit your wish",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        controller: ScrollController(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 120,
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatefulBuilder(builder: (context, setState) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[300],
                              image: DecorationImage(
                                  image: _bytes != null
                                      ? MemoryImage(_bytes!)
                                      : MemoryImage(Uint8List(0)),
                                  fit: BoxFit.cover),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade500,
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0),
                                BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-4.0, -4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0)
                              ]),
                        );
                      }),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              fromGallery();
                            },
                            icon: Icon(
                              Icons.folder,
                              size: 30,
                              color: Colors.grey[800],
                            ),
                            label: Text(
                              'From Gallery',
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              fromCamera();
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.grey[800],
                            ),
                            label: Text(
                              'From Camera',
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0)
                            ]),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          controller: _wishController,
                          decoration: InputDecoration(
                              labelText: 'Enter your wish...',
                              hintText: 'e.g. buy a house',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 18,
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your wish';
                            }
                            return null;
                          },
                        ),
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade500,
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0),
                                BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-4.0, -4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0)
                              ]),
                          child: Column(
                            children: [
                              Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  Container(
                                    child: NumberPicker(
                                      axis: Axis.horizontal,
                                      itemHeight: 45,
                                      itemWidth: 45,
                                      itemCount: 7,
                                      value: _qtyValue,
                                      minValue: 1,
                                      maxValue: 100,
                                      onChanged: (v) {
                                        setState(() {
                                          _qtyValue = v;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        );
                      }),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0)
                            ]),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          controller: _priceController,
                          decoration: InputDecoration(
                              labelText: 'Price...',
                              hintText: 'e.g. Rp23.450.000,00',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 18,
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the price';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade500,
                                    offset: Offset(4.0, 4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0),
                                BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-4.0, -4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0)
                              ]),
                          child: TextField(
                              controller:
                                  _dateController, //editing controller of this TextField
                              decoration: const InputDecoration(
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText: "Enter Date" //label text of field
                                  ),
                              readOnly: true, // when true user cannot edit text
                              onTap: () async {
                                var pickedDate = await selectDate();
                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2022-07-04
                                  //You can format date as per your need

                                  setState(() {
                                    _dateController.text =
                                        formattedDate; //set foratted date to TextField value.
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              })),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade500,
                                offset: Offset(4.0, 4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0),
                            BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4.0, -4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0)
                          ]),
                      child: IconButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await DbWLApp().updateList(listId,
                                  userId: 1,
                                  wish: _wishController.text,
                                  quantity: _qtyValue,
                                  price: _priceController.text,
                                  picdata: _bytes,
                                  targetDate: _dateController.text);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainPage(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          icon: Icon(
                            Icons.check_rounded,
                            color: Colors.black,
                            size: 50,
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade500,
                                offset: Offset(4.0, 4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0),
                            BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4.0, -4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0)
                          ]),
                      child: IconButton(
                          onPressed: () async {
                            await DbWLApp().deleteList(listId);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.black,
                            size: 50,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future fromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageBytes = await image.readAsBytes();
      setState(() {
        _bytes = _imageBytes;
      });
    }
  }

  Future fromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _imageBytes = await image.readAsBytes();
      setState(() {
        _bytes = _imageBytes;
      });
    }
  }

  Future<DateTime?> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    return pickedDate;
  }
}

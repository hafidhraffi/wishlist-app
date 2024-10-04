import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wishlist_app/database/db_wishlist_app.dart';
import 'package:wishlist_app/views/edit_delete_wish.dart';

class allList extends StatefulWidget {
  const allList({super.key});

  @override
  State<allList> createState() => _allListState();
}

class _allListState extends State<allList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10),
      children: [
        FutureBuilder<List<Map<String, dynamic>>>(
            future: DbWLApp().getListsByUserId(1),
            builder: (context, snapshot) {
              List<Map<String, dynamic>> dataList = snapshot.data ?? [];
              return ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(),
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return _listBox(dataList, index);
                },
              );
            }),
      ],
    );
  }

  Widget _listBox(list, index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditDeleteWish(
                    listId: list[index]['id'],
                    wish: list[index]['wish'],
                    price: list[index]['price'],
                    quantity: list[index]['quantity'],
                    picdata: list[index]['picdata'] != null
                        ? list[index]['picdata'] as Uint8List
                        : Uint8List(0),
                    targetDate: list[index]['target_date'],
                  )),
        );
      },
      child: Container(
        height: 120,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: list[index]['is_checked'] == 0
                ? Colors.grey[100]
                : Colors.grey[300],
            image: DecorationImage(
              image: list[index]['picdata'] != null
                  ? MemoryImage(list[index]['picdata'])
                  : MemoryImage(Uint8List(0)),
              fit: BoxFit.cover,
              // opacity: 0.6
            ),
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
        child: Row(
          children: [
            Checkbox(
              value: list[index]['is_checked'] == 1 ? true : false,
              onChanged: (bool? value) {
                setState(() {
                  DbWLApp().updateIsCheckedField(
                      list[index]['id'], value == true ? 1 : 0);
                });
              },
              activeColor: Colors.grey[800],
              checkColor: Colors.amber,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 10),llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll
            //   width: 80,
            //   height: 80,
            //   decoration: BoxDecoration(
            //     color: list[index]['is_checked'] == 1 &&
            //             list[index]['picdata'] == null
            //         ? Colors.grey[100]
            //         : Colors.grey[300],
            //     borderRadius: BorderRadius.circular(15),
            //     image: DecorationImage(
            //         image: list[index]['picdata'] != null
            //             ? MemoryImage(list[index]['picdata'])
            //             : MemoryImage(Uint8List(0)),
            //         fit: BoxFit.cover),
            //   ),
            // ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.only(left: 10),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white70,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(list[index]['wish'],
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    Text(
                      "Qty = " + list[index]['quantity'].toString(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Price/Qty = " + list[index]['price'],
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Target date = " + list[index]['target_date'],
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wishlist_app/views/add_wish.dart';
import 'package:wishlist_app/views/all_list.dart';
import 'package:wishlist_app/views/checked_list.dart';
import 'package:wishlist_app/views/profile.dart';
import 'package:wishlist_app/views/unchecked_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController?.index = 0;
    tabController?.addListener(() {
      setState(() {
        tabController?.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text(
          "My Wish Lists",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700),
        ),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 10),
        //     child: profileButton(),
        //   ),
        // ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        type: BottomNavigationBarType.fixed,
        currentIndex: tabController!.index,
        selectedItemColor: Colors.grey[800],
        selectedIconTheme: IconThemeData(size: 30),
        selectedFontSize: 15,
        onTap: (int newIndex) {
          setState(() {
            tabController!.index = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'All lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outline_blank_rounded),
            label: 'Unchecked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Checked',
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          allList(),
          UncheckedList(),
          checkedList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWish()),
          );
        },
        shape: CircleBorder(),
        backgroundColor: Colors.amber,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget profileButton() {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
      },
      icon: const Icon(Icons.account_circle_outlined),
      iconSize: 40,
      color: Colors.black,
    );
  }
}

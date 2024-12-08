import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/colors.dart';
import 'package:todo_app/create_page.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/provider.dart';
import 'package:todo_app/seeAll_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<Services>(context, listen: false).getData();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _bottomSheetController;

  @override
  Widget build(BuildContext context) {
    List l_data = Provider.of<Services>(context).l_data;
    final provider = Provider.of<Services>(context, listen: false);
  
    return Scaffold(
      key: _key,
      backgroundColor: KBlackColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: KOrangeColor,
        onPressed: () {

          if (_bottomSheetController != null) {
            // Close the BottomSheet if it's open
            _bottomSheetController!.close();
            _bottomSheetController = null;
          } else {
            // Open the BottomSheet
            _bottomSheetController = _key.currentState!.showBottomSheet(
              (context) => CreatePage(),
            );

            // Reset the controller when BottomSheet closes
            _bottomSheetController!.closed.then((_) {
              _bottomSheetController = null;
            });
          }
        },
        child: Icon(
          Icons.add,
          color: KWhiteColor,
        ),
      ),
      appBar: AppBar(
        backgroundColor: KBlackColor,
        centerTitle: true,
        foregroundColor: KWhiteColor,
        surfaceTintColor: KBlackColor,
        title: Column(
          children: [
            Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 16),
            ),
            Text("Todo App")
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: KOrangeColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(
                      DateTime.now(),
                    ),
                    style: TextStyle(color: KWhiteColor),
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: KBlack2Color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: () {
                      provider.getData();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: KWhiteColor,
                    )),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "Today Task's",
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: KOrangeColor, borderRadius: BorderRadius.circular(12)),
                    child: Text("${l_data.length}"),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: KBlack2Color,borderRadius: BorderRadius.circular(10)),
                  child: GestureDetector(
                    child: Text("See All"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllPage(),
                          ));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: l_data.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = l_data.reversed.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: KBlack2Color,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              data['title'],
                              style: TextStyle(
                                  fontSize: 20,
                                  decoration: data['is_completed']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['description'],
                                style: TextStyle(color: KGreyColor),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat.yMMMEd()
                                  .format(DateTime.parse(data['created_at']))
                                  .toString(),
                              style: TextStyle(color: KGreyColor),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {

                                  _key.currentState!.showBottomSheet((context) => CreatePage(itemData: data));
                                  provider.getData();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: KWhiteColor,
                                )),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: KBlack2Color,
                                        icon: Icon(
                                          Icons.warning_amber_rounded,
                                          size: 40,
                                          color: KRedColor,
                                        ),
                                        title: Align(
                                            child: Text(
                                          "Alert",
                                          style: TextStyle(color: KGreyColor),
                                        )),
                                        content: Text("Are you Sure?"),
                                        actions: [
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: KRedColor,
                                              ),
                                              onPressed: () {
                                                provider.deleteData(
                                                    id: data['_id']);
                                                Navigator.pop(context);
                                                provider.getData();
                                              },
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: KWhiteColor),
                                              )),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: KBlackColor,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: KWhiteColor),
                                              )),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: KWhiteColor,
                                )),
                            Checkbox(
                              side: BorderSide(color: KWhiteColor),
                              activeColor: KOrangeColor,
                              value: data['is_completed'],
                              onChanged: (val) {
                                provider.isCompleteTask(
                                    check: val!, data: data);
                                provider.getData();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}

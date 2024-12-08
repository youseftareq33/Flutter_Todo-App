import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/colors.dart';
import 'package:todo_app/create_page.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/provider.dart';


class SeeAllPage extends StatefulWidget {
  const SeeAllPage({super.key});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  

  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    List l_data= Provider.of<Services>(context).all_data;
    final provider=Provider.of<Services>(context, listen: false);
    return Scaffold(
      key: _key,
      backgroundColor: KBlackColor,
      appBar: AppBar(
        backgroundColor: KBlackColor,
        centerTitle: true,
        foregroundColor: KWhiteColor,
        surfaceTintColor: KBlackColor,
        title: Text("All Task's", style: TextStyle(color: KWhiteColor),),
        actions: [
          IconButton(
                    onPressed: () {
                      provider.getData();
                    },
                    icon: Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['description'],
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(DateFormat.yMMMEd()
                                .format(DateTime.parse(data['created_at']))
                                .toString()),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  _key.currentState!.showBottomSheet((context) => CreatePage(itemData: data));
                                  provider.getData();
                                },
                                icon: Icon(Icons.edit, color: KWhiteColor,)),
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
                                icon: Icon(Icons.delete, color: KWhiteColor,)),
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
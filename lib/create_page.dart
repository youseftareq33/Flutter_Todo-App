import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo_app/colors.dart';
import 'package:todo_app/provider.dart';

class CreatePage extends StatefulWidget {
  Map? itemData;
  CreatePage({super.key, this.itemData});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController title_controller = TextEditingController();
  TextEditingController desc_controller = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    final data = widget.itemData;
    if (data != null) {
      isEdit = true;
      title_controller.text = data!['title'];
      desc_controller.text = data!['description'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Services>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          color: KBlack3Color,
          border: Border(top: BorderSide(width: 3, color: KOrangeColor)),
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),),
      ),
      child: Padding(
        padding: EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Task Title"),
              SizedBox(
                height: 12,
              ),
              TextField(
                controller: title_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: KBlack2Color,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: KOrangeColor)),
                  hintText: " Type Title here ...",
                  hintStyle: TextStyle(color: KGreyColor),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text("Task Description"),
              SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 5,
                controller: desc_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: KBlack2Color,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: KOrangeColor)),
                  hintText: " Type Description here ...",
                  hintStyle: TextStyle(color: KGreyColor),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              backgroundColor: KOrangeColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            isEdit
                                ? provider.updateData(
                                    id1: widget.itemData!["_id"],
                                    title: title_controller.text,
                                    desc: desc_controller.text,
                                    context: context)
                                : provider.postData(
                                    title: title_controller.text,
                                    desc: desc_controller.text,
                                    context: context);
                          },
                          child: Text(
                            isEdit ? "Update Task" : "Create Task",
                            style: TextStyle(color: KWhiteColor),
                          ))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

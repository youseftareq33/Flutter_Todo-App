import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/colors.dart';
import 'package:todo_app/home_page.dart';
import 'package:todo_app/provider.dart';

// api website: https://api.nstack.in/swagger#/

void main(){
  runApp(Todo_App());
}

class Todo_App extends StatelessWidget {
  const Todo_App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Services(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: ThemeData(useMaterial3: true, textTheme: Theme.of(context).textTheme.apply(bodyColor: KWhiteColor)),
      ),
    );
  }
}
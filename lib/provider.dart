import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class Services with ChangeNotifier{
  List l_data=[];
  List all_data=[];
  // List get l_data=> _l_data;

  // get
  getData() async {
    var url = Uri.parse("https://api.nstack.in/v1/todos");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      l_data = json['items'];
      final filterList = l_data
          .where(
            (element) => (DateFormat.yMMMEd()
                    .format(DateTime.parse(element['created_at'])) ==
                DateFormat.yMMMEd().format(DateTime.now())),
          )
          .toList();

        
      l_data = filterList;
       
        
      all_data = json['items'];
      print(all_data.toString());
        
      notifyListeners();
    }
  }

  // post
  // post
  Future<void> postData({required String title, required String desc, required BuildContext context}) async{
    final body={
      "title": title,
      "description":desc,
      "is_completed":false
    };
    var url = Uri.parse("https://api.nstack.in/v1/todos");
    var response = await http.post(url,
    headers: {'Content-Type':'application/json'},
    body: jsonEncode(body));

    if(response.statusCode==201){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task Created Successfully"),backgroundColor: Colors.green,));
      getData();
      Navigator.pop(context);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Wrong"),backgroundColor: Colors.red,));
    }
  }

  // put
  updateData({required String id1, required String title, required String desc, required BuildContext context}) async{
    final id=id1;

    final body={
      "title": title,
      "description":desc,
      "is_completed":false
    };

    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    var response = await http.put(url,
    headers: {'Content-Type':'application/json'},
    body: jsonEncode(body));

    if(response.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task Updated Successfully"),backgroundColor: Colors.green,));
      getData();
      Navigator.pop(context);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Wrong"),backgroundColor: Colors.red,));
    }
  }  

  // check complete task
  isCompleteTask({required bool check, required Map<String, dynamic> data}) async {
    final id = data['_id'];
    final body = {
      "title": data['title'],
      "description": data['description'],
      "is_completed": check,
    };

    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    var response = await http.put(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    getData();
  }

  // delete
  deleteData({required String id}) async {
    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    await http.delete(url);

    getData();
  }
}
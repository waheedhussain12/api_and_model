import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/Model_Class.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<ModelClass> ApiList = [];
Future<List<ModelClass>> getApi() async {
  final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));
  var data = jsonDecode(response.body.toString());
  if (response.statusCode == 200) {
    for (Map i in data) {
      ApiList.add(ModelClass.fromJson(i));
    }

    return ApiList;
  } else {
    return ApiList;
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('api with no model name'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getApi(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: ApiList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ApiList[index].id.toString()),
                                Text(ApiList[index].title.toString()),
                                Text(ApiList[index].price.toString()),
                                Text(ApiList[index].description.toString()),
                                Text(ApiList[index].category.toString()),
                                
                                 Container(
                                   height: MediaQuery.of(context).size.height * .4,
                                   width: MediaQuery.of(context).size.width * 2,
                                   child: ListView.builder(

                                       scrollDirection: Axis.horizontal,
                                       itemCount: ApiList[index].image!.length,
                                       itemBuilder: (context, position){

                                         return Card(
                                           elevation: 12,
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(9)
                                           ),
                                           child:  Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Container(
                                               height: MediaQuery.of(context).size.height * .25,
                                               width: MediaQuery.of(context).size.width * .8,
                                               decoration: BoxDecoration(

                                                 image: DecorationImage(
                                                     fit: BoxFit.cover,
                                                     image: NetworkImage(ApiList[index].image![position].toString()))
                                               ),
                                             ),
                                           ),
                                         );

                                       }),
                                 ),
                                Text(ApiList[index].rating!.count.toString()),
                                Text(ApiList[index].rating!.rate.toString()),
                              ],
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}

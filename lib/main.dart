import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:machine_test/api/api.dart';
import 'package:machine_test/api/default_data.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future futureCategories;
  Future? futureSubCategories;
  late Future futureProducts;
  bool subCategoryVisibility = false;
  bool isCategorySelected = false;
  var product;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
    futureProducts = fetchAllProducts();
  }

  Future<List> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl +
        'api/mobile/products?parent_category_id=136&category_id=0&store_id=2&offset=0&limit=20&sort_by=sale_price&sort_type=DESC'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    print(product);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.network(
          'https://cdn.dribbble.com/users/1130356/screenshots/9452991/media/d162e27bb0470ec66439dae67852fb27.jpg?compress=1&resize=400x300',
          height: 80,
          width: 80,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 30),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.category, color: Colors.black, size: 30),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 46,
                    child: FutureBuilder(
                      future: futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List categories = snapshot.data as List;
                          print(snapshot.data);
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChoiceChip(
                                  label: Text(
                                    categories[index]['name'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  backgroundColor: Colors.black,
                                  selected: false,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      futureSubCategories = fetchSubCategories(
                                          categories[index]['id']);
                                      subCategoryVisibility = true;
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 246,
                            child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: subCategoryVisibility,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.category, color: Colors.black, size: 30),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 46,
                        child: FutureBuilder(
                          future: futureSubCategories,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List subCategories = snapshot.data as List;
                              print(snapshot.data);
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: subCategories.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ChoiceChip(
                                      label: Text(
                                        subCategories[index]['name'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      backgroundColor: Colors.black,
                                      selected: false,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          subCategoryVisibility = true;
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 246,
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            //List products
            FutureBuilder(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List products = snapshot.data as List;
                  return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(products[index]['name']),
                            // leading: products[index]['images'].isNotEmpty
                            //     ? Image.network(
                            //         baseUrl+products[index]['images'][0]['image_url'].toString(),
                            //         height: 50,
                            //         width: 50,
                            //       )
                            //     : Image.network(
                            //         'https://cdn.dribbble.com/users/1130356/screenshots/9452991/media/d162e27bb0470ec66439dae67852fb27.jpg?compress=1&resize=400x300',
                            //         height: 50,
                            //         width: 50,
                            //       ),
                            trailing: Text(products[index]['price']
                                    ['sale_price']
                                .toString()),
                          ));
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 246,
                    child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

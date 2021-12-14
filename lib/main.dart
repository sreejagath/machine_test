import 'package:flutter/material.dart';
import 'package:machine_test/api/api.dart';

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
  Future? futuresubCategoryProducts;
  bool subCategoryVisibility = false;
  bool showCategoryBasedProducts = false;
  int? categoryId;
  int? subCategoryId;
  int currentMax = 20;
  int limit = 20;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
    futureProducts = fetchAllProducts(limit);
    
  }


  @override
  Widget build(BuildContext context) {
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
          icon: const Icon(Icons.menu, color: Colors.red, size: 30),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.red, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.category, color: Colors.redAccent, size: 30),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 46,
                    child: FutureBuilder(
                      future: futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List categories = snapshot.data as List;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChoiceChip(
                                  label: Text(
                                    categories[index]['name'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  backgroundColor: Colors.black,
                                  selected: false,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      futureSubCategories = fetchSubCategories(
                                          categories[index]['id']);
                                      subCategoryVisibility = true;
                                      showCategoryBasedProducts = false;
                                      categoryId = categories[index]['id'];
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 246,
                            child: const CircularProgressIndicator());
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
                      const Icon(Icons.category, color: Colors.red, size: 30),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 46,
                        child: FutureBuilder(
                          future: futureSubCategories,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List subCategories = snapshot.data as List;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: subCategories.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ChoiceChip(
                                      label: Text(
                                        subCategories[index]['name'],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      backgroundColor: Colors.black,
                                      selected: false,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          subCategoryVisibility = true;
                                          showCategoryBasedProducts = true;
                                          subCategoryId =
                                              subCategories[index]['id'];
                                          futuresubCategoryProducts =
                                              fetchSubCategoryProducts(
                                                  categoryId!, subCategoryId!);
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width - 246,
                                child: const CircularProgressIndicator());
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            showCategoryBasedProducts
                ? FutureBuilder(
                    future: futuresubCategoryProducts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List products = snapshot.data as List;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                products[index]['name'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${products[index]['sort_price']} SAR',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(Icons
                                                      .favorite_border_sharp)),
                                              CircleAvatar(
                                                backgroundColor: Colors.green,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon:
                                                        const Icon(Icons.add)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                )
                                
                                );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 246,
                          child: const CircularProgressIndicator());
                    },
                  )
                : FutureBuilder(
                    future: futureProducts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List products = snapshot.data as List;
                        
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: limit,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                products[index]['name'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${products[index]['price']['sale_price']} SAR',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(Icons
                                                      .favorite_border_sharp)),
                                              CircleAvatar(
                                                backgroundColor: Colors.green,
                                                child: IconButton(
                                                    onPressed: () {},
                                                    icon:
                                                        const Icon(Icons.add)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                )
                                );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 246,
                          child: const CircularProgressIndicator());
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

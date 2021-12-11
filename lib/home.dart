import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:machine_test/api/default_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl +
        'api/mobile/products?parent_category_id=136&category_id=0&store_id=2&offset=0&limit=20&sort_by=sale_price&sort_type=DESC'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  fetchCategories() async {
    final response =
        await http.get(Uri.parse(baseUrl + 'api/mobile/categories'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  fetchSubCategories(int parentId) async {
    final response = await http.get(
        Uri.parse(baseUrl + 'api/mobile/subcategories?parent_id=$parentId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
      
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          
        ],
      ),
    );
  }
}

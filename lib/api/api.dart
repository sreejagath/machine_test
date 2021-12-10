import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:machine_test/api/default_data.dart';

Future fetchAllProducts() async {
  final response = await http.get(Uri.parse(baseUrl +
      'api/mobile/products?parent_category_id=136&category_id=0&store_id=2&offset=0&limit=20&sort_by=sale_price&sort_type=DESC'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future fetchProductDetails(String productId) async {
  final response = await http.get(Uri.parse(baseUrl +'api/mobile/products?category_id=190&store_id=2&offset=0&limit=20&sort_by=sale_price&sort_type=DESC'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future fetchCategories() async {
  final response = await http.get(Uri.parse(baseUrl + 'api/mobile/categories'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future fetchSubCategories() async {
  final response =
      await http.get(Uri.parse(baseUrl + 'api/mobile/subcategories'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 299.00,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 999.00,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 450.00,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 350.00,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavOnly = false; //+++
  final String authToken;

  Products(this.authToken, this._items);

  List<Product> get items {
    //+++
    // if (_showFavOnly) {
    //   return _items.where((prodItem) => prodItem.isFav).toList();
    // }
    //+++
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isFav).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  //+++
  // void showFav() {
  //   _showFavOnly = true;
  //   notifyListeners();
  // }
  // void showAll() {
  //   _showFavOnly = false;
  //   notifyListeners();
  // }
  //+++

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://shopmart-app-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      // print (json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null)  {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((pId, pData) {
        loadedProducts.add(Product(
          id: pId,
          title: pData['title'],
          description: pData['description'],
          price: pData['price'],
          imageUrl: pData['imageUrl'],
          isFav: pData['isFav'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product prod) async {
    //http post....++++
    final  url =
        'https://shopmart-app-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
          'isFav': prod.isFav,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    //++++

    // final newProduct = Product(
    //     id: DateTime.now().toString(),
    //     title: prod.title,
    //     description: prod.description,
    //     price: prod.price,
    //     imageUrl: prod.imageUrl);
    // _items.add(newProduct);
    // notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shopmart-app-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...just a precaution check');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopmart-app-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProdIndex = _items.indexWhere((element) => element.id == id);
    var existingProd = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProd);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProd = null;

    // _items.removeWhere((prod) => prod.id == id);
    // notifyListeners();
  }
}

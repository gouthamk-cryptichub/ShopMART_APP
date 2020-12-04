import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 299.00,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 999.00,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 450.00,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 350.00,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  // var _showFavOnly = false; //+++

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

  Future<void> addProducts(Product prod) {
    //http post....++++
    const url =
        'https://shopmart-app-default-rtdb.firebaseio.com/products';
    return http
        .post(
      url,
      body: json.encode({
        'title': prod.title,
        'description': prod.description,
        'imageUrl': prod.imageUrl,
        'price': prod.price,
        'isFav': prod.isFav,
      }),
    )
        .then((response) {
          // print(json.decode(response.body)); // => {name : id_chbc}
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error){
      print(error);
      throw error;
    });
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

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...just a precaution check');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}

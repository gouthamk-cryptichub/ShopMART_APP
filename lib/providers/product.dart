import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFav = false});

  Future<void> toggleFavStatus(String authToken, String uId) async{
    final oldStatus = isFav;

    isFav = !isFav;
    notifyListeners();
    final url =
        'https://shopmart-app-default-rtdb.firebaseio.com/userFav/$uId/$id.json?auth=$authToken';
    try{
      final response = await http.put(
        url,
        body: json.encode(isFav),
      );
      if(response.statusCode >= 400) {
        isFav = oldStatus;
        notifyListeners();
      }
    }catch(error) {
      isFav = oldStatus;
      notifyListeners();
    }
  }
}

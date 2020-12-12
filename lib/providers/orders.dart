import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amt;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amt,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String uId;

  Orders(this.authToken, this.uId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shopmart-app-default-rtdb.firebaseio.com/orders/$uId.json?auth=$authToken';
    final respone = await http.get(url);
    // print(json.decode(respone.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(respone.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amt: orderData['amount'],
          products: (orderData['products'] as List<dynamic>).map(
            (item) => CartItem(
              id: item['id'],
              title: item['title'],
              price: item['price'],
              quantity: item['quanity'],
            ),
          ).toList(),
          dateTime: DateTime.parse(orderData['dataTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shopmart-app-default-rtdb.firebaseio.com/orders/$uId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dataTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amt: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}

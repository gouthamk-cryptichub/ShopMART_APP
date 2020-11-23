import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get item {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmt {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String pId, String pTitle, double pPrice) {
    if (_items.containsKey(pId)) {
      _items.update(
          (pId),
          (exesistingCartItem) => CartItem(
              id: exesistingCartItem.id,
              title: exesistingCartItem.title,
              price: exesistingCartItem.price,
              quantity: exesistingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
        pId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: pTitle,
            price: pPrice,
            quantity: 1),
      );
    }

    notifyListeners();
  }
  
  void removeItem(String pId) {
    _items.remove(pId);
    notifyListeners();
  }

    void clearCart() {
      _items = {};
      notifyListeners();
    }
}

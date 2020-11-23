import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String cartId;
  final String prodId;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.cartId, this.prodId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartId),
      direction: DismissDirection.endToStart,
      background: Container(
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 35,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Colors.redAccent,
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(child: Text('₹$price')),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: ₹${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';
import '../widgets/app_drawer.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Chip(
                      label: Text('₹${cart.totalAmt.toStringAsFixed(2)}'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: OrderButton(cart: cart),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.item.length,
                itemBuilder: (ctx, i) => ci.CartItem(
                    cart.item.values.toList()[i].id,
                    cart.item.keys.toList()[i],
                    cart.item.values.toList()[i].title,
                    cart.item.values.toList()[i].price,
                    cart.item.values.toList()[i].quantity)),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmt<= 0 || _isLoading)  ? null : () async{
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false)
            .addOrder(widget.cart.item.values.toList(), widget.cart.totalAmt);
        setState(() {
          _isLoading = false;
        });
        widget.cart.clearCart();
      },
      child: _isLoading? CircularProgressIndicator() : Text('Check out'),
    );
  }
}

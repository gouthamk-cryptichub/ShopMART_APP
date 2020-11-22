import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../providers/products_provider.dart';

enum FilterOpt {
  Fav,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showonlyFav = false;
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context); //+++
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ShopMART',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favs'), value: FilterOpt.Fav),
              PopupMenuItem(child: Text('Show all '), value: FilterOpt.All),
            ],
            onSelected: (FilterOpt selectedValue) {
              //+++
              // if (selectedValue == FilterOpt.Fav) {
              //   productsContainer.showFav(); //+++
              // } else {
              //   productsContainer.showAll(); //+++
              // }
              //+++
              setState(() {
                selectedValue == FilterOpt.Fav ? _showonlyFav = true : _showonlyFav = false;
              });
            },
          ),
        ],
      ),
      body: ProductsGrid(_showonlyFav),
    );
  }
}

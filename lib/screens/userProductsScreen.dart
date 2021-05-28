import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/productProvider.dart';
import 'package:shop_app/widget/appDrawer.dart';
import 'package:shop_app/widget/userProductItems.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (context, index) => Column(
            children: [
              UserProductItem(
                  products.items[index].title, products.items[index].imageUrl),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/productProvider.dart';
import 'package:shop_app/screens/editProductScreen.dart';
import 'package:shop_app/widget/appDrawer.dart';
import 'package:shop_app/widget/userProductItems.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<ProductProvider>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (context, index) => Column(
              children: [
                UserProductItem(
                    products.items[index].id,
                    products.items[index].title,
                    products.items[index].imageUrl),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

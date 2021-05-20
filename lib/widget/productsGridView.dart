import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './productItem.dart';
import '../provider/productProvider.dart';


class ProductsGridView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    final products = productData.items;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ProductItem(products[index].id,
            products[index].title, products[index].imageUrl),
        itemCount: products.length,
      ),
    );
  }
}

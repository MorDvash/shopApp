import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './productItem.dart';
import '../provider/productProvider.dart';


class ProductsGridView extends StatelessWidget {
  final bool showOnlyFavorites;

  ProductsGridView(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    final products = showOnlyFavorites ? productData.favorites : productData.items;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) =>
        // להשתמש כאשר משתמשים ברשימה כדי למנוע באגים
            ChangeNotifierProvider.value(value: products[index],
                child: ProductItem()),
        itemCount: products.length,
      ),
    );
  }
}

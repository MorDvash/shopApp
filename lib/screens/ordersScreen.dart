import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/ordersProvider.dart';
import 'package:shop_app/widget/appDrawer.dart';
import 'package:shop_app/widget/orderItem.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My-Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (context, index) =>
            OrderItemWidget(ordersData.orders[index]),
      ),
    );
  }
}

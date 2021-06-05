import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/ordersProvider.dart';
import 'package:shop_app/widget/appDrawer.dart';
import 'package:shop_app/widget/orderItem.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    //כדי שתיהיה גישה לcontext
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<OrdersProvider>(context, listen: false)
          .fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My-Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (context, index) =>
                  OrderItemWidget(ordersData.orders[index]),
            ),
    );
  }
}

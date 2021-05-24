import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeCart(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(String productId, String title, double price,) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (exsistingCartItem) =>
          CartItem(id: exsistingCartItem.id,
              title: exsistingCartItem.title,
              quantity: exsistingCartItem.quantity + 1,
              price: exsistingCartItem.price));
    } else {
      _items.putIfAbsent(productId, () =>
          CartItem(id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  clearCart(){
    _items = {};
    notifyListeners();
  }

}
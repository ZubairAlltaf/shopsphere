import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(List<CartItem> items, double total) {
    _orders.add(Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      total: total,
      date: DateTime.now(),
    ));
    notifyListeners();
  }
}
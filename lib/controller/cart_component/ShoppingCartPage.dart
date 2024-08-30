

import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<CartItem> cartItems = [
    CartItem(name: 'Product 1', price: 29.99),
    CartItem(name: 'Product 2', price: 19.99),
    CartItem(name: 'Product 3', price: 9.99),
  ];

  double get totalPrice => cartItems.fold(0, (total, item) => total + (item.price * item.quantity));

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Items: ${cartItems.length}',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.shopping_bag, size: 40),
                    title: Text(cartItems[index].name),
                    subtitle: Text('Price: \$${cartItems[index].price.toStringAsFixed(2)}'),
                    trailing: Container(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () => _decreaseQuantity(index),
                          ),
                          Text('${cartItems[index].quantity}'),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () => _increaseQuantity(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

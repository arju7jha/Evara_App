import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controller/UserController.dart';

class OrderScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  Future<List<dynamic>> fetchOrders() async {
    final userId = userController.userId.value;
    final String url = 'https://namami-infotech.com/EvaraBackend/src/order/get_orders.php?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['orders'];
        } else {
          throw Exception('Failed to load orders');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Widget buildOrderCard(Map<String, dynamic> order, BuildContext context) {
    return Card(
      elevation: 4,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        childrenPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order ID: ${order['orderId']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Chip(
              label: Text(
                order['status'],
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: order['status'] == 'rejected'
                  ? Colors.red
                  : order['status'] == 'Accepted'
                  ? Colors.green
                  : Colors.orange,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(Icons.currency_rupee, color: Colors.green, size: 18),
              SizedBox(width: 5),
              Text(
                '${order['total_amount']}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Icon(Icons.date_range, color: Colors.blue, size: 18),
              SizedBox(width: 5),
              Text(
                '${order['order_date']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        children: [
          Divider(thickness: 3.0,color: Colors.teal),
          Row(
            children: [
              Icon(Icons.delivery_dining, color: Colors.purple, size: 18),
              SizedBox(width: 5),
              Text(
                'Reach by: ${order['reachby_date'] ?? 'Not Available'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Products:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Column(
            children: List.generate(order['products'].length, (index) {
              final product = order['products'][index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Product ID: ${product['product_id']}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      'Qty: ${product['net_quantity']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }),
          ),
          Divider(thickness: 3.0,color: Colors.teal),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remark: ${order['remark'] ?? 'None'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                'POD: ${order['pod'] ?? 'Not Available'}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No orders found'));
                  } else {
                    final orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return buildOrderCard(orders[index], context);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



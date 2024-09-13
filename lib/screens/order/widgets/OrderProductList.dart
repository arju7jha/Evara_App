import 'package:flutter/material.dart';
import 'helpers.dart';

class OrderProductList extends StatelessWidget {
  final List<dynamic> products;

  const OrderProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Products:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        buildProductHeaders(),
        Column(
          children: List.generate(products.length, (index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  buildExpandedText('${product['product_name']}', flex: 5),
                  buildExpandedText('${product['buy_quantity']}', flex: 2, center: true),
                  buildExpandedText('${product['offer_quantity']}', flex: 2, center: true),
                  buildExpandedText('${product['net_quantity']}', flex: 2, center: true),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildProductHeaders() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text('Product Name', style: _headerTextStyle)),
          SizedBox(width: 10),
          Expanded(flex: 2, child: Text('Buy Qt.', style: _headerTextStyle, textAlign: TextAlign.center)),
          SizedBox(width: 10),
          Expanded(flex: 2, child: Text('Offer Qt.', style: _headerTextStyle, textAlign: TextAlign.center)),
          SizedBox(width: 10),
          Expanded(flex: 2, child: Text('Net Qt.', style: _headerTextStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  static const TextStyle _headerTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.teal,
  );
}

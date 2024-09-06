import 'package:flutter/material.dart';

import '../../controller/cart_component/ShoppingCartPage.dart';
import '../home/home_page.dart';

class AllProductsPage extends StatelessWidget {
  final String title;
  final List<dynamic> products;

  AllProductsPage({required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add_shopping_cart_outlined, size: 30, color: Colors.orange,),
            padding: EdgeInsets.only(right: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final offer = determineOffer(product);
            return ProductCard(
              medicineId: product['medicine_id'].toString(),
              imagePath: product['image_url'] ?? '',
              name: product['name'] ?? '',
              mrp: '${product['mrp'] ?? '0.00'}',
              ptr: '${product['ptr'] ?? '0.00'}',
              sellingPrice: '${product['selling_price'] ?? '0.00'}',
              companyName: product['company_name'] ?? '',
              productDetails: product['product_details'] ?? '',
              salts: product['salts'] ?? '',
              offer: offer,
            );
          },
        ),
      ),
    );
  }

  String determineOffer(Map<String, dynamic> product) {
    final sellingPrice = product['selling_price'] ?? '0.00';
    final ptr = product['ptr'] ?? '0.00';
    final discount = product['discount'] ?? '0.00';
    final formattedOffer = product['formatted_offer'] ?? '';

    if (sellingPrice == '0.00' && ptr != '0.00') {
      return formattedOffer.isNotEmpty
          ? formattedOffer
          : ''; //return discount.isNotEmpty ? discount : '';
    } else if (ptr == '0.00' && sellingPrice != '0.00') {
      return discount.isNotEmpty
          ? discount
          : ''; //return formattedOffer.isNotEmpty ? formattedOffer : '';
    } else {
      return '';
    }
  }

}

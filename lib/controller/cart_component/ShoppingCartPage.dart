import 'package:evara/controller/cart_component/summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:evara/controller/cart_component/CartController.dart';
import '../../screens/widgets/product_details.dart';
import '../UserController.dart';


class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    // final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Obx(() {
                return Text(
                  'Items: ${cartController.cartItems.length}',
                  style: const TextStyle(fontSize: 18),
                );
              }),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final cartItems = cartController.cartItems;

        // If no items are in the cart, show a "No items available" message
        if (cartItems.isEmpty) {
          return const Center(
            child: Text(
              'No items available',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final medicineId = cartItems.keys.elementAt(index);
            final productDetails = cartItems[medicineId]!;
            final quantity = productDetails['quantity'] as int;

            final ptr = productDetails['ptr'] ?? '0';
            final sellingPrice = productDetails['sellingPrice'] ?? '0';
            final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0) ? ptr : sellingPrice;

            final price = double.tryParse(displayPrice) ?? 0;
            final totalAmount = (price * quantity).toStringAsFixed(2);

            return GestureDetector(
              onTap: () {
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        imagePath: productDetails['imagePath'] ?? '',
                        name: productDetails['name'] ?? '',
                        mrp: productDetails['mrp'] ?? '',
                        ptr: productDetails['ptr'] ?? '',
                        companyName: productDetails['companyName'] ?? '',
                        productDetails: productDetails['productDetails'] ?? '',
                        salts: productDetails['salts'] ?? '',
                        offer: productDetails['offer'] ?? '',
                        medicineId: medicineId,
                        sellingPrice: sellingPrice,
                      ),
                    ),
                  );
                } catch (e) {
                  // Show error if navigation fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to load product details.')),
                  );
                }
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          productDetails['imagePath'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, size: 70, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  productDetails['name'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  try {
                                    cartController.removeCartItem(medicineId);
                                  } catch (e) {
                                    // Handle error when removing item
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed to remove item.')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  'Amount: $totalAmount',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.blue),
                                      onPressed: () {
                                        if (quantity > 1) {
                                          cartController.updateCartItem(medicineId, productDetails, quantity - 1);
                                        }
                                      },
                                    ),
                                    Container(
                                      width: 40,
                                      height: 30,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                        ),
                                        controller: TextEditingController(text: quantity.toString()),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,  // Allow only digits
                                          LengthLimitingTextInputFormatter(3),     // Limit to 3 digits
                                        ],
                                        onSubmitted: (value) {
                                          final newQuantity = int.tryParse(value) ?? 0;
                                          cartController.updateCartItem(medicineId, productDetails, newQuantity);
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                                      onPressed: () {
                                        cartController.updateCartItem(medicineId, productDetails, quantity + 1);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        final cartItems = cartController.cartItems;
        if (cartItems.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                'Cart is empty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        final totalPrice = cartItems.entries.fold(0.0, (total, entry) {
          final ptr = entry.value['ptr'] ?? '0';
          final sellingPrice = entry.value['sellingPrice'] ?? '0';
          final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0) ? ptr : sellingPrice;
          final price = double.tryParse(displayPrice) ?? 0;
          return total + (price * entry.value['quantity']);
        });

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10.0)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              ElevatedButton(
                onPressed: cartItems.isNotEmpty
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutSummaryPage()),
                  );
                }
                    : null, // Disable button if cart is empty
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: cartItems.isNotEmpty ? Colors.teal : Colors.grey, // Change color when disabled
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

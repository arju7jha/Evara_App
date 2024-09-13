import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'OrderProductList.dart';
import 'helpers.dart';


class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({required this.order});

  void _showPOD(BuildContext context, String? pod) {
    if (pod != null && pod.startsWith('data:image')) {
      final base64Image = pod.split(',')[1];
      final imageBytes = base64Decode(base64Image);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("POD Image")),
            body: Center(child: Image.memory(imageBytes)),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("POD Not Available"),
          content: const Text("Proof of Delivery is not available for this order."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
    }
  }

  void _downloadInvoice(String invoiceUrl) {
    FileDownloader.downloadFile(
      url: invoiceUrl,
      onDownloadCompleted: (path) {
        Get.snackbar(
          'Download Complete',
          'Invoice downloaded at $path',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.black,
          margin: const EdgeInsets.all(16.0),
          borderRadius: 8.0,
          icon: const Icon(Icons.save_alt_outlined, color: Colors.green),
          duration: const Duration(seconds: 1),
        );
      },
      onDownloadError: (error) {
        Get.snackbar(
          'Download Failed',
          'Unable to download invoice',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.black,
          margin: const EdgeInsets.all(16.0),
          borderRadius: 8.0,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 1),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String status = order['status'].toString().toUpperCase();
    String? invoiceUrl = order['invoice_url'];

    return Card(
      elevation: 4,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order ID: ${order['orderId']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                if (invoiceUrl != null && invoiceUrl.isNotEmpty)
                  GradientButton(
                    label: 'Invoice',
                    onPressed: () => _downloadInvoice(invoiceUrl),
                  ),
                Chip(
                  label: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: getStatusColor(status),
                ),
              ],
            ),
          ],
        ),
        subtitle: buildOrderSubtitle(order),
        children: [
          const Divider(thickness: 3.0, color: Colors.teal),
          CustomRow(
            icon: Icons.delivery_dining,
            text: 'Reach by: ${order['reachby_date'] ?? 'Not Available'}',
          ),
          const SizedBox(height: 8),
          OrderProductList(products: order['products']),
          const Divider(thickness: 3.0, color: Colors.teal),
          const SizedBox(height: 10),
          buildRemarkSection(context, order),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildOrderSubtitle(Map<String, dynamic> order) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const Icon(Icons.currency_rupee, color: Colors.green, size: 18),
          const SizedBox(width: 5),
          Text(
            '${order['total_amount']}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          const Icon(Icons.date_range, color: Colors.blue, size: 18),
          const SizedBox(width: 5),
          Text(
            '${order['order_date'].split(' ')[0]}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget buildRemarkSection(BuildContext context, Map<String, dynamic> order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 7,
          child: Text(
            'Remark: ${order['remark'] ?? 'None'}',
            style: TextStyle(fontSize: 14, color: Colors.grey[900]),
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: GradientButton(
              label: 'POD',
              onPressed: () => _showPOD(context, order['pod']),
            ),
          ),
        ),
      ],
    );
  }
}

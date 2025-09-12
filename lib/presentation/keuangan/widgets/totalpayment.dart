import 'package:flutter/material.dart';
import 'package:guardian_app/routes/app_routes.dart';
import 'package:intl/intl.dart'; // Import for currency formatting

// This widget now accepts a `paidAmount` to display dynamic data from the API.
class TotalPaymentCard extends StatelessWidget {
  final double paidAmount;

  const TotalPaymentCard({
    Key? key,
    required this.paidAmount,
  }) : super(key: key);

  // Helper function to format the amount into Indonesian Rupiah currency format.
  String _formatCurrency(double amount) {
    final format =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  _formatCurrency(
                      paidAmount), // Display the dynamic, formatted value.
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          IntrinsicWidth(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.riwayatPembayaran);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A4C93),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              ),
              child: const Text(
                'Riwayat Pembayaran',
                softWrap: false,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:guardian_app/routes/app_routes.dart';

class TotalPaymentCard extends StatelessWidget {
  const TotalPaymentCard({Key? key}) : super(key: key);

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
          const Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pembayaran',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  'Rp 1.200.000',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15), // Spacing yang lebih besar
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

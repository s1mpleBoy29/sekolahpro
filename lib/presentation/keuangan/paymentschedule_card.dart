import 'package:flutter/material.dart';

class PaymentScheduleCard extends StatelessWidget {
  final String? dueDate;
  final String amount;
  final String description;
  final String status;
  final Color statusColor;
  final bool isOverdue;

  const PaymentScheduleCard({
    Key? key,
    this.dueDate,
    required this.amount,
    required this.description,
    required this.status,
    required this.statusColor,
    this.isOverdue = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tentukan dekorasi dan warna berdasarkan status overdue
    final Color cardColor = isOverdue ? const Color(0xFFFDE9E9) : Colors.white;
    final BoxBorder cardBorder = isOverdue 
        ? Border.all(color: Colors.red, width: 1.5) 
        : Border.all(color: Colors.grey.shade300);
    final Color titleColor = isOverdue ? Colors.red : Colors.grey.shade600;
    final Color amountColor = isOverdue ? Colors.red : Colors.black;
    final String titleText = isOverdue 
        ? 'Melewati batas waktu pembayaran' 
        : 'Bayar sebelum ${dueDate ?? 'Tidak ada'}';

    // Tentukan style button berdasarkan status - remove this section

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: cardBorder,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: TextStyle(
                    fontSize: 12,
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12, 
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 90, // Fixed width untuk konsistensi ukuran
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: status == 'Lunas' ? Colors.green : Colors.grey.shade400,
                width: 1,
              ),
            ),
            child: Text(
              status,
              textAlign: TextAlign.center, // Menempatkan teks di tengah
              style: TextStyle(
                color: status == 'Lunas' ? Colors.green : Colors.grey.shade600,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
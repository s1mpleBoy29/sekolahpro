import 'package:flutter/material.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Jadwal Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Detail Pembayaran
                  Card(
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailItem(
                            'Deskripsi',
                            'Uang Seragam Chandra Tahun Ajaran 2025 / 2026',
                            hasIcon: true,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem('Nominal', 'Rp 1.200.000'),
                          const SizedBox(height: 16),
                          _buildDetailItem('Kategori', 'PPDB (Penerimaan Peserta Didik Baru)'),
                          const SizedBox(height: 16),
                          _buildDetailItem('Batas Waktu Pembayaran', '30 Juli 2025'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Riwayat Pembayaran Section
                  const Text(
                    'Riwayat Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Payment History Items
                  _buildPaymentHistoryItem(
                    date: '1 Juli 2025',
                    amount: 'Rp 200.000',
                    description: 'Pembayaran Transfer ke BCA #90 00 00',
                    buttonText: 'Detail',
                    buttonColor: Colors.grey[600]!,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  _buildPaymentHistoryItem(
                    date: '30 Juni 2025',
                    amount: 'Rp 1.000.000',
                    description: 'Pembayaran Tunai di kasir #009.009.001',
                    buttonText: 'Unduh Bukti',
                    buttonColor: const Color(0xFF8E44AD),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Action untuk unduh faktur
                print('Unduh Faktur pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E44AD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Unduh Faktur',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool hasIcon = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasIcon)
              Icon(
                Icons.content_copy,
                size: 20,
                color: Colors.grey[400],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentHistoryItem({
    required String date,
    required String amount,
    required String description,
    required String buttonText,
    required Color buttonColor,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                // Action untuk button
                print('$buttonText pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
                minimumSize: const Size(80, 36),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
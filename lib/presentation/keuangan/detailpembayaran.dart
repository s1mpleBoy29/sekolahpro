import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_app/presentation/keuangan/widgets/transaction_history_card.dart';
import 'package:guardian_app/presentation/keuangan/widgets/bottom_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Detail Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: const PaymentDetailPage(),
    );
  }
}

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildDetailItem(
                          context,
                          'Deskripsi',
                          'Uang Seragam Chandra Tahun Ajaran 2025 / 2026',
                          hasIcon: true,
                        ),
                        const Divider(height: 10),
                        _buildDetailItem(context, 'Nominal', 'Rp 1.200.000'),
                        const Divider(height: 10),
                        _buildDetailItem(context, 'Kategori',
                            'PPDB (Penerimaan Peserta Didik Baru)'),
                        const Divider(height: 10),
                        _buildDetailItem(
                            context, 'Batas Waktu Pembayaran', '30 Juli 2025'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Riwayat Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Now this will be perfectly aligned with the title
                  _buildPaymentHistoryItem(
                    date: '1 Juli 2025',
                    amount: 'Rp 200.000',
                    description: 'Pembayaran Transfer ke BCA #90 00 00',
                    buttonText: 'Detail',
                    buttonColor: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  // This one too
                  _buildPaymentHistoryItem(
                    date: '30 Juni 2025',
                    amount: 'Rp 1.000.000',
                    description: 'Pembayaran Tunai di kasir #009.009.001',
                    buttonText: 'Unduh Bukti',
                    buttonColor: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
          isNeeded: false,
          totalAmount:
              1, // TotalAmount tidak digunakan di sini, nilai 1 hanya example
          onContinuePressed: () {
            print('Unduh Faktur ditekan.');
          }),
    );
  }

  // This helper method builds a detail item row
  Widget _buildDetailItem(BuildContext context, String label, String value,
      {bool hasIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
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
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Deskripsi disalin ke clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.content_copy,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryItem({
    required String date,
    required String amount,
    required String description,
    required String buttonText,
    required Color buttonColor,
  }) {
    return TransactionHistoryCard(
      date: date,
      amount: amount,
      description: description,
      buttonText: buttonText,
      buttonColor: buttonColor,
      onPressed: () {
        print('$buttonText pressed for amount $amount');
      },
    );
  }
}

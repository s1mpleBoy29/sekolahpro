import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Import for formatting
// Assuming your files are in these locations, adjust if necessary
import 'package:guardian_app/data/api/detailpayment.dart'; // Import your API service
import 'package:guardian_app/data/models/detailpayment.dart'; // Import your model
import 'package:guardian_app/presentation/keuangan/widgets/transaction_history_card.dart';
import 'package:guardian_app/presentation/keuangan/widgets/bottom_bar.dart';

// Your existing MyApp widget remains the same
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

// Converted to a StatefulWidget to manage state for the API call
class PaymentDetailPage extends StatefulWidget {
  const PaymentDetailPage({Key? key}) : super(key: key);

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  // A Future to hold the result of our API call
  late Future<PaymentDetail?> _paymentDetailFuture;

  @override
  void initState() {
    super.initState();
    _fetchPaymentDetails();
  }

  void _fetchPaymentDetails() {
    // In a real app, these IDs would be passed into the widget
    const String studentId = "TLAB.0001";
    const String tuitionPlanId = "PLAN-TLAB-250822-000731";

    // Call the API and store the Future
    // The model will automatically parse the JSON if the API call is successful
    _paymentDetailFuture =
        getViewJadwalBayar(studentId: studentId, tuitionPlanId: tuitionPlanId)
            .then((data) {
      if (data != null && data.containsKey('message')) {
        return PaymentDetail.fromJson(data);
      }
      return null;
    });
  }

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
      // Use FutureBuilder to handle the async API call
      body: FutureBuilder<PaymentDetail?>(
        future: _paymentDetailFuture,
        builder: (context, snapshot) {
          // --- LOADING STATE ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- ERROR STATE ---
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Gagal memuat data.\nError: ${snapshot.error ?? "Data tidak ditemukan."}',
                textAlign: TextAlign.center,
              ),
            );
          }
          // --- SUCCESS STATE ---
          final paymentDetail = snapshot.data!;
          final currencyFormatter = NumberFormat.decimalPattern('id_ID');
          final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
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
                              paymentDetail.description,
                              hasIcon: true,
                            ),
                            const Divider(height: 10),
                            _buildDetailItem(context, 'Nominal',
                                'Rp ${currencyFormatter.format(paymentDetail.amount)}'),
                            const Divider(height: 10),
                            _buildDetailItem(
                                context, 'Kategori', paymentDetail.category),
                            const Divider(height: 10),
                            _buildDetailItem(context, 'Batas Waktu Pembayaran',
                                dateFormatter.format(paymentDetail.dueDate)),
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
                      // Display a message if there is no payment history
                      if (paymentDetail.history.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Belum ada riwayat pembayaran.'),
                          ),
                        )
                      else
                        // Build the list of payment history items dynamically
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: paymentDetail.history.length,
                          itemBuilder: (context, index) {
                            final item = paymentDetail.history[index];
                            return _buildPaymentHistoryItem(
                              date: item.date,
                              amount:
                                  'Rp ${currencyFormatter.format(item.amount)}',
                              description: item.description,
                              buttonText: 'Detail', // Example button
                              buttonColor: theme.colorScheme.outline,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomBar(
          isNeeded: false, // Set this based on your logic
          totalAmount: 1,
          onContinuePressed: () {
            print('Unduh Faktur ditekan.');
          }),
    );
  }

  // This helper method remains the same
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

  // This helper method remains the same
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/data/api/detailpayment.dart';
import 'package:guardian_app/data/models/detailpayment.dart';
import 'package:guardian_app/presentation/keuangan/widgets/transaction_history_card.dart';
import 'package:guardian_app/presentation/keuangan/widgets/bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetailPage extends StatefulWidget {
  const PaymentDetailPage({Key? key}) : super(key: key);

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  late Future<PaymentDetail> _paymentDetailFuture;

  @override
  void initState() {
    super.initState();
    _paymentDetailFuture = _fetchPaymentDetails();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka tautan: $urlString')),
        );
      }
    }
  }

  Future<PaymentDetail> _fetchPaymentDetails() async {
    const String studentId = "TLAB.0001";
    const String tuitionPlanId = "PLAN-TLAB-250822-000731";

    final responseData = await getViewJadwalBayar(
      studentId: studentId,
      tuitionPlanId: tuitionPlanId,
    );

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    debugPrint('Raw Detail API Response:\n${encoder.convert(responseData)}');

    if (responseData != null && responseData.containsKey('message')) {
      return PaymentDetail.fromJson(responseData['message']);
    } else {
      String serverError =
          'Gagal memuat detail. Format data dari server tidak sesuai.';

      if (responseData != null) {
        if (responseData.containsKey('_server_messages')) {
          try {
            final serverMessages = responseData['_server_messages'] as List;
            if (serverMessages.isNotEmpty) {
              final messageJson = jsonDecode(serverMessages.first);
              serverError = messageJson['message'] ?? serverError;
            }
          } catch (e) {
            serverError = responseData['_server_messages'].toString();
          }
        } else if (responseData.containsKey('exception')) {
          serverError = responseData['exception'].toString();
        }
      } else {
        serverError =
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      }
      throw Exception(serverError);
    }
  }

  Future<void> onRefresh() async {
    setState(() {
      _paymentDetailFuture = _fetchPaymentDetails();
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
      body: FutureBuilder<PaymentDetail>(
        future: _paymentDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${snapshot.error}'.replaceFirst('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onRefresh,
                      child: const Text('Coba Lagi',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            final paymentDetail = snapshot.data!;
            final currencyFormatter = NumberFormat.decimalPattern('id_ID');
            final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');

            return RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                            paymentDetail.description,
                            hasIcon: true,
                          ),
                          const Divider(height: 10),
                          _buildDetailItem(context, 'Nominal',
                              'Rp ${currencyFormatter.format(paymentDetail.amount)}'),
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
                    if (paymentDetail.history.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Belum ada riwayat pembayaran.'),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paymentDetail.history.length,
                        itemBuilder: (context, index) {
                          final item = paymentDetail.history[index];
                          return TransactionHistoryCard(
                            date: item.date,
                            amount:
                                'Rp ${currencyFormatter.format(item.amount)}',
                            description: item.description,
                            buttonText: 'Unduh Bukti',
                            buttonColor: theme.colorScheme.primary,
                            onPressed: () {
                              final url =
                                  '${paymentDetail.incomingReceiptUrl}${item.name}';
                              _launchURL(url);
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                      ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Tidak ada data ditemukan.'));
        },
      ),
      bottomNavigationBar: FutureBuilder<PaymentDetail>(
        future: _paymentDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.outgoingInvoiceId.isNotEmpty) {
            final paymentDetail = snapshot.data!;
            return BottomBar(
              isNeeded: false,
              totalAmount: 1,
              onContinuePressed: () {
                final url =
                    '${paymentDetail.outgoingInvoiceUrl}${paymentDetail.outgoingInvoiceId}';
                _launchURL(url);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

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
}

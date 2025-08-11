import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/keuangan/paymentschedule_card.dart';
import 'package:guardian_app/presentation/keuangan/summarycard.dart';
import 'package:guardian_app/presentation/keuangan/totalpayment.dart';
import 'package:guardian_app/routes/app_routes.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:guardian_app/widgets/bottom_nav_bar.dart';
import 'package:guardian_app/widgets/custom_fab.dart';
import 'package:guardian_app/widgets/ad_card.dart';

class KeuanganScreen extends StatefulWidget {
  const KeuanganScreen({Key? key}) : super(key: key);

  @override
  KeuanganPageScreen createState() => KeuanganPageScreen();
}

class KeuanganPageScreen extends State<KeuanganScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFinanceHeader(),
            const Expanded(
              child: FinanceScreenContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        context: context,
        theme: theme,
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.bayarSatuScreen);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF4B2C5C),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Candra Wijaya',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'SDN 13 Malang | Kelas 5',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Stack(
            children: const [
              Icon(Icons.notifications, color: Colors.white, size: 28),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceHeader() {
    return Container(
      color: const Color(0xFF6A4C93),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Keuangan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.filter_list, color: Colors.white, size: 24),
        ],
      ),
    );
  }
}

class FinanceScreenContent extends StatelessWidget {
  const FinanceScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentSummary(),
            // Mengganti _buildAdSection() dengan AdCard
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const AdCard(
                teks: 'In the lessns we leran new words and r for vacalaburities continues and article',
              ),
            ),
            const SizedBox(height: 20),
            _buildPaymentSchedule(context), // Tambahkan parameter context
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: SummaryCard(
                label: 'Total Kewajiban',
                value: 'Rp 1.800.000',
                valueColor: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                label: 'Total Tunggakan',
                value: 'Rp 300.000',
                valueColor: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const TotalPaymentCard(),
      ],
    );
  }
  
  Widget _buildPaymentSchedule(BuildContext context) { // Tambahkan parameter context
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jadwal Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        // Wrap PaymentScheduleCard dengan GestureDetector untuk menambahkan onTap
        GestureDetector(
          onTap: () => _navigateToPaymentDetail(context),
          child: const PaymentScheduleCard(
            dueDate: '10 Agustus 2025',
            amount: 'Rp 300.000',
            description: 'Uang Sekolah Candra Bulan Agustus Tahun Ajaran 2025 / 2026',
            status: 'Belum Lunas',
            statusColor: Colors.grey,
            isOverdue: false,
          ),
        ),
        GestureDetector(
          onTap: () => _navigateToPaymentDetail(context),
          child: const PaymentScheduleCard(
            dueDate: '30 Juli 2025',
            amount: 'Rp 1.200.000',
            description: 'Uang Seragam Candra Tahun Ajaran 2025 / 2026',
            status: 'Lunas',
            statusColor: Colors.green,
            isOverdue: false,
          ),
        ),
        GestureDetector(
          onTap: () => _navigateToPaymentDetail(context),
          child: const PaymentScheduleCard(
            amount: 'Rp 300.000',
            description: 'Uang Sekolah Candra Bulan Juli Tahun Ajaran 2025 / 2026',
            status: 'Belum Lunas',
            statusColor: Colors.grey,
            isOverdue: true,
          ),
        ),
      ],
    );
  }

  // Method untuk navigasi ke halaman detail pembayaran
  void _navigateToPaymentDetail(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.paymentDetailPage);
  }
}
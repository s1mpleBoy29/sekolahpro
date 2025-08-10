import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keuangan Sekolah',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MainScreen(),
    );
  }
}

// Ubah FinanceScreen menjadi MainScreen yang bersifat StatefulWidget
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index 3 adalah Keuangan
  int _selectedIndex = 3; 

  // Daftar halaman yang akan ditampilkan berdasarkan index
  static const List<Widget> _widgetOptions = <Widget>[
    // Beranda
    Placeholder(color: Colors.red, child: Center(child: Text('Beranda'))),
    // Agenda
    Placeholder(color: Colors.green, child: Center(child: Text('Agenda'))),
    // Tombol Tengah
    Placeholder(color: Colors.blue, child: Center(child: Text('Pembayaran'))),
    // Keuangan
    FinanceScreenContent(),
    // Akun
    Placeholder(color: Colors.yellow, child: Center(child: Text('Akun'))),
  ];

  // Fungsi untuk memperbarui index saat tombol ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Column(
          children: [
            // Tampilkan header hanya di halaman Keuangan
            if (_selectedIndex == 3) ...[
              _buildHeader(),
              _buildFinanceHeader(),
            ],
            // Tampilkan body sesuai index
            Expanded(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
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
  
  // Perbarui _buildBottomNavBar untuk menggunakan onTap
  Widget _buildBottomNavBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.home,
            label: 'Beranda',
            isSelected: _selectedIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          _NavBarItem(
            icon: Icons.event,
            label: 'Agenda',
            isSelected: _selectedIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          _NavBarItem(
            icon: Icons.credit_card,
            label: '',
            isSelected: _selectedIndex == 2,
            onTap: () => _onItemTapped(2),
            isMiddleButton: true,
          ),
          _NavBarItem(
            icon: Icons.account_balance_wallet,
            label: 'Keuangan',
            isSelected: _selectedIndex == 3,
            onTap: () => _onItemTapped(3),
          ),
          _NavBarItem(
            icon: Icons.person,
            label: 'Akun',
            isSelected: _selectedIndex == 4,
            onTap: () => _onItemTapped(4),
          ),
        ],
      ),
    );
  }
}

// Widget untuk isi konten halaman Keuangan
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
            _buildAdSection(),
            const SizedBox(height: 20),
            _buildPaymentSchedule(),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: _SummaryCard(
                label: 'Total Kewajiban',
                value: 'Rp 1.800.000',
                valueColor: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                label: 'Total Tunggakan',
                value: 'Rp 300.000',
                valueColor: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _TotalPaymentCard(),
      ],
    );
  }

  Widget _buildAdSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            //const Icon(FontAwesomeIcons.handPointer, color: Color(0xFF6A4C93), size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Ads', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 5),
                  Text(
                    'In the lessns we leran new words and r for vacalaburities continues and article',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jadwal Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _ScheduleCard(
          dueDate: '10 Agustus 2025',
          amount: 'Rp 300.000',
          description: 'Uang Sekolah Candra Bulan Agustus Tahun Ajaran 2025 / 2026',
          status: 'Belum Lunas',
          statusColor: Colors.grey,
        ),
        _ScheduleCard(
          dueDate: '30 Juli 2025',
          amount: 'Rp 1.200.000',
          description: 'Uang Seragam Candra Tahun Ajaran 2025 / 2026',
          status: 'Lunas',
          statusColor: Colors.green,
        ),
        const SizedBox(height: 10),
        _OverdueCard(),
      ],
    );
  }
}

// Custom widget for summary cards
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.valueColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for total payment card
class _TotalPaymentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A4C93),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Riwayat Pembayaran'),
          ),
        ],
      ),
    );
  }
}

// Custom widget for a schedule card
class _ScheduleCard extends StatelessWidget {
  final String dueDate;
  final String amount;
  final String description;
  final String status;
  final Color statusColor;

  const _ScheduleCard({
    required this.dueDate,
    required this.amount,
    required this.description,
    required this.status,
    required this.statusColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bayar sebelum $dueDate',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: statusColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(status),
          ),
        ],
      ),
    );
  }
}

// Custom widget for overdue card
class _OverdueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE9E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Melewati batas waktu pembayaran',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Rp 300.000',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Belum Lunas'),
          ),
        ],
      ),
    );
  }
}

// Custom widget for bottom navigation bar items
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMiddleButton;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isMiddleButton = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: isMiddleButton
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6A4C93) : Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? const Color(0xFF6A4C93) : Colors.grey,
                  ),
                  if (label.isNotEmpty)
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? const Color(0xFF6A4C93) : Colors.grey,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model untuk menampung data agenda yang diterima dari API
class Agenda {
  final String date;
  final String from;
  final String to;
  final String detail;

  Agenda({
    required this.date,
    required this.from,
    required this.to,
    required this.detail,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    // Pastikan Anda memetakan kunci JSON yang benar dari respons API
    return Agenda(
      date: json['tanggal'] as String,
      from: json['dari'] as String,
      to: json['untuk'] as String,
      detail: json['detail'] as String,
    );
  }
}

// Ubah menjadi StatefulWidget untuk mengelola status (loading, data, error)
class DetailAgenda extends StatefulWidget {
  final String agendaId;
  final String studentId;

  const DetailAgenda({
    super.key,
    required this.agendaId,
    required this.studentId,
  });

  @override
  State<DetailAgenda> createState() => _DetailAgendaState();
}

class _DetailAgendaState extends State<DetailAgenda> {
  // Variabel untuk menyimpan status data
  late Future<Agenda> futureAgenda;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data saat widget dibuat
    futureAgenda = fetchAgendaDetail();
  }

  // Fungsi untuk memanggil API
  Future<Agenda> fetchAgendaDetail() async {
    // Ganti dengan base URL dan token otorisasi Anda yang sebenarnya
    const String baseUrl = 'https://your-base-url.com';
    const String authToken = 'your-auth-token';

    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/method/gaAgendaView?agenda=${widget.agendaId}&student=${widget.studentId}'),
      headers: {
        'sekolahproapp': 'PA-1.0.0',
        'Authorization': 'token $authToken',
      },
    );

    if (response.statusCode == 200) {
      // Jika server mengembalikan respons 200 OK, parse JSON.
      return Agenda.fromJson(jsonDecode(response.body));
    } else {
      // Jika respons tidak 200 OK, lemparkan error.
      throw Exception('Gagal memuat data agenda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Agenda",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        elevation: 1,
      ),
      body: FutureBuilder<Agenda>(
        future: futureAgenda,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan indikator loading saat menunggu data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Tampilkan pesan error jika terjadi kesalahan
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Tampilkan data jika berhasil dimuat
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!.date,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: 'Dari: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: snapshot.data!.from,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: 'Untuk: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: snapshot.data!.to,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    snapshot.data!.detail,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            );
          } else {
            // Tampilkan pesan default jika tidak ada data
            return const Center(child: Text("Tidak ada data agenda"));
          }
        },
      ),
    );
  }
}

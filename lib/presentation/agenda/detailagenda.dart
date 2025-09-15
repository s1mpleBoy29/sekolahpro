import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/data/models/Agenda.dart';
import 'package:guardian_app/data/api/detailagenda.dart';
// Import package flutter_html
import 'package:flutter_html/flutter_html.dart';

class DetailAgenda extends StatefulWidget {
  final String? studentId;
  final String? agendaId;

  const DetailAgenda({
    super.key,
    this.studentId,
    this.agendaId,
  });

  @override
  State<DetailAgenda> createState() => _DetailAgendaState();
}

class _DetailAgendaState extends State<DetailAgenda> {
  late Future<AgendaDetail?> _agendaDetailFuture;
  String? errorMessage;
  late String currentStudentId;
  late String currentAgendaId;

  @override
  void initState() {
    super.initState();
    _initializeParameters();
    // _agendaDetailFuture diinisialisasi di _initializeParameters jika ada argumen
  }

  void _initializeParameters() {
    // Cek apakah ada arguments dari Navigator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        setState(() {
          currentStudentId = args['studentId'] ?? widget.studentId ?? 'TLAB.0001';
          currentAgendaId = args['agendaId'] ?? widget.agendaId ?? 'AG-TLAB-2508-0892';
          _agendaDetailFuture = _fetchAgendaDetail(currentStudentId, currentAgendaId);
        });
      } else {
        // Gunakan parameter widget atau default values
        currentStudentId = widget.studentId ?? 'TLAB.0001';
        currentAgendaId = widget.agendaId ?? 'AG-TLAB-2508-0892';
        // Fetch data if no arguments were passed and default values are used
        _agendaDetailFuture = _fetchAgendaDetail(currentStudentId, currentAgendaId);
      }
    });

    // Set initial values for the first build if no arguments are immediately available
    currentStudentId = widget.studentId ?? 'TLAB.0001';
    currentAgendaId = widget.agendaId ?? 'AG-TLAB-2508-0892';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ambil arguments dari route jika ada
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      final newStudentId = args['studentId'] ?? widget.studentId ?? 'TLAB.0001';
      final newAgendaId = args['agendaId'] ?? widget.agendaId ?? 'AG-TLAB-2508-0892';

      // Update hanya jika berbeda dari yang sekarang
      if (newStudentId != currentStudentId || newAgendaId != currentAgendaId) {
        currentStudentId = newStudentId;
        currentAgendaId = newAgendaId;
        _agendaDetailFuture = _fetchAgendaDetail(currentStudentId, currentAgendaId);
      }
    }
  }

  Future<AgendaDetail?> _fetchAgendaDetail(String studentId, String agendaId) async {
    try {
      setState(() {
        errorMessage = null;
      });

      // Use the validation function for better error handling
      AgendaDetail? result = await getAgendaDetailWithValidation(
        studentId: studentId,
        agendaId: agendaId,
      );

      return result;
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading agenda: $e';
      });
      return null;
    }
  }

  void _retryLoad() {
    setState(() {
      errorMessage = null;
      _agendaDetailFuture = _fetchAgendaDetail(currentStudentId, currentAgendaId);
    });
  }

  void _showParameterDialog() {
    final studentController = TextEditingController(text: currentStudentId);
    final agendaController = TextEditingController(text: currentAgendaId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Parameters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: studentController,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                hintText: 'TLAB.0001',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: agendaController,
              decoration: const InputDecoration(
                labelText: 'Agenda ID',
                hintText: 'AG-TLAB-2508-0892',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentStudentId = studentController.text.trim();
                currentAgendaId = agendaController.text.trim();
                _agendaDetailFuture = _fetchAgendaDetail(currentStudentId, currentAgendaId);
              });
              Navigator.pop(context);
            },
            child: const Text('Load'),
          ),
        ],
      ),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showParameterDialog,
            tooltip: 'Edit Parameters',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retryLoad,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<AgendaDetail?>(
        future: _agendaDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading agenda detail..."),
                ],
              ),
            );
          } else if (snapshot.hasError || errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage ?? "Gagal memuat detail agenda",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "StudentId: $currentStudentId\nAgendaId: $currentAgendaId",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Error: ${snapshot.error ?? 'Unknown error'}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showParameterDialog,
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text("Edit Parameters"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _retryLoad,
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text("Coba Lagi"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final AgendaDetail agendaDetail = snapshot.data!;

            try {
              final String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(agendaDetail.date);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header with larger font
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // From field
                    if (agendaDetail.from.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dari: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              agendaDetail.from,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],

                    // To field
                    if (agendaDetail.to.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Untuk: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              agendaDetail.to,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Detail content with flutter_html
                    if (agendaDetail.detail.isNotEmpty)
                      Html(
                        data: agendaDetail.detail,
                        // Jika Anda ingin kustomisasi lebih lanjut pada styling HTML,
                        // Anda bisa menggunakan properti 'style' pada widget Html.
                        // Contoh:
                        // style: {
                        //   "p": Style(
                        //     fontSize: FontSize.medium,
                        //     color: Colors.black,
                        //     lineHeight: const LineHeight(1.6),
                        //   ),
                        //   "strong": Style(
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        //   "span": Style(
                        //     color: Colors.black,
                        //   ),
                        // },
                        // Untuk mengatasi error 'HtmlPadding Function()', pastikan Anda
                        // tidak secara manual memanggil atau mendefinisikan padding dengan cara yang salah.
                        // Jika Anda tidak perlu padding khusus, Anda bisa menghapus konfigurasi padding
                        // yang mungkin ada di kode Anda yang tidak terlihat di sini.
                        // Jika Anda memang perlu padding, pastikan formatnya benar, contoh:
                        // padding: HtmlPadding.symmetric(horizontal: 8.0),
                        // Atau gunakan nilai default jika tidak ada kebutuhan khusus.
                        // Jika error masih berlanjut, cek kembali import dan penggunaan
                        // library flutter_html di project Anda.
                      ),
                  ],
                ),
              );
            } catch (dateError) {
              // Handle date formatting error
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      "Error formatting date: $dateError",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retryLoad,
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inbox,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text("Detail agenda tidak ditemukan"),
                  const SizedBox(height: 8),
                  Text(
                    "StudentId: $currentStudentId\nAgendaId: $currentAgendaId",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showParameterDialog,
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text("Edit Parameters"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _retryLoad,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
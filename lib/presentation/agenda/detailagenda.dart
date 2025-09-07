import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/data/models/Agenda.dart';
import 'package:guardian_app/data/api/detailagenda.dart';

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
    // Use passed parameters or fallback to default values
    currentStudentId = widget.studentId ?? 'TLAB.0001';
    currentAgendaId = widget.agendaId ?? 'AG-TLAB-2508-0892';
    
    _agendaDetailFuture = _fetchAgendaDetail(currentStudentId, currentAgendaId);
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 24),
                    
                    // From field
                    if (agendaDetail.from.isNotEmpty) ...[
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
                              text: agendaDetail.from,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // To field
                    if (agendaDetail.to.isNotEmpty) ...[
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
                              text: agendaDetail.to,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Detail content
                    if (agendaDetail.detail.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          agendaDetail.detail,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black,
                                height: 1.5,
                              ),
                        ),
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
                    "Periksa Student ID dan Agenda ID",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
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
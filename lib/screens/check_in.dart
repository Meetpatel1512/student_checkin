import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _idController = TextEditingController();
  List<Map<String, dynamic>> _checkIns = [];
  bool _isLoading = false;

  int _todaysCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCheckIns();
  }

  void _fetchCheckIns() async {
    final data = await ApiService.getCheckIns();

    _calculateDailyStats(data);

    setState(() {
      _checkIns = data;
    });
  }

  void _calculateDailyStats(List<Map<String, dynamic>> data) {
    int count = 0;
    final now = DateTime.now();

    for (var item in data) {
      if (item['checkInTime'] != null) {
        final checkInDate = DateTime.parse(item['checkInTime']).toLocal();

        if (checkInDate.year == now.year &&
            checkInDate.month == now.month &&
            checkInDate.day == now.day) {
          count++;
        }
      }
    }

    setState(() {
      _todaysCount = count;
    });
  }

  void _handleCheckIn() async {
    if (_idController.text.isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final message = await ApiService.checkInStudent(_idController.text.trim());

    setState(() => _isLoading = false);

    if (mounted) {
      if (message == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Checked In Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        _idController.clear();
        _fetchCheckIns();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Check-In"),
        actions: [
          IconButton(
            onPressed: _fetchCheckIns,
            icon: const Icon(Iconsax.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Check-ins",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        "Today",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "$_todaysCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            TextField(
              controller: _idController,

              keyboardType: TextInputType.text,

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                labelText: "Enter ID",
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _isLoading ? null : _handleCheckIn,
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "MARK CHECK-IN",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "History",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: _checkIns.isEmpty
                  ? const Center(child: Text("No check-ins yet."))
                  : ListView.builder(
                      itemCount: _checkIns.length,
                      itemBuilder: (context, index) {
                        final checkIn = _checkIns[index];
                        String timeString = "--:--";
                        bool isToday = false;

                        if (checkIn['checkInTime'] != null) {
                          final date = DateTime.parse(
                            checkIn['checkInTime'],
                          ).toLocal();
                          timeString = DateFormat('hh:mm a').format(date);

                          final now = DateTime.now();
                          isToday =
                              date.year == now.year &&
                              date.month == now.month &&
                              date.day == now.day;
                        }

                        return Card(
                          elevation: 0,
                          color: isToday
                              ? Colors.indigo.withOpacity(0.05)
                              : Colors.white,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isToday
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.grey.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.clock,
                                color: isToday ? Colors.green : Colors.grey,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              checkIn['studentName'] ?? "Unknown",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("ID: ${checkIn['studentId']}"),
                            trailing: Text(
                              timeString,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

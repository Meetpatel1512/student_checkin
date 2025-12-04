import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';
import 'student_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() => isLoading = true);

    final students = await ApiService.fetchStudentsData();

    setState(() {
      _allStudents = students;
      _filteredStudents = students;
      isLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Student> results = [];

    if (enteredKeyword.isEmpty) {
      results = _allStudents;
    } else {
      results = _allStudents
          .where(
            (student) =>
                student.name.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ) ||
                student.studentId.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }

    setState(() {
      _filteredStudents = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Students"), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Search by Name or ID',
                prefixIcon: const Icon(Iconsax.search_normal),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchStudents,
                    child: _filteredStudents.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredStudents.length,
                            itemBuilder: (context, index) {
                              // IMPORTANT: Use _filteredStudents here
                              final student = _filteredStudents[index];
                              return _buildStudentCard(student);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  // Widget _buildStudentCard(Student student) {
  //   return Card(
  //     elevation: 0,
  //     color: Colors.white,
  //     shape: RoundedRectangleBorder(
  //       side: BorderSide(color: Colors.grey.shade200),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     margin: const EdgeInsets.only(bottom: 12.0),
  //     child: ListTile(
  //       leading: CircleAvatar(
  //         backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
  //         child: const Icon(Iconsax.user, color: Color(0xFF4F46E5)),
  //       ),
  //       title: Text(
  //         student.name,
  //         style: const TextStyle(fontWeight: FontWeight.w600),
  //       ),
  //       subtitle: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const SizedBox(height: 4),
  //           Text(
  //             "ID: ${student.studentId}",
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           Text(
  //             student.email,
  //             style: TextStyle(color: Colors.grey[600], fontSize: 12),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildStudentCard(Student student) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12.0),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailScreen(student: student),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.1),
              child: const Icon(Iconsax.user, color: Color(0xFF4F46E5)),
            ),
            title: Text(
              student.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  "ID: ${student.studentId}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  student.email,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),

            trailing: const Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.search_status,
            size: 80,
            color: Colors.grey[300],
          ), // Changed icon
          const SizedBox(height: 16),
          const Text(
            "No Student Found",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),

          if (_allStudents.isEmpty)
            TextButton(onPressed: _fetchStudents, child: const Text("Reload")),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final studentIdController = TextEditingController();

  bool isLoading = false;

  void addStudentData() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        studentIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final newstudent = Student(
      name: nameController.text,
      email: emailController.text,
      studentId: studentIdController.text,
    );

    final success = await ApiService.addStudent(newstudent);

    setState(() => isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        nameController.clear();
        emailController.clear();
        studentIdController.clear();
      }
    } else {
      if (mounted) {
        const SnackBar(
          content: Text("Failed to add student"),
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "New Student Details ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name ',
                prefixIcon: Icon(Iconsax.user),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address ',
                prefixIcon: Icon(Iconsax.sms),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: studentIdController,
              decoration: const InputDecoration(
                labelText: 'Student ID (Unique) ',
                prefixIcon: Icon(Iconsax.card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: FilledButton.icon(
                onPressed: isLoading ? null : addStudentData,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Iconsax.add),
                label: Text(
                  isLoading ? "Saving..." : "Add Student",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

  bool isLoading = false;
  bool _isFetchingPincode = false;

  @override
  void initState() {
    super.initState();

    _pincodeController.addListener(_onPincodeChanged);
  }

  @override
  void dispose() {
    _pincodeController.removeListener(_onPincodeChanged);
    super.dispose();
  }

  void _onPincodeChanged() async {
    final pincode = _pincodeController.text;
    if (pincode.length == 6) {
      setState(() => _isFetchingPincode = true);

      final data = await ApiService.getPincodeDetails(pincode);

      setState(() => _isFetchingPincode = false);

      if (data != null) {
        _districtController.text = data['District']!;
        _stateController.text = data['State']!;
        _countryController.text = data['Country']!;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid Pincode"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _addStudentData() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _studentIdController.text.isEmpty) {
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
      name: _nameController.text,
      email: _emailController.text,
      studentId: _studentIdController.text,
      pincode: _pincodeController.text,
      district: _districtController.text,
      state: _stateController.text,
      country: _countryController.text,
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
        _nameController.clear();
        _emailController.clear();
        _studentIdController.clear();
        _pincodeController.clear();
        _districtController.clear();
        _stateController.clear();
        _countryController.clear();
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
              controller: _nameController,
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
              controller: _emailController,
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
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Student ID (Unique) ',
                prefixIcon: Icon(Iconsax.card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Address Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _pincodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                labelText: "Pincode",
                prefixIcon: const Icon(Iconsax.location),
                suffixIcon: _isFetchingPincode
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                counterText: "",
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _districtController,
                    decoration: const InputDecoration(
                      labelText: "District",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: "State",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: "Country",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: FilledButton.icon(
                onPressed: isLoading ? null : _addStudentData,
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

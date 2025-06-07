import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  DateTime? selectedDate;
  String? gender;
  String? status;
  String? province;
  String? city;
  String? barangay;
  int age = 0;

  void _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int calculatedAge = today.year - dob.year;
    if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
      calculatedAge--;
    }
    setState(() {
      age = calculatedAge;
    });
  }

  Future<void> _registerUser() async {
    final uri = Uri.parse("http://localhost/capstonenew/my_flutter_api/register.php");

    Map<String, dynamic> userData = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'username': usernameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'dob': selectedDate!.toIso8601String(),
      'age': age,
      'gender': gender,
      'status': status,
      'province': province,
      'city': city,
      'barangay': barangay,
      'password': passwordController.text,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful!')),
      );
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              ListTile(
                title: Text(selectedDate == null
                    ? 'Select Date of Birth'
                    : 'DOB: ${selectedDate!.toLocal()} (Age: $age)'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2005),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _calculateAge(pickedDate);
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other'].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (val) => setState(() => gender = val),
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['Single', 'Married'].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (val) => setState(() => status = val),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Province'),
                onChanged: (val) => province = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                onChanged: (val) => city = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Barangay'),
                onChanged: (val) => barangay = val,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) =>
                    value != passwordController.text ? 'Passwords do not match' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () {
                  if (_formKey.currentState!.validate() && selectedDate != null) {
                    _registerUser();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all required fields')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

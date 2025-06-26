import 'package:flutter/material.dart';
import "../../services/ApiClient.dart";

class NewPatientScreen extends StatefulWidget {
  const NewPatientScreen({super.key});

  @override
  State<NewPatientScreen> createState() => __NewPatientScreen();
}

class __NewPatientScreen extends State<NewPatientScreen> {
  final key = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final city = TextEditingController();
  DateTime? dateOfBirth;
  String gender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new patient")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(23.00),
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firstName,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter first name' : null,
                ),
                TextFormField(
                  controller: lastName,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter last name' : null,
                ),
                TextFormField(
                  controller: address,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter address' : null,
                ),
                TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter phone number' : null,
                ),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Enter valid email'
                      : null,
                ),
                TextFormField(
                  controller: city,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter city' : null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dateOfBirth == null
                            ? 'Select Date of Birth'
                            : 'DOB: ${dateOfBirth!.toLocal().toString().split(' ')[0]}',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          dateOfBirth = pickedDate;
                          // Trigger rebuild
                          (context as Element).markNeedsBuild();
                        }
                      },
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (v) => gender = v ?? 'Male',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (key.currentState!.validate() && dateOfBirth != null) {
                          final response = await ApiClient().post(
                            '/patient',
                            data: {
                              "firstName": firstName.text,
                              "lastName": lastName.text,
                              "address": address.text,
                              "dateOfBirth": dateOfBirth!.toIso8601String().split(
                                'T',
                              )[0],
                              "gender": gender.toLowerCase(),
                              "email": email.text,
                              "phone": phone.text,
                              "city": city.text,
                            },
                          );
                          
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

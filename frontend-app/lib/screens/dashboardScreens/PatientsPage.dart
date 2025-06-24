import 'package:flutter/material.dart';
import "../../services/ApiClient.dart";
import "../../models/Patient.dart";

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Patient> _patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiClient().get("/patient");
      final patients = (response.data['data'] as List)
          .map((json) => Patient.fromJson(json))
          .toList();

      setState(() {
        _patients = patients;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching patients: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patients')),
      body: isLoading ? const Center(child: CircularProgressIndicator()) :_patients.isEmpty
          ? const Center(child: Text('No patients yet'))
          : ListView.separated(
        itemCount: _patients.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, i) {
          final p = _patients[i];
          return ListTile(
            leading: CircleAvatar(
              child: Text(p.name.substring(0, 1).toUpperCase()),
            ),
            title: Text(p.name),
            subtitle: Text('Age ${p.age} • ${p.gender}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientSessionsPage(patient: p),
              ),
            ),
          );
        },
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientDialog(context),
        tooltip: 'Add patient',
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext ctx) {
    final key = GlobalKey<FormState>();
    final firstName = TextEditingController();
    final lastName = TextEditingController();
    final address = TextEditingController();
    final phone = TextEditingController();
    final email = TextEditingController();
    final city = TextEditingController();
    DateTime? dateOfBirth;
    String gender = 'Male';

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('New Patient'),
        content: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firstName,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter first name' : null,
                ),
                TextFormField(
                  controller: lastName,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter last name' : null,
                ),
                TextFormField(
                  controller: address,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter address' : null,
                ),
                TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter phone number' : null,
                ),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                ),
                TextFormField(
                  controller: city,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter city' : null,
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
                          context: ctx,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          dateOfBirth = pickedDate;
                          // Trigger rebuild
                          (ctx as Element).markNeedsBuild();
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
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (key.currentState!.validate() && dateOfBirth != null) {
                final response = await ApiClient().post('/patient', data: {
                  "firstName": firstName.text,
                  "lastName": lastName.text,
                  "address": address.text,
                  "dateOfBirth": dateOfBirth!.toIso8601String().split('T')[0],
                  "gender": gender.toLowerCase(),
                  "email": email.text,
                  "phone": phone.text,
                  "city": city.text,
                });
                fetchPatients();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

  class PatientSessionsPage extends StatefulWidget {
  const PatientSessionsPage({super.key, required this.patient});

  final Patient patient;

  @override
  State<PatientSessionsPage> createState() => _PatientSessionsPageState();
}

class _PatientSessionsPageState extends State<PatientSessionsPage> {
  @override
  Widget build(BuildContext context) {
    final sessions = widget.patient.sessions;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name),
        // title: Text('${widget.patient.gender}, ${widget.patient.age}'),
      ),
      body: sessions.isEmpty
          ? const Center(child: Text('No sessions yet'))
          : ListView.separated(
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, i) {
                final s = sessions[i];
                return ListTile(
                  leading: const Icon(Icons.medical_services),
                  title: Text(s.purpose),
                  subtitle: Text(
                    dateFormat(s.date) +
                        (s.notes.isEmpty ? '' : '\nNotes: ${s.notes}'),
                  ),
                  isThreeLine: s.notes.isNotEmpty,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSessionDialog(context),
        tooltip: 'Add session',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSessionDialog(BuildContext ctx) {
    final key = GlobalKey<FormState>();
    final purpose = TextEditingController();
    final notes = TextEditingController();
    DateTime date = DateTime.now();

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('New Session'),
        content: Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: purpose,
                  decoration: const InputDecoration(labelText: 'Purpose'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter purpose' : null,
                ),
                TextFormField(
                  controller: notes,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(dateFormat(date)),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: date,
                        );
                        if (picked != null) {
                          setState(() => date = picked); // redraw dialog
                        }
                      },
                      child: const Text('Pick date'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              if (key.currentState!.validate()) {
                setState(() {
                  widget.patient.sessions.add(
                    Session(
                      date: date,
                      purpose: purpose.text,
                      notes: notes.text,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Data‑class and nice date formatting helper

String dateFormat(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

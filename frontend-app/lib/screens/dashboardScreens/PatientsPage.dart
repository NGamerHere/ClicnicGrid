import 'package:flutter/material.dart';

/// ──────────────────────────────────────────────────────────────
/// 1) MAIN LIST OF PATIENTS
/// ──────────────────────────────────────────────────────────────
class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final List<Patient> _patients = []; // In‑memory demo store

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
      ),
      body: _patients.isEmpty
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientDialog(context),
        tooltip: 'Add patient',
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext ctx) {
    final key = GlobalKey<FormState>();
    final name = TextEditingController();
    final age = TextEditingController();
    String gender = 'Male';

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('New Patient'),
        content: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: age,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                (v == null || int.tryParse(v) == null) ? 'Enter age' : null,
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
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              if (key.currentState!.validate()) {
                setState(() => _patients.add(
                  Patient(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: name.text,
                    age: int.parse(age.text),
                    gender: gender,
                  ),
                ));
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Simple data‑class for demo purposes
class Patient {
  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });

  final int id;
  final String name;
  final int age;
  final String gender;
  final List<Session> sessions = [];
}

/// ──────────────────────────────────────────────────────────────
/// 2) SESSION LIST FOR ONE PATIENT
/// ──────────────────────────────────────────────────────────────
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
            subtitle: Text(dateFormat(s.date) +
                (s.notes.isEmpty ? '' : '\nNotes: ${s.notes}')),
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
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              if (key.currentState!.validate()) {
                setState(() {
                  widget.patient.sessions.add(
                    Session(date: date, purpose: purpose.text, notes: notes.text),
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
class Session {
  Session({required this.date, required this.purpose, required this.notes});
  final DateTime date;
  final String purpose;
  final String notes;
}

String dateFormat(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

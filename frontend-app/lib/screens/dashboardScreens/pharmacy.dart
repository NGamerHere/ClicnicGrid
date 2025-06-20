import 'package:flutter/material.dart';

class pharamacyPage extends StatefulWidget {
  const pharamacyPage({super.key});

  @override
  State<pharamacyPage> createState() => __pharamacyPage();
}

class __pharamacyPage extends State<pharamacyPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pharmacy Management")),
      body: Column(
        children: [
          const Text("welcome to Pharmacy"),

          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add new Medicines"),
                    content: Text("This is a simple popup dialog."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // closes the popup
                        },
                        child: Text("OK"),
                      ),TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // closes the popup
                        },
                        child: Text("cancel"),
                      )
                    ],
                  );
                },
              );
            },
            child: Text("Show Popup"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Fill the Form'),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: double.maxFinite, // let it expand
              child: Column(
                mainAxisSize: MainAxisSize.min, // fit content only
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                    value != null && value.contains('@')
                        ? null
                        : 'Enter valid email',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('Name: ${_nameController.text}');
                  print('Email: ${_emailController.text}');
                  Navigator.pop(context); // close dialog
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

}

import 'package:flutter/material.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController itemsPerStackController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();

  DateTime? expiresOn;
  String selectedType = 'tablet';

  final List<String> medicineTypes = ['tablet', 'capsule', 'syrup', 'tonic', 'powder', 'oil'];

  void _submitForm() {
    if (_formKey.currentState!.validate() && expiresOn != null) {
      final medicine = {
        "name": nameController.text,
        "description": descController.text,
        "price": double.parse(priceController.text),
        "quantity": int.parse(quantityController.text),
        "type": selectedType,
        "weight": double.parse(weightController.text),
        "volume": double.parse(volumeController.text),
        "expiresOn": expiresOn!.toIso8601String().split("T")[0],
        "addedOn": DateTime.now().toIso8601String().split("T")[0],
        "itemsPerStack": double.parse(itemsPerStackController.text),
      };

      // TODO: Send `medicine` to backend via APIClient
      debugPrint("Submitting: $medicine");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine submitted successfully!')),
      );
    }
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => expiresOn = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Medicine")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _textField("Medicine Name", nameController),
              _textField("Description", descController, maxLines: 3),
              _dropdownField(),
              _textField("Price", priceController, isNumber: true),
              _textField("Quantity", quantityController, isNumber: true),
              _textField("Items per Stack", itemsPerStackController, isNumber: true),
              _textField("Weight (g)", weightController, isNumber: true),
              _textField("Volume (ml)", volumeController, isNumber: true),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  expiresOn == null
                      ? "Pick Expiry Date"
                      : "Expires On: ${expiresOn!.toIso8601String().split("T")[0]}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickExpiryDate,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Submit"),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller,
      {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  Widget _dropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        decoration: InputDecoration(
          labelText: "Medicine Type",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: medicineTypes
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: (value) => setState(() => selectedType = value!),
      ),
    );
  }
}
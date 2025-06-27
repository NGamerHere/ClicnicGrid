import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/InventoryItem.dart';

class SingleInventoryScreen extends StatelessWidget {
  final InventoryItem item;

  const SingleInventoryScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(item.expiresOn);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Center(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 32),

                // Info chips
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip("₹${item.price}", Icons.currency_rupee),
                    _buildInfoChip("Quantity: ${item.quantity}", Icons.inventory),
                    _buildInfoChip("Items/Stack: ${item.itemsPerStack}", Icons.layers),
                    _buildInfoChip("Weight: ${item.weight}g", Icons.scale),
                    _buildInfoChip("Volume: ${item.volume}ml", Icons.local_drink),
                    _buildInfoChip("Type: ${item.type}", Icons.category),
                  ],
                ),
                const SizedBox(height: 24),

                // Expiration date
                Row(
                  children: [
                    const Icon(Icons.event, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Text(
                      "Expires on: $formattedDate",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 16,
                      ),
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

  Widget _buildInfoChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }
}
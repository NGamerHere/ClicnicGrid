import 'package:flutter/material.dart';
import "../../services/ApiClient.dart";
import './InventoryScreen.dart';
import "./SalesScreen.dart";
import "../dashboardScreens/AddMedicineScreen.dart";

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  int _totalItems = 0;
  int _lowStock = 0;
  int _expired = 0;
  int _outOfStock = 0;

  @override
  void initState() {
    super.initState();
    _fetchStockSummary();
  }

  Future<void> _fetchStockSummary() async {
    final response = await ApiClient().get("/medicine/dashboard");
    final data = response.data;

    setState(() {
      _totalItems = data['total'];
      _lowStock = data['lowStock'];
      _expired = data['expired'];
      _outOfStock = data['outOfStock'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmacy Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _StatusCard(
                  title: 'Total Items',
                  value: _totalItems,
                  color: Colors.blue,
                ),
                _StatusCard(
                  title: 'Low Stock',
                  value: _lowStock,
                  color: Colors.orange,
                ),
                _StatusCard(
                  title: 'Expired',
                  value: _expired,
                  color: Colors.redAccent,
                ),
                _StatusCard(
                  title: 'Out of Stock',
                  value: _outOfStock,
                  color: Colors.deepPurple,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ───── 2) TWO MAIN PAGES ─────
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isTablet ? 2 : 1,
              childAspectRatio: isTablet ? 3 / 2 : 5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _DashboardTile(
                  title: 'Inventory',
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                  onTap: goToInventory,
                ),
                _DashboardTile(
                  title: 'Sales',
                  icon: Icons.point_of_sale,
                  color: Colors.green,
                  onTap: goToSales,
                ),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMedicineScreen(),
          ),
        ),
        tooltip: 'Quick‑add supplier',
        child: const Icon(Icons.add),
      ),
    );
  }

  void goToInventory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InventoryScreen(),
      ),
    );
  }

  void goToSales() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalesScreen(),
      ),
    );
  }

  void _showAddSupplierDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final email = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Supplier'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v != null && v.contains('@'))
                    ? null
                    : 'Enter valid e‑mail',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                debugPrint('Supplier → ${name.text}  /  ${email.text}');
                Navigator.pop(ctx);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

/// Small rectangular info card used only for counters
class _StatusCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Large clickable tile for main navigation
class _DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

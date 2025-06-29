import 'package:flutter/material.dart';
import "../../services/ApiClient.dart";
import './InventoryScreen.dart';
import "./SalesScreen.dart";
import "../dashboardScreens/AddMedicineScreen.dart";
import "../../components/ScreenUtils.dart";

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = ScreenUtils.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmacy Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(isTablet),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddMedicineScreen()),
        ),
        tooltip: 'Add Medicine',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Sidebar - Navigation and Quick Actions
          Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quick Stats Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickStat('Total Items', _totalItems, Colors.blue),
                      _buildQuickStat('Low Stock', _lowStock, Colors.orange),
                      _buildQuickStat('Expired', _expired, Colors.red),
                      _buildQuickStat('Out of Stock', _outOfStock, Colors.purple),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Navigation Menu
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Navigation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNavigationButton(
                        'Inventory Management',
                        Icons.inventory_2_outlined,
                        Colors.blue,
                        goToInventory,
                      ),
                      const SizedBox(height: 12),
                      _buildNavigationButton(
                        'Sales Management',
                        Icons.point_of_sale_outlined,
                        Colors.green,
                        goToSales,
                      ),
                      const SizedBox(height: 12),
                      _buildNavigationButton(
                        'Add Medicine',
                        Icons.add_circle_outline,
                        Colors.purple,
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddMedicineScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Main Content Area
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatusCard(
                          title: 'Total Items',
                          value: _totalItems,
                          color: Colors.blue,
                          icon: Icons.inventory_2,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatusCard(
                          title: 'Low Stock',
                          value: _lowStock,
                          color: Colors.orange,
                          icon: Icons.warning_amber,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatusCard(
                          title: 'Expired',
                          value: _expired,
                          color: Colors.redAccent,
                          icon: Icons.schedule,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatusCard(
                          title: 'Out of Stock',
                          value: _outOfStock,
                          color: Colors.deepPurple,
                          icon: Icons.remove_circle_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Main Action Cards
                  const Text(
                    'Main Operations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _DesktopDashboardTile(
                          title: 'Inventory Management',
                          subtitle: 'Manage stock, add items, track inventory',
                          icon: Icons.inventory_2,
                          color: Colors.blue,
                          onTap: goToInventory,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _DesktopDashboardTile(
                          title: 'Sales Management',
                          subtitle: 'Process sales, generate reports',
                          icon: Icons.point_of_sale,
                          color: Colors.green,
                          onTap: goToSales,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(bool isTablet) {
    return SingleChildScrollView(
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
                icon: Icons.inventory_2,
              ),
              _StatusCard(
                title: 'Low Stock',
                value: _lowStock,
                color: Colors.orange,
                icon: Icons.warning_amber,
              ),
              _StatusCard(
                title: 'Expired',
                value: _expired,
                color: Colors.redAccent,
                icon: Icons.schedule,
              ),
              _StatusCard(
                title: 'Out of Stock',
                value: _outOfStock,
                color: Colors.deepPurple,
                icon: Icons.remove_circle_outline,
              ),
            ],
          ),

          const SizedBox(height: 28),

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
    );
  }

  Widget _buildQuickStat(String title, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void goToInventory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InventoryScreen()),
    );
  }

  void goToSales() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SalesScreen()));
  }
}

/// Enhanced status card with icon support
class _StatusCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final IconData? icon;

  const _StatusCard({
    required this.title,
    required this.value,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
          ],
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
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// Original dashboard tile for mobile
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

/// Enhanced desktop dashboard tile
class _DesktopDashboardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DesktopDashboardTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Open',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
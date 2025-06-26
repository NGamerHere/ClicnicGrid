import 'package:flutter/material.dart';
import "../../models/InventoryItem.dart";
import "../../services/ApiClient.dart";

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => __InventoryScreen();
}

class __InventoryScreen extends State<InventoryScreen> {
  List<InventoryItem> allItems = [];
  List<InventoryItem> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    _fetchInventory();
    searchController.addListener(_onSearchChanged);
  }

  void _fetchInventory() async {
    final response = await ApiClient().get("/medicine");

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;

      List<InventoryItem> parsed = data
          .map((item) => InventoryItem.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        allItems = parsed;
        filteredItems = List.from(parsed);
      });
      isLoading=false;
    } else {
      isLoading=false;
      debugPrint("Error fetching inventory: ${response.statusCode}");
    }
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = allItems
          .where((item) =>
          item.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Inventory screen")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading ? const Center(child: CircularProgressIndicator()) :filteredItems.isEmpty
                  ? const Center(child: Text('No items found'))
                  : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3, // shadow depth
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(filteredItems[index].name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Description here..."),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

        )
    );
  }
}



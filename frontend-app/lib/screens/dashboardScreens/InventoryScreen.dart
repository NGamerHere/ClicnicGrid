import 'dart:async';
import 'package:flutter/material.dart';
import "../../models/InventoryItem.dart";
import "../../services/ApiClient.dart";
import "./SingleInventoryScreen.dart";

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => __InventoryScreen();
}

class __InventoryScreen extends State<InventoryScreen> {
  List<InventoryItem> results = [];
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  bool isLoading = false;
  int currentPage = 0;
  bool isLastPage = false;
  final int pageSize = 20;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _fetchPage();
    searchController.addListener(_onSearchChanged);
  }

  void _fetchPage() async {
    if (isLoading || isLastPage) return;

    setState(() => isLoading = true);

    final response = await ApiClient().get(
      "/medicine?page=$currentPage&size=$pageSize",
    );

    if (response.statusCode == 200) {
      final rawList = response.data['content'] ?? response.data;

      final List<InventoryItem> parsed = (rawList as List)
          .map((item) => InventoryItem.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        results.addAll(parsed);
        isLastPage = parsed.length < pageSize;
        currentPage++;
      });
    } else {
      debugPrint("Error fetching page: ${response.statusCode}");
    }

    setState(() => isLoading = false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchPage();
    }
  }

  void _fetchAll() async {
    setState(() => isLoading = true);
    final response = await ApiClient().get("/medicine");

    if (response.statusCode == 200) {
      final data = response.data;

      final List<dynamic> rawList = data is List ? data : data['content'];

      List<InventoryItem> parsed = rawList
          .map((item) => InventoryItem.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() => results = parsed);
    } else {
      debugPrint("Error fetching data: ${response.statusCode}");
    }
    setState(() => isLoading = false);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        _fetchAll();
      } else {
        _searchBackend(query);
      }
    });
  }

  void _searchBackend(String query) async {
    setState(() => isLoading = true);
    final response = await ApiClient().get("/medicine/search?query=$query");

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['content'] ?? response.data;
      List<InventoryItem> parsed = data
          .map((item) => InventoryItem.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() => results = parsed);
    } else {
      debugPrint("Search error: ${response.statusCode}");
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inventory Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
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
            child: isLoading && results.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : results.isEmpty
                ? const Center(child: Text("No results found"))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: results.length + (isLastPage ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == results.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = results[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SingleInventoryScreen(item: item),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom:  10.0),
                                      child: Text(item.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      item.type,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(item.description),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 6,
                                children: [
                                  _buildInfoChip(
                                    "₹${item.price}",
                                    Icons.currency_rupee,
                                  ),
                                  _buildInfoChip(
                                    "Qty: ${item.quantity}",
                                    Icons.inventory,
                                  ),
                                  _buildInfoChip(
                                    "Stack: ${item.itemsPerStack}",
                                    Icons.layers,
                                  ),
                                  _buildInfoChip(
                                    "Weight: ${item.weight}g",
                                    Icons.scale,
                                  ),
                                  _buildInfoChip(
                                    "Volume: ${item.volume}ml",
                                    Icons.local_drink,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Expires: ${item.expiresOn}",
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInfoChip(String label, IconData icon) {
  return Chip(
    avatar: Icon(icon, size: 16, color: Colors.white),
    label: Text(label, style: const TextStyle(color: Colors.white)),
    backgroundColor: Colors.indigo,
    padding: const EdgeInsets.symmetric(horizontal: 8),
  );
}

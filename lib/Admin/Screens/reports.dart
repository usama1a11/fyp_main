/*
import 'package:flutter/material.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: Text("Reports",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold, fontSize: 25),),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Text("Usama"),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

/*class _AdminReportsState extends State<AdminReports> {
  String selectedCategory = "All";
  final List<String> categories = ["All", "Chair", "Table", "Bed", "Sofa"];

  // Mock Data
  final Map<String, List<Map<String, dynamic>>> reportData = {
    "All": [
      {"name": "Chair", "sales": 120, "revenue": 2400, "profit": 1200},
      {"name": "Table", "sales": 80, "revenue": 3200, "profit": 1800},
      {"name": "Bed", "sales": 50, "revenue": 5000, "profit": 3000},
      {"name": "Sofa", "sales": 60, "revenue": 6000, "profit": 3500},
    ],
    "Chair": [
      {"name": "Chair", "sales": 120, "revenue": 2400, "profit": 1200},
    ],
    "Table": [
      {"name": "Table", "sales": 80, "revenue": 3200, "profit": 1800},
    ],
    "Bed": [
      {"name": "Bed", "sales": 50, "revenue": 5000, "profit": 3000},
    ],
    "Sofa": [
      {"name": "Sofa", "sales": 60, "revenue": 6000, "profit": 3500},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Fetch data for selected category
    final data = reportData[selectedCategory] ?? [];

    // Calculate totals
    final totalSales = data.fold(0, (sum, item) => sum + item['sales']);
    final totalRevenue = data.fold(0, (sum, item) => sum + item['revenue']);
    final totalProfit = data.fold(0, (sum, item) => sum + item['profit']);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: const Text(
            "Reports",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown to select category
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
                items: categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard("Total Sales", totalSales),
                  _buildSummaryCard("Total Revenue", totalRevenue),
                  _buildSummaryCard("Total Profit", totalProfit),
                ],
              ),
              const SizedBox(height: 20),

              // Detailed Report
              Expanded(
                child: data.isNotEmpty
                    ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(item['name']),
                        subtitle: Text(
                            "Sales: ${item['sales']} | Revenue: \$${item['revenue']} | Profit: \$${item['profit']}"),
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Summary card widget
  Widget _buildSummaryCard(String title, int value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}*/
class _AdminReportsState extends State<AdminReports> {
  String selectedCategory = "All";
  final List<String> categories = ["All", "Chair", "Table", "Bed", "Sofa"];

  // Mock Data
  final Map<String, List<Map<String, dynamic>>> reportData = {
    "All": [
      {"name": "Chair", "sales": 120, "revenue": 2400, "profit": 1200},
      {"name": "Table", "sales": 80, "revenue": 3200, "profit": 1800},
      {"name": "Bed", "sales": 50, "revenue": 5000, "profit": 3000},
      {"name": "Sofa", "sales": 60, "revenue": 6000, "profit": 3500},
    ],
    "Chair": [
      {"name": "Chair", "sales": 120, "revenue": 2400, "profit": 1200},
    ],
    "Table": [
      {"name": "Table", "sales": 80, "revenue": 3200, "profit": 1800},
    ],
    "Bed": [
      {"name": "Bed", "sales": 50, "revenue": 5000, "profit": 3000},
    ],
    "Sofa": [
      {"name": "Sofa", "sales": 60, "revenue": 6000, "profit": 3500},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Fetch data for selected category
    final data = reportData[selectedCategory] ?? [];

    // Calculate totals
    final totalSales = data.fold<num>(0, (sum, item) => sum + item['sales']).toInt();
    final totalRevenue = data.fold<num>(0, (sum, item) => sum + item['revenue']).toInt();
    final totalProfit = data.fold<num>(0, (sum, item) => sum + item['profit']).toInt();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown.withOpacity(0.7),
          centerTitle: true,
          title: const Text(
            "Reports",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown, Colors.brown.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown to select category
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
                items: categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard("Total Sales", totalSales),
                  _buildSummaryCard("Total Revenue", totalRevenue),
                  _buildSummaryCard("Total Profit", totalProfit),
                ],
              ),
              const SizedBox(height: 20),

              // Detailed Report
              Expanded(
                child: data.isNotEmpty
                    ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(item['name']),
                        subtitle: Text(
                            "Sales: ${item['sales']} | Revenue: \$${item['revenue']} | Profit: \$${item['profit']}"),
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Summary card widget
  Widget _buildSummaryCard(String title, int value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HelpCenterScreen(),
    );
  }
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        title: Center(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.key, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Centre d'
                'aide',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF073057),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildSearchSection(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabButton('FAQ', 0),
              _buildTabButton('Contactez-nous', 1),
            ],
          ),
          Expanded(
            child:
                selectedIndex == 0
                    ? _buildFAQSection()
                    : _buildContactSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFA3C3E4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Comment Pouvons-Nous Vous Aider ?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF073057),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Rechercher...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 50),
          backgroundColor:
              selectedIndex == index ? Color(0xFF073057) : Color(0xFFCAD6FF),
        ),
        onPressed: () => setState(() => selectedIndex = index),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                selectedIndex == index
                    ? Color.fromARGB(255, 255, 255, 255)
                    : Color(0xFF396C9B),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(5, (index) {
        return ExpansionTile(
          title: Text('Lorem ipsum dolor sit amet?'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque...',
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildContactSection() {
    final contacts = [
      {'icon': Icons.support_agent, 'title': 'Service Client'},
      {'icon': Icons.language, 'title': 'Site Web'},
      {'icon': Icons.phone, 'title': 'Whatsapp'},
      {'icon': Icons.facebook, 'title': 'Facebook'},
      {'icon': Icons.camera, 'title': 'Instagram'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children:
          contacts.map((contact) {
            return ListTile(
              leading: Icon(contact['icon'] as IconData),
              title: Text(contact['title'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          }).toList(),
    );
  }
}

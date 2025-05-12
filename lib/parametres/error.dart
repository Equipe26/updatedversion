import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpScreen> {
  int _selectedIndex = 0;
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Centre d'
          'aide',
        ),
        backgroundColor: Colors.blue[200],
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildTabBar(),
          if (_showError) _buildErrorSection(),
          Expanded(
            child:
                _selectedIndex == 0
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
      color: Colors.blue[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comment Pouvons-Nous Vous Aider ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabButton('FAQ', 0),
          _buildTabButton('Contactez-nous', 1),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showError = !_showError;
              });
            },
            child: const Text('Erreur'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return ElevatedButton(
      onPressed: () => setState(() => _selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedIndex == index ? Colors.blue[300] : Colors.blue[100],
      ),
      child: Text(label),
    );
  }

  Widget _buildFAQSection() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder:
          (context, index) => ListTile(
            title: Text('Lorem ipsum dolor sit amet?'),
            subtitle: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            ),
            trailing: Icon(Icons.expand_more),
          ),
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

  Widget _buildErrorSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            'Une erreur est survenue. Comment pouvons-nous vous aider ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showError = false;
              });
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

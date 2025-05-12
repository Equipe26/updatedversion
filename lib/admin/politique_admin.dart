import 'package:flutter/material.dart';
import 'admin_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PrivacyPolicyScreenAdmin(),
    );
  }
}

class PrivacyPolicyScreenAdmin extends StatefulWidget {
  const PrivacyPolicyScreenAdmin({super.key});

  @override
  _PrivacyPolicyScreenAdminState createState() => _PrivacyPolicyScreenAdminState();
}

class _PrivacyPolicyScreenAdminState extends State<PrivacyPolicyScreenAdmin> {
  final AdminService _adminService = AdminService();
  bool isLoading = true;
  bool isSaving = false;
  String lastUpdated = DateFormat('dd/MM/yyyy').format(DateTime.now());
  
  // TextControllers for each section of the policy
  final TextEditingController introController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> dataCollectedControllers = [];
  final List<TextEditingController> dataUsageControllers = [];
  final List<TextEditingController> storageSecurityControllers = [];
  final List<TextEditingController> dataSharingControllers = [];
  final List<TextEditingController> userRightsControllers = [];
  final TextEditingController consentController = TextEditingController();
  final List<TextEditingController> dataSensitiveControllers = [];
  final TextEditingController policyModController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrivacyPolicy();
  }

  @override
  void dispose() {
    introController.dispose();
    descriptionController.dispose();
    
    for (var controller in dataCollectedControllers) {
      controller.dispose();
    }
    
    for (var controller in dataUsageControllers) {
      controller.dispose();
    }
    
    for (var controller in storageSecurityControllers) {
      controller.dispose();
    }
    
    for (var controller in dataSharingControllers) {
      controller.dispose();
    }
    
    for (var controller in userRightsControllers) {
      controller.dispose();
    }
    
    consentController.dispose();
    
    for (var controller in dataSensitiveControllers) {
      controller.dispose();
    }
    
    policyModController.dispose();
    contactController.dispose();
    
    super.dispose();
  }
  
  Future<void> _loadPrivacyPolicy() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final policyData = await _adminService.getPrivacyPolicy();
      final content = policyData['content'] as Map<String, dynamic>;
      
      if (policyData['lastUpdated'] != null) {
        // Parse the timestamp and format it
        try {
          DateTime date = DateTime.parse(policyData['lastUpdated']);
          lastUpdated = DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          lastUpdated = DateFormat('dd/MM/yyyy').format(DateTime.now());
        }
      }
      
      // Clear existing controllers
      dataCollectedControllers.clear();
      dataUsageControllers.clear();
      storageSecurityControllers.clear();
      dataSharingControllers.clear();
      userRightsControllers.clear();
      dataSensitiveControllers.clear();
      
      // Set text for controllers
      introController.text = content['intro'] ?? '';
      descriptionController.text = content['description'] ?? '';
      
      // Add controllers for list items
      final dataCollected = content['dataCollected'] as List<dynamic>? ?? [];
      for (var item in dataCollected) {
        final controller = TextEditingController(text: item.toString());
        dataCollectedControllers.add(controller);
      }
      
      final dataUsage = content['dataUsage'] as List<dynamic>? ?? [];
      for (var item in dataUsage) {
        final controller = TextEditingController(text: item.toString());
        dataUsageControllers.add(controller);
      }
      
      final storageSecurity = content['storageSecurity'] as List<dynamic>? ?? [];
      for (var item in storageSecurity) {
        final controller = TextEditingController(text: item.toString());
        storageSecurityControllers.add(controller);
      }
      
      final dataSharing = content['dataSharing'] as List<dynamic>? ?? [];
      for (var item in dataSharing) {
        final controller = TextEditingController(text: item.toString());
        dataSharingControllers.add(controller);
      }
      
      final userRights = content['userRights'] as List<dynamic>? ?? [];
      for (var item in userRights) {
        final controller = TextEditingController(text: item.toString());
        userRightsControllers.add(controller);
      }
      
      consentController.text = content['consent'] ?? '';
      
      final dataSensitive = content['dataSensitive'] as List<dynamic>? ?? [];
      for (var item in dataSensitive) {
        final controller = TextEditingController(text: item.toString());
        dataSensitiveControllers.add(controller);
      }
      
      policyModController.text = content['policyMod'] ?? '';
      contactController.text = content['contact'] ?? '';
      
      // If any list is empty, add at least one empty controller
      if (dataCollectedControllers.isEmpty) dataCollectedControllers.add(TextEditingController());
      if (dataUsageControllers.isEmpty) dataUsageControllers.add(TextEditingController());
      if (storageSecurityControllers.isEmpty) storageSecurityControllers.add(TextEditingController());
      if (dataSharingControllers.isEmpty) dataSharingControllers.add(TextEditingController());
      if (userRightsControllers.isEmpty) userRightsControllers.add(TextEditingController());
      if (dataSensitiveControllers.isEmpty) dataSensitiveControllers.add(TextEditingController());
      
    } catch (e) {
      print('Error loading privacy policy: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement de la politique de confidentialité'))
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _savePrivacyPolicy() async {
    setState(() {
      isSaving = true;
    });
    
    try {
      final Map<String, dynamic> policyContent = {
        'intro': introController.text,
        'description': descriptionController.text,
        'dataCollected': dataCollectedControllers.map((controller) => controller.text).toList(),
        'dataUsage': dataUsageControllers.map((controller) => controller.text).toList(),
        'storageSecurity': storageSecurityControllers.map((controller) => controller.text).toList(),
        'dataSharing': dataSharingControllers.map((controller) => controller.text).toList(),
        'userRights': userRightsControllers.map((controller) => controller.text).toList(),
        'consent': consentController.text,
        'dataSensitive': dataSensitiveControllers.map((controller) => controller.text).toList(),
        'policyMod': policyModController.text,
        'contact': contactController.text,
      };
      
      await _adminService.updatePrivacyPolicy({'content': policyContent});
      
      setState(() {
        lastUpdated = DateFormat('dd/MM/yyyy').format(DateTime.now());
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Politique de confidentialité mise à jour avec succès'))
      );
    } catch (e) {
      print('Error saving privacy policy: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde de la politique de confidentialité'))
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

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
                'Politique de confidentialité',
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

      body: isLoading 
      ? const Center(child: CircularProgressIndicator(color: Color(0xFF396C9B)))
      : Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          width: 412,
          height: 917,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dernière Mise A Jour: $lastUpdated",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF073057),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFF073057)),
                      onPressed: _loadPrivacyPolicy,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Introduction
                _buildSectionTitle("Introduction"),
                _buildTextField(introController, "Introduction de la politique"),
                const SizedBox(height: 10),
                _buildTextField(descriptionController, "Description de l'application"),
                const SizedBox(height: 20),
                
                // 1. Données collectées
                _buildSectionTitle("1. Données collectées"),
                ...dataCollectedControllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return _buildListItemField(
                    dataCollectedControllers, 
                    idx, 
                    "Donnée collectée ${idx+1}",
                    onAdd: () => setState(() {
                      dataCollectedControllers.add(TextEditingController());
                    }),
                    onRemove: dataCollectedControllers.length > 1 ? () => setState(() {
                      dataCollectedControllers.removeAt(idx);
                    }) : null,
                  );
                }).toList(),
                const SizedBox(height: 20),
                
                // 2. Utilisation des données
                _buildSectionTitle("2. Utilisation des données"),
                ...dataUsageControllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return _buildListItemField(
                    dataUsageControllers, 
                    idx, 
                    "Utilisation ${idx+1}",
                    onAdd: () => setState(() {
                      dataUsageControllers.add(TextEditingController());
                    }),
                    onRemove: dataUsageControllers.length > 1 ? () => setState(() {
                      dataUsageControllers.removeAt(idx);
                    }) : null,
                  );
                }).toList(),
                const SizedBox(height: 20),
                
                // 3. Stockage et Sécurité
                _buildSectionTitle("3. Stockage et Sécurité"),
                ...storageSecurityControllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return _buildListItemField(
                    storageSecurityControllers, 
                    idx, 
                    "Stockage et sécurité ${idx+1}",
                    onAdd: () => setState(() {
                      storageSecurityControllers.add(TextEditingController());
                    }),
                    onRemove: storageSecurityControllers.length > 1 ? () => setState(() {
                      storageSecurityControllers.removeAt(idx);
                    }) : null,
                  );
                }).toList(),
                const SizedBox(height: 20),
                
                // 4. Partage des données
                _buildSectionTitle("4. Partage des données"),
                ...dataSharingControllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return _buildListItemField(
                    dataSharingControllers, 
                    idx, 
                    "Partage des données ${idx+1}",
                    onAdd: () => setState(() {
                      dataSharingControllers.add(TextEditingController());
                    }),
                    onRemove: dataSharingControllers.length > 1 ? () => setState(() {
                      dataSharingControllers.removeAt(idx);
                    }) : null,
                  );
                }).toList(),
                const SizedBox(height: 20),
                
                // 5. Vos droits
                _buildSectionTitle("5. Vos droits"),
                ...userRightsControllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return _buildListItemField(
                    userRightsControllers, 
                    idx, 
                    "Droit ${idx+1}",
                    onAdd: () => setState(() {
                      userRightsControllers.add(TextEditingController());
                    }),
                    onRemove: userRightsControllers.length > 1 ? () => setState(() {
                      userRightsControllers.removeAt(idx);
                    }) : null,
                  );
                }).toList(),
                const SizedBox(height: 20),
                
                // 6. Consentement
                _buildSectionTitle("6. Consentement"),
                _buildTextField(consentController, "Texte concernant le consentement"),
                const SizedBox(height: 20),
                
                // 7. Protection des données sensibles
                _buildSectionTitle("7. Protection des données sensibles"),
                ...dataSensitiveControllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return _buildListItemField(
                    dataSensitiveControllers, 
                    idx, 
                    "Protection des données sensibles ${idx+1}",
                    onAdd: () => setState(() {
                      dataSensitiveControllers.add(TextEditingController());
                    }),
                    onRemove: dataSensitiveControllers.length > 1 ? () => setState(() {
                      dataSensitiveControllers.removeAt(idx);
                    }) : null,
                  );
                }).toList(),
                const SizedBox(height: 20),
                
                // 8. Modifications de la politique
                _buildSectionTitle("8. Modifications de la politique"),
                _buildTextField(policyModController, "Texte concernant les modifications de la politique"),
                const SizedBox(height: 20),
                
                // 9. Nous contacter
                _buildSectionTitle("9. Nous contacter"),
                _buildTextField(contactController, "Texte concernant le contact"),
                const SizedBox(height: 40),
                
                // Save button
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _savePrivacyPolicy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF396C9B),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isSaving 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text(
                          'Enregistrer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for building UI components
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF073057),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFA3C3E4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFFA3C3E4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF396C9B), width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        maxLines: 4,
        minLines: 2,
      ),
    );
  }

  Widget _buildListItemField(List<TextEditingController> controllers, int index, String hint, {VoidCallback? onAdd, VoidCallback? onRemove}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "• ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controllers[index],
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color(0xFFA3C3E4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color(0xFFA3C3E4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color(0xFF396C9B), width: 2.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onRemove != null)
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: onRemove,
                ),
              if (onAdd != null && index == controllers.length - 1)
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: onAdd,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

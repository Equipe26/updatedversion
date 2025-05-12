import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import 'package:flutter_application_2/models/Service.dart';
import '../../models/services_service.dart';
import 'package:flutter_application_2/models/Specialty.dart';

class ServicesScreen extends StatefulWidget {
  final HealthcareType healthcareType;
  final String professionalId; // ID du médecin connecté

  const ServicesScreen({
    Key? key,
    required this.healthcareType,
    required this.professionalId,
  }) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  static const Color myLightBlue = Color(0xFFA3C3E4);

  final ServicesService _servicesService = ServicesService();
  late Future<List<Service>> _servicesFuture;
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() {
    setState(() {
      _servicesFuture = _servicesService.getServicesByProfessional(widget.professionalId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Mes services',
          style: TextStyle(
            color: myDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<List<Service>>(
                future: _servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucun service disponible'));
                  }

                  final services = snapshot.data!;
                  return ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return _buildServiceItem(services[index]);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: myBlue2,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                onPressed: () => _showAddServiceDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(Service service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: myLightBlue, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: myLightBlue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.medical_services,
              color: myBlue2, size: 20),
        ),
        title: Text(
          service.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: myDarkBlue,
          ),
        ),
        subtitle: Text(
          '${service.price} DA',
          style: TextStyle(
            color: myBlue2,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDeleteService(service),
        ),
        onTap: () {
          _showServiceDetails(service);
        },
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    Specialty? selectedSpecialty;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un nouveau service'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _serviceNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du service',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _serviceDescController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _servicePriceController,
                  decoration: const InputDecoration(
                    labelText: 'Prix (DA)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                if (widget.healthcareType == HealthcareType.medecin)
                  DropdownButtonFormField<Specialty>(
                    decoration: const InputDecoration(
                      labelText: 'Spécialité',
                      border: OutlineInputBorder(),
                    ),
                    items: Specialty.values.map((specialty) {
                      return DropdownMenuItem(
                        value: specialty,
                        child: Text(specialty.name),
                      );
                    }).toList(),
                    onChanged: (Specialty? value) {
                      selectedSpecialty = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner une spécialité';
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_serviceNameController.text.isEmpty ||
                    _servicePriceController.text.isEmpty ||
                    (widget.healthcareType == HealthcareType.medecin && 
                     selectedSpecialty == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs requis'),
                    ),
                  );
                  return;
                }

                try {
                  final newService = Service(
                    id: '', // Généré par Firestore
                    name: _serviceNameController.text,
                    description: _serviceDescController.text,
                    price: double.parse(_servicePriceController.text),
                    healthcareType: widget.healthcareType,
                    specialty: selectedSpecialty,
                    professionalId: widget.professionalId,
                    isApproved: true, // À adapter selon votre workflow
                  );

                  await _servicesService.addService(newService);
                  
                  // Réinitialiser les champs
                  _serviceNameController.clear();
                  _serviceDescController.clear();
                  _servicePriceController.clear();
                  
                  // Recharger la liste
                  _loadServices();
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service ajouté avec succès'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteService(Service service) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer le service "${service.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                try {
                  await _servicesService.deleteService(service.id);
                  _loadServices();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service supprimé avec succès'),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de la suppression: $e')),
                  );
                }
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _showServiceDetails(Service service) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(service.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  service.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Prix: ${service.price} DA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: myBlue2,
                  ),
                ),
                if (service.specialty != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Spécialité: ${service.specialty!.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _serviceDescController.dispose();
    _servicePriceController.dispose();
    super.dispose();
  }
}
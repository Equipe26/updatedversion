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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Comment Pouvons-Nous Vous Aider ?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF073057),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Color(0xFF396C9B)),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Rechercher dans la FAQ...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildSearchTag('Rendez-vous'),
              _buildSearchTag('Documents'),
              _buildSearchTag('Urgence'),
              _buildSearchTag('Compte'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchTag(String text) {
    return InkWell(
      onTap: () {
        // Handle tag tap
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF396C9B).withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF396C9B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
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
    final faqs = [
      {
        'question': 'Comment prendre un rendez-vous médical ?',
        'answer': 'Pour prendre un rendez-vous, accédez à l\'écran "Découvrir", sélectionnez un professionnel de santé, puis appuyez sur "Prendre RDV". Vous pourrez ensuite choisir une date et une heure parmi les disponibilités, sélectionner un service et confirmer votre rendez-vous.'
      },
      {
        'question': 'Comment accéder à mes documents médicaux ?',
        'answer': 'Tous vos documents médicaux sont accessibles dans l\'onglet "Fichiers". Vous pouvez les filtrer par type de document, par médecin ou les trier dans l\'ordre alphabétique ou chronologique. Vous pouvez également sauvegarder des documents importants pour un accès rapide.'
      },
      {
        'question': 'Comment ajouter un médecin à mes favoris ?',
        'answer': 'Dans la section "Découvrir", recherchez le professionnel de santé qui vous intéresse et appuyez sur l\'icône en forme de cœur à côté de son nom. Vous retrouverez ensuite tous vos favoris dans l\'onglet "Favoris".'
      },
      {
        'question': 'Que faire en cas d\'urgence médicale ?',
        'answer': 'En cas d\'urgence médicale, utilisez la fonction "Urgence médicale" sur l\'écran d\'accueil. Vous pouvez appeler directement les secours ou alerter un proche. Pour des situations très graves, composez le 15 (SAMU) ou rendez-vous aux urgences les plus proches.'
      },
      {
        'question': 'Comment évaluer un professionnel de santé ?',
        'answer': 'Après une consultation, vous pouvez noter le professionnel en accédant à sa fiche depuis l\'onglet "Favoris" ou "Découvrir". Cliquez sur les étoiles pour attribuer une note et laissez un commentaire pour partager votre expérience avec les autres utilisateurs.'
      },
      {
        'question': 'Comment modifier mes informations personnelles ?',
        'answer': 'Accédez à votre profil en appuyant sur votre photo dans le coin supérieur gauche de l\'écran d\'accueil. Vous pourrez alors modifier vos informations personnelles, votre adresse, vos contacts d\'urgence et vos préférences de notification.'
      },
      {
        'question': 'Comment fonctionne la messagerie avec les professionnels ?',
        'answer': 'L\'application vous permet de communiquer directement avec les professionnels de santé via l\'onglet "Messages". Vous pouvez poser des questions, envoyer des documents ou recevoir des instructions post-consultation de façon sécurisée et confidentielle.'
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: faqs.map((faq) {
        return ExpansionTile(
          title: Text(faq['question'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF396C9B))),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                faq['answer'] as String,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildContactSection() {
    final contacts = [
    /*  {
        'icon': Icons.support_agent, 
        'title': 'Service Client', 
        'subtitle': 'Assistance 7j/7 de 8h à 20h',
        'action': '023 29 14 14'
      },*/
      {
        'icon': Icons.local_hospital, 
        'title': 'Urgences', 
        'subtitle': 'Protection civile',
        'action': '14'
      },
      {
        'icon': Icons.email_outlined, 
        'title': 'Email', 
        'subtitle': 'Réponse sous 24h',
        'action': 'support@chifaa-app.dz'
      },
     /* {
        'icon': Icons.language, 
        'title': 'Site Web', 
        'subtitle': 'www.chifaa-app.dz',
        'action': 'Visiter'
      },*/
      {
        'icon': Icons.phone_in_talk, 
        'title': 'Whatsapp', 
        'subtitle': 'Chat en direct',
        'action': '+213 665 076 623'
      },
      /*{
        'icon': Icons.facebook, 
        'title': 'Facebook', 
        'subtitle': '@ChifaaApp',
        'action': 'Suivre'
      },
      {
        'icon': Icons.camera_alt, 
        'title': 'Instagram', 
        'subtitle': '@Chifaa_Officiel',
        'action': 'Suivre'
      },*/
      {
        'icon': Icons.info_outline, 
        'title': 'À propos de Chifaa', 
        'subtitle': 'Version 1.2.3',
        'action': 'En savoir plus'
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: contacts.length,
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFA3C3E4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              contact['icon'] as IconData,
              color: Color(0xFF073057),
              size: 24,
            ),
          ),
          title: Text(
            contact['title'] as String,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF073057),
            ),
          ),
          subtitle: Text(
            contact['subtitle'] as String,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                contact['action'] as String,
                style: TextStyle(
                  color: Color(0xFF396C9B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF396C9B)),
            ],
          ),
          onTap: () {
            // Action handling would go here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Contacter via ${contact['title']}')),
            );
          },
        );
      },
    );
  }
}

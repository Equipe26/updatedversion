import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  static const Color myLightBlue = Color(0xFFA3C3E4);

  // Liste de commentaires fictifs
  final List<Map<String, dynamic>> comments = [
    {
      "name": "Sarah",
      "comment": "Service rapide et efficace, merci !",
      "time": "Aujourd'hui",
      "stars": 5,
      "avatar": "S"
    },
    {
      "name": "Mohammed",
      "comment": "Dommage que ce soit fermé le dimanche.",
      "time": "Hier",
      "stars": 3,
      "avatar": "M"
    },
    {
      "name": "Fatima",
      "comment": "Personnel très accueillant et professionnel.",
      "time": "15 Mars",
      "stars": 4,
      "avatar": "F"
    },
    {
      "name": "Karim",
      "comment": "Délai d'attente un peu long mais service impeccable.",
      "time": "14 Mars",
      "stars": 4,
      "avatar": "K"
    },
    {
      "name": "Leila",
      "comment": "Très satisfaite de la qualité des produits.",
      "time": "12 Mars",
      "stars": 5,
      "avatar": "L"
    },
    {
      "name": "Youssef",
      "comment": "Ouverture tardive le jeudi pratique pour ceux qui travaillent.",
      "time": "10 Mars",
      "stars": 5,
      "avatar": "Y"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: myDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tous les avis',
          style: TextStyle(
            color: myDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return _buildCommentItem(comments[index]);
        },
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: myLightBlue, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: myBlue2,
                  child: Text(
                    comment["avatar"],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: myDarkBlue,
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) => Icon(
                            Icons.star,
                            color: index < comment["stars"] ? Colors.amber : Colors.grey,
                            size: 16,
                          )),
                          SizedBox(width: 8),
                          Text(
                            comment["time"],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              comment["comment"],
              style: TextStyle(
                color: myDarkBlue,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up, color: myBlue2, size: 20),
                  onPressed: () {},
                ),
                Text(
                  '12',
                  style: TextStyle(color: myBlue2),
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.thumb_down, color: myBlue2, size: 20),
                  onPressed: () {},
                ),
                Text(
                  '2',
                  style: TextStyle(color: myBlue2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
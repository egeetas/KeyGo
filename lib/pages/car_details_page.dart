import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final List<Map<String, String>> cars = [
    {
      'name': 'Fiat 500',
      'image': 'https://www.bilenoto.com.tr/mp-include/uploads/2023/04/500e.png',
      'person': '5 PERSON',
      'age': '<21 age',
      'block': '4.000 ₺'
    },
    {
      'name': 'Audi A3',
      'image':
          'https://mediaservice.audi.com/media/fast/H4sIAAAAAAAA_1vzloG1tIiBOTrayfuvpGh6-m1zJgaGigIGBgZGoDhTtNOaz-I_2DhCHsCEtzEwF-SlMwJZKUycmbmJ6an6QD4_I3taTmV-aUkxO0grj3HfPMmrHdWXmtb_ERUyzLs28ZZwHAMrUBfjDSDBPA1I8BUACU5pBjAJMu8AiGgC8ZnsmRkYWCuAjEgGEODjKy3KKUgsSszVK89MKckQ1DAgEgizu7iGOHr6BAMAFL_FrOkAAAA',
      'person': '5 PERSON',
      'age': '<21 age',
      'block': '12.000 ₺'
    },
    {
      'name': 'BMW i4',
      'image':
          'https://file.kelleybluebookimages.com/kbb/base/evox/CP/51577/2023-BMW-i4-front_51577_032_2400x1800_300_nologo.png',
      'person': '5 PERSON',
      'age': '<25 age',
      'block': '20.000 ₺'
    },
    {
      'name': 'Bugatti Chiron',
      'image': 'https://img.pcauto.com/model/images/touPic/my/Bugatti-Chiron_4868_d6008f2f8e5e42fb9a2c52ccf74f0233.png',
      'person': '2 PERSON',
      'age': '<25 age',
      'block': '30.000 ₺'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: cars.map((car) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 210, // Audi A3 ve diğerleriyle eşit yükseklik
                      width: double.infinity,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Image.network(
                        car['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(car['name']!,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      InfoBox(label: "Automatic"),
                      InfoBox(label: car['person']!),
                      InfoBox(label: car['age']!),
                      InfoBox(label: "Blocked Amount\n${car['block']}"),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Rezervasyon işlemi
                    },
                    child: Text("Reserve"),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 1.5),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "Cars"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String label;
  const InfoBox({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140, // hizalama için sabit genişlik verdik
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

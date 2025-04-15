import 'package:flutter/material.dart';
import 'car_details_page.dart';  // ikinci sayfaya geçiş için

class RentalCarList extends StatelessWidget {
  final List<Map<String, String>> cars = [
    {
      'name': 'Fiat 500',
      'image': 'https://www.bilenoto.com.tr/mp-include/uploads/2023/04/500e.png'
    },
    {
      'name': 'Audi A3',
      'image':
          'https://mediaservice.audi.com/media/fast/H4sIAAAAAAAA_1vzloG1tIiBOTrayfuvpGh6-m1zJgaGigIGBgZGoDhTtNOaz-I_2DhCHsCEtzEwF-SlMwJZKUycmbmJ6an6QD4_I3taTmV-aUkxO0grj3HfPMmrHdWXmtb_ERUyzLs28ZZwHAMrUBfjDSDBPA1I8BUACU5pBjAJMu8AiGgC8ZnsmRkYWCuAjEgGEODjKy3KKUgsSszVK89MKckQ1DAgEgizu7iGOHr6BAMAFL_FrOkAAAA'
    },
    {
      'name': 'BMW i4',
      'image':
          'https://file.kelleybluebookimages.com/kbb/base/evox/CP/51577/2023-BMW-i4-front_51577_032_2400x1800_300_nologo.png'
    },
    {
      'name': 'Bugatti Chiron',
      'image':
          'https://img.pcauto.com/model/images/touPic/my/Bugatti-Chiron_4868_d6008f2f8e5e42fb9a2c52ccf74f0233.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rental Car List")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Column(
            children: cars.map((car) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔧 GÖRSEL DÜZENLENDİ
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        child: Container(
                          height: 210,
                          width: double.infinity,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Image.network(
                            car['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),

                      ),
                      SizedBox(height: 12),
                      Text(
                        car['name']!,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.settings),
                              SizedBox(height: 4),
                              Text("Automatic"),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.person),
                              SizedBox(height: 4),
                              Text("5 Person"),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsPage(),
                            ),
                          );
                        },
                        child: Text("Choose"),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
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

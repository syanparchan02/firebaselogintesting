import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking/screen/models/fried_chicken.dart';
import 'package:flutter/material.dart';

class AddCookingMenu extends StatelessWidget {
  AddCookingMenu({super.key});
  final chickController = TextEditingController();
  final flavorController = TextEditingController();
  final oilController = TextEditingController();
  final saltController = TextEditingController();
  final db = FirebaseFirestore.instance;

  void _addFriedChicken(BuildContext context) async {
    if (chickController.text.isEmpty ||
        flavorController.text.isEmpty ||
        oilController.text.isEmpty ||
        saltController.text.isEmpty) {
      _showSnackBar(context, 'Please fill all fields');
      return;
    }

    try {
      // final friedChicken = <String, dynamic>{
      //   "chicken": int.parse(chickController.text),
      //   "oil": int.parse(oilController.text),
      //   "salt": int.parse(saltController.text),
      //   "flavor": flavorController.text,
      //   "timestamp": FieldValue.serverTimestamp(),
      // };

      DocumentReference doc = await db
          .collection("fried_chicken")
          .add(
            FriedChicken(
              chicken: int.parse(chickController.text),
              flavor: flavorController.text,
              oil: int.parse(oilController.text),
              salt: int.parse(saltController.text),
            ).toFirebaseMap(),
          );

      print('DocumentSnapshot added with ID: ${doc.id}');

      _showSnackBar(context, 'Data added successfully!');

      _clearForm();
    } catch (e) {
      print('Error adding document: $e');
      _showSnackBar(context, 'Error adding data. Please check your inputs.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  void _clearForm() {
    chickController.clear();
    flavorController.clear();
    oilController.clear();
    saltController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Cooking Menu')),
      body: Padding(
        padding: EdgeInsets.only(top: 30, left: 16, right: 16), // Fixed padding
        child: Column(
          children: [
            TextField(
              controller: chickController,
              decoration: InputDecoration(
                labelText: 'Chicken Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: flavorController,
              decoration: InputDecoration(
                labelText: 'Flavor',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: oilController,
              decoration: InputDecoration(
                labelText: 'Oil Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: saltController,
              decoration: InputDecoration(
                labelText: 'Salt Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _addFriedChicken(context),
              child: Text('Insert to fried'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AddCookingMenu extends StatelessWidget {
//   AddCookingMenu({super.key});
//   final chickcontroller = TextEditingController();
//   final flavorController = TextEditingController();
//   final oilController = TextEditingController();
//   final saltController = TextEditingController();
//   final db = FirebaseFirestore.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsetsGeometry.only(top: 30),
//         child: Column(
//           children: [
//             TextField(controller: chickcontroller),
//             TextField(controller: flavorController),
//             TextField(controller: oilController),
//             TextField(controller: saltController),
//             ElevatedButton(
//               onPressed: () {
//                 // Create a new user with a first and last name
//                 final friedChicken = <String, dynamic>{
//                   "chicken": int.parse(chickcontroller.text),
//                   "oil": int.parse(oilController.text),
//                   "salt": int.parse(saltController.text),
//                   "flavor": flavorController.text,
//                 };

//                 // Add a new document with a generated ID
//                 db
//                     .collection("fried_chicken")
//                     .add(friedChicken)
//                     .then(
//                       (DocumentReference doc) =>
//                           print('DocumentSnapshot added with ID: ${doc.id}'),
//                     )
//                     .catchError((onError) {
//                       print(onError);
//                     });
//               },
//               child: Text('Insert to fried'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCookingMenu extends StatelessWidget {
  AddCookingMenu({super.key});
  final chickController = TextEditingController();
  final flavorController = TextEditingController();
  final oilController = TextEditingController();
  final saltController = TextEditingController();
  final db = FirebaseFirestore.instance;

  void _addFriedChicken(BuildContext context) async {
    // Validate that all fields are filled
    if (chickController.text.isEmpty ||
        flavorController.text.isEmpty ||
        oilController.text.isEmpty ||
        saltController.text.isEmpty) {
      _showSnackBar(context, 'Please fill all fields');
      return;
    }

    try {
      // Create a new user with a first and last name
      final friedChicken = <String, dynamic>{
        "chicken": int.parse(chickController.text),
        "oil": int.parse(oilController.text),
        "salt": int.parse(saltController.text),
        "flavor": flavorController.text,
        "timestamp": FieldValue.serverTimestamp(), // Add timestamp for ordering
      };

      // Add a new document with a generated ID
      DocumentReference doc = await db
          .collection("fried_chicken")
          .add(friedChicken);

      print('DocumentSnapshot added with ID: ${doc.id}');

      // Show success message
      _showSnackBar(context, 'Data added successfully!');

      // Clear form
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


//android/app/src/main/kotlin/com/yourcompany/yourapp/MainActivity.kt
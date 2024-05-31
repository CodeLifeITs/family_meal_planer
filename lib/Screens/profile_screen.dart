import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/common_functions.dart';

final _firestore = FirebaseFirestore.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfileScreen> {
  List<String> foodList = [];
  List<String> popularList = [];
  final _auth = FirebaseAuth.instance;

  String mode(List a) {
    var maxValue = "";
    var maxCount = 0;

    for (var i = 0; i < a.length; ++i) {
      var count = 0;
      for (var j = 0; j < a.length; ++j) {
        if (a[j] == a[i]) ++count;
      }
      if (count > maxCount) {
        maxCount = count;
        maxValue = a[i];
      }
    }
    return maxValue;
  }

  addMealToLists(String meal) {
    if (meal != "") {
      if (foodList.contains(meal)) {
        if (popularList.contains(meal)) {
        } else {
          popularList.add(meal);
        }
      } else {
        foodList.add(meal);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('userMeal')
              .where(Filter.and(
                  Filter("email",
                      isEqualTo: _auth.currentUser?.email.toString()),
                  Filter("date",
                      isGreaterThanOrEqualTo:
                          DateTime.now().subtract(const Duration(days: 14)))))
              .orderBy("date", descending: false) //as DateTime
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            final meals = snapshot.data?.docs;
            foodList.clear();
            popularList.clear();

            for (var meal in meals!) {
              addMealToLists(meal.get("wake"));
              addMealToLists(meal.get("wake"));
              addMealToLists(meal.get("breakfast"));
              addMealToLists(meal.get("lunch"));
              addMealToLists(meal.get("brunch"));
              addMealToLists(meal.get("dinner"));
              addMealToLists(meal.get("supper"));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Hy, ${_auth.currentUser!.displayName} look at your popular dishes.",
                    style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10.0),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: popularList.length,
                      itemBuilder: (BuildContext context, int index) {
                        //popularList.sort();
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 2, color: primaryColor)),
                          child: Center(
                              child: Text(
                            popularList[index].toString(),
                            style: const TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }
}

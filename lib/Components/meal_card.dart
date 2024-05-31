import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meal_planner/Components/common_functions.dart';
import 'package:meal_planner/Components/meals.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;

class MealCard extends StatefulWidget {
  MealCard({required this.myMeal});
  final Meals myMeal;
  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  bool isExpanded = false;
  List<String> favourite = [];
  final _auth = FirebaseAuth.instance;

  updateFavourite(bool save, String meal) async {
    await _firestore
        .collection('favouriteMeal')
        .doc(_auth.currentUser!.email! + meal.toString())
        .set(
      {'email': _auth.currentUser!.email, 'meal': meal, 'favourite': save},
    ).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('favouriteMeal')
            .where(Filter.and(
                Filter("favourite", isEqualTo: true),
                Filter("email",
                    isEqualTo: _auth.currentUser?.email.toString())))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final meals = snapshot.data?.docs;
            favourite.clear();
            for (var meal in meals!) {
              favourite.add(meal.get("meal"));
            }
          }

          return AnimatedContainer(
            height: isExpanded ? 250 : 55,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInCubic,
            child: isExpanded ? expandedChild() : collapsedChild(),
          );
        });
  }

  Widget foodIcon(IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Icon(
        iconData,
        color: primaryColor,
        size: 25,
      ),
    );
  }

  Widget foodText(String head, String title, bool liked) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                head,
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                title == "" ? " - -" : title,
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                updateFavourite(
                    favourite.contains(title) ? false : true, title);
              },
              icon: Icon(
                Icons.favorite,
                color: favourite.contains(title) ? primaryColor : Colors.grey,
              ))
        ],
      ),
    );
  }

  Widget collapsedChild() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 2, color: primaryColor)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  widget.myMeal.wake != ""
                      ? foodIcon(Icons.emoji_food_beverage_rounded)
                      : const SizedBox(),
                  widget.myMeal.breakfast != ""
                      ? foodIcon(Icons.breakfast_dining_rounded)
                      : const SizedBox(),
                  widget.myMeal.brunch != ""
                      ? foodIcon(Icons.brunch_dining)
                      : const SizedBox(),
                  widget.myMeal.lunch != ""
                      ? foodIcon(Icons.lunch_dining)
                      : const SizedBox(),
                  widget.myMeal.dinner != ""
                      ? foodIcon(Icons.dinner_dining_outlined)
                      : const SizedBox(),
                  widget.myMeal.supper != ""
                      ? foodIcon(Icons.food_bank)
                      : const SizedBox(),
                ],
              ),
              Text(
                DateFormat('EEEE').format(widget.myMeal.date!),
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget expandedChild() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },

      child: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 2, color: primaryColor)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${DateFormat('EEEE').format(widget.myMeal.date!)}  ${dateFormat(widget.myMeal.date!)}",
                          style: const TextStyle(
                              color: primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      foodText("Wake : ", widget.myMeal.wake!, false),
                      foodText("Breakfast : ", widget.myMeal.breakfast!, false),
                      foodText("Brunch : ", widget.myMeal.brunch!, false),
                      foodText("Lunch : ", widget.myMeal.lunch!, false),
                      foodText("Dinner : ", widget.myMeal.dinner!, false),
                      foodText("Supper : ", widget.myMeal.supper!, false),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meal_planner/Components/common_functions.dart';
import 'package:meal_planner/Components/common_widgets.dart';
import 'package:meal_planner/Components/meals.dart';

final _firestore = FirebaseFirestore.instance;

class MealForm extends StatefulWidget {
  const MealForm(
      {super.key,
      required this.save,
      required this.wake,
      required this.breakfast,
      required this.brunch,
      required this.lunch,
      required this.dinner,
      required this.supper,
      required this.myMeals,
      required this.date});
  final bool save;
  final List<Meals> myMeals;
  final String wake, breakfast, brunch, lunch, dinner, supper;
  final DateTime date;
  @override
  CreateForm createState() => CreateForm();
}

class CreateForm extends State<MealForm> {
  List<String> foodList = [];
  List<PopupMenuItem> foodItems = [];
  final TextEditingController _wakeController = TextEditingController();
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _brunchController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();
  final TextEditingController _supperController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  DateTime selectedDate = DateTime.now();
  bool showError = false;
  late var snapShot;
  callBack(String value, TextEditingController controller) {
    setState(() {
      controller.text = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setMealValues();
    setFoodList();
    super.initState();
  }

  Widget dropDown(List<String>? itemList, String myValue) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: DropdownButtonFormField(
            icon: const Icon(Icons.arrow_drop_down_rounded),
            iconSize: 30,
            isDense: false,
            menuMaxHeight: 410,
            borderRadius: BorderRadius.circular(20),
            isExpanded: true,
            decoration: const InputDecoration.collapsed(hintText: ''),
            value: myValue,
            onChanged: (value) {
              setState(() {});
            },
            items: itemList?.map<DropdownMenuItem<dynamic>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(
                    child: Text(
                  value,
                )),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  setFoodList() {
    foodList.clear();
    for (var food in widget.myMeals) {
      if (!foodList.contains(food.wake) && food.wake != "") {
        foodList.add(food.wake!);
        foodItems.add(PopupMenuItem(
            value: food.wake,
            child: Center(
                child: Text(
              food.wake!,
              style: const TextStyle(color: primaryColor),
            ))));
      }
      if (!foodList.contains(food.breakfast) && food.breakfast != "") {
        foodList.add(food.breakfast!);
        foodItems.add(PopupMenuItem(
            value: food.breakfast,
            child: Center(
                child: Text(
              food.breakfast!,
              style: const TextStyle(color: primaryColor),
            ))));
      }
      if (!foodList.contains(food.brunch) && food.brunch != "") {
        foodList.add(food.brunch!);
        foodItems.add(PopupMenuItem(
            value: food.brunch,
            child: Center(
                child: Text(
              food.brunch!,
              style: const TextStyle(color: primaryColor),
            ))));
      }
      if (!foodList.contains(food.lunch) && food.lunch != "") {
        foodList.add(food.lunch!);
        foodItems.add(PopupMenuItem(
            value: food.lunch,
            child: Center(
                child: Text(
              food.lunch!,
              style: const TextStyle(color: primaryColor),
            ))));
      }
      if (!foodList.contains(food.dinner) && food.dinner != "") {
        foodList.add(food.dinner!);
        foodItems.add(PopupMenuItem(
            value: food.dinner,
            child: Center(
                child: Text(
              food.dinner!,
              style: const TextStyle(color: primaryColor),
            ))));
      }
      if (!foodList.contains(food.supper) && food.supper != "") {
        foodList.add(food.supper!);
        foodItems.add(PopupMenuItem(
            value: food.supper,
            child: Center(
                child: Text(
              food.supper!,
              style: const TextStyle(color: primaryColor),
            ))));
      }
    }
    setState(() {});
  }

  setMealValues() {
    setState(() {
      _wakeController.text = widget.wake;
      _breakfastController.text = widget.breakfast;
      _brunchController.text = widget.brunch;
      _lunchController.text = widget.lunch;
      _dinnerController.text = widget.dinner;
      _supperController.text = widget.supper;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: StatefulBuilder(builder: (BuildContext childContext,
          StateSetter mySetState /*You can rename this!*/) {
        return SingleChildScrollView(
          child: Container(
            height: 670,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      widget.save ? 'Save Meal' : "Update Meal",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: primaryColor),
                    ),
                    const SizedBox(height: 10),
                    widget.save
                        ? GestureDetector(
                            onTap: () {
                              showMyDatePicker(context)
                                  .then((value) => mySetState(() {}));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Date:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  height: 40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: primaryColor, width: 3)),
                                  child: Center(
                                      child: Text(
                                    dateFormat(selectedDate),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                            fontSize: 16, color: primaryColor),
                                  )),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),


                    textFieldItem(
                        context, _wakeController, "Wake:", foodItems, callBack),
                    textFieldItem(context, _breakfastController, "Breakfast:",
                        foodItems, callBack),
                    textFieldItem(context, _brunchController, "Brunch:",
                        foodItems, callBack),
                    textFieldItem(context, _lunchController, "Lunch:",
                        foodItems, callBack),
                    textFieldItem(context, _dinnerController, "Dinner:",
                        foodItems, callBack),
                    textFieldItem(context, _supperController, "Supper:",
                        foodItems, callBack),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () async => {
                              if (widget.save == true)
                                {
                                  snapShot = await _firestore
                                      .collection('userMeal')
                                      .doc(_auth.currentUser!.email.toString() +
                                          dateFormat(selectedDate))
                                      .get(),
                                  if (snapShot == null || !snapShot.exists)
                                    {
                                      await _firestore
                                          .collection('userMeal')
                                          .doc(_auth.currentUser!.email
                                                  .toString() +
                                              dateFormat(selectedDate))
                                          .set({
                                        'wake': _wakeController.text,
                                        'breakfast': _breakfastController.text,
                                        'brunch': _brunchController.text,
                                        'lunch': _lunchController.text,
                                        'dinner': _dinnerController.text,
                                        'supper': _supperController.text,
                                        'date': selectedDate,
                                        'email': _auth.currentUser?.email
                                      }).then((value) {
                                        toast(
                                            context, "Meal saved successfully");
                                        Navigator.of(context).pop();
                                      })
                                    }
                                  else
                                    {
                                      Navigator.pop(context),
                                      toast(
                                          context,
                                          "Meals for ${dateFormat(selectedDate)} already existed.")
                                    }
                                }
                              else
                                {
                                  await _firestore
                                      .collection('userMeal')
                                      .doc(_auth.currentUser!.email.toString() +
                                          dateFormat(widget.date))
                                      .update({
                                    'wake': _wakeController.text,
                                    'breakfast': _breakfastController.text,
                                    'brunch': _brunchController.text,
                                    'lunch': _lunchController.text,
                                    'dinner': _dinnerController.text,
                                    'supper': _supperController.text,
                                    'email': _auth.currentUser?.email
                                  }).then((value) {
                                    toast(context, "Meal Update successfully");
                                    Navigator.of(context).pop();
                                  })
                                }
                            },
                        child: Text(
                          widget.save ? 'Save' : 'Update',
                          style: const TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Future showMyDatePicker(BuildContext _context) {
    return showCupertinoModalPopup(
      context: _context,
      builder: (_) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        height: 450,
        child: Column(
          children: [
            Container(
              height: 350,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (value) {
                    setState(() {
                      selectedDate = value;
                    });
                  }),
            ),
            CupertinoButton(
              color: primaryColor,
              child: const Text(
                "Done",
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/Components/common_functions.dart';
import 'package:meal_planner/Components/meal_form.dart';
import 'package:meal_planner/Components/meal_card.dart';
import 'package:meal_planner/Screens/profile_screen.dart';
import '../Components/meals.dart';

final _firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomeScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  List<Meals> weekMeals = [];
  late DateTime minDate, maxDate;
  DateTime selectedDate = DateTime.now();

  setWeekDates(DateTime date) {
    DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
    minDate = getDate(date.subtract(Duration(days: date.weekday - 1)));
    maxDate =
        getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setWeekDates(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weekly Meals',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              push(context, const ProfileScreen());
            },
            icon: const Icon(
              Icons.person,
              size: 32,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: primaryColor,
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => MealForm(
                    save: true,
                    wake: '',
                    breakfast: '',
                    brunch: '',
                    lunch: '',
                    dinner: '',
                    supper: '',
                    date: DateTime.now(),
                    myMeals: weekMeals,
                  ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('userMeal')
              .where(Filter.and(
                  Filter("email",
                      isEqualTo: _auth.currentUser?.email.toString()),
                  Filter.and(Filter("date", isGreaterThanOrEqualTo: minDate),
                      Filter("date", isLessThanOrEqualTo: maxDate))))
              .orderBy("date", descending: false) //as DateTime
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  //backgroundColor: primaryColor,
                  color: primaryColor,
                ),
              );
            }
            final meals = snapshot.data?.docs;
            weekMeals.clear();
            for (var meal in meals!) {
              weekMeals.add(Meals(
                  wake: meal.get("wake"),
                  breakfast: meal.get("breakfast"),
                  lunch: meal.get("lunch"),
                  brunch: meal.get("brunch"),
                  dinner: meal.get("dinner"),
                  supper: meal.get("supper"),
                  date: (meal.get("date") as Timestamp).toDate()));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDate = selectedDate
                                  .subtract(const Duration(days: 7));
                              setWeekDates(selectedDate);
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            size: 30,
                            color: primaryColor,
                          )),
                      GestureDetector(
                          onTap: () {
                            showMyDatePicker(context);
                          },
                          child: Text(
                            dateFormat(selectedDate),
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          )),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDate =
                                selectedDate.add(const Duration(days: 7));
                            setWeekDates(selectedDate);
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 30,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10.0),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: weekMeals.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            confirmDismiss: (DismissDirection direction) async {
                              return showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel',
                                            style:
                                                TextStyle(color: Colors.grey))),
                                    TextButton(
                                        onPressed: () async {
                                          await _firestore
                                              .collection('userMeal')
                                              .doc(_auth.currentUser!.email
                                                      .toString() +
                                                  dateFormat(
                                                      weekMeals[index].date!))
                                              .delete()
                                              .then((value) {
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ],
                                  title: const Text('Delete Confirmation'),
                                  contentPadding: const EdgeInsets.all(20.0),
                                ),
                              );
                            },
                            key: UniqueKey(),
                            child: GestureDetector(
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => MealForm(
                                          save: false,
                                          wake: weekMeals[index].wake!,
                                          breakfast:
                                              weekMeals[index].breakfast!,
                                          brunch: weekMeals[index].brunch!,
                                          lunch: weekMeals[index].lunch!,
                                          dinner: weekMeals[index].dinner!,
                                          supper: weekMeals[index].supper!,
                                          myMeals: weekMeals,
                                          date: weekMeals[index].date!,
                                        ));
                              },
                              child: MealCard(
                                myMeal: weekMeals[index],
                              ),
                            ));
                      }),
                ),
              ],
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
            SizedBox(
              height: 350,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (value) {
                    setState(() {
                      selectedDate = value;
                      setWeekDates(selectedDate);
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

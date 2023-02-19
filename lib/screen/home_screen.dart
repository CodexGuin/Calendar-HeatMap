import 'package:cal_heatmap/widgets/my_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../widgets/habit_tiles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* Data structure for 1 day's list */
  List todayHabitList = [
    ["Morning run", false],
    ["Reading book", false],
    ["Lmaoing", false],
  ];

  /* Function for when checkbox is tapped */
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todayHabitList[index][1] = value;
    });
  }

  /* Create a new habit */
  void createNewHabit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,

      /* Action button to create new habits */
      floatingActionButton: MyFloatingActionButton(),
      body: ListView.builder(
        itemCount: todayHabitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
              habitCompleted: todayHabitList[index][1],
              habitName: todayHabitList[index][0],
              onChange: (value) {
                checkBoxTapped(value, index);
              });
        },
      ),
    );
  }
}

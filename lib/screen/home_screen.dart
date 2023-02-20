import 'package:cal_heatmap/data/habit_database.dart';
import 'package:cal_heatmap/widgets/month_summary.dart';
import 'package:cal_heatmap/widgets/my_fab.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/new_alert_box.dart';
import '../widgets/habit_tiles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* Create new instance of HabitDatabase */
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    /* If no current habit list, it means its their first time on the app */
    /* Then we create 1 default one for them */
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

    /* If there already exists data AKA not their first time */
    else {
      db.loadData();
    }

    /* Finally, update the database */
    db.updateDatabase();

    super.initState();
  }

  /* Function for when checkbox is tapped */
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  /* Controller for new habits */
  final _newHabitController = TextEditingController();

  /* Save new habit */
  void saveNewHabit() {
    /* Add new habit to list */
    setState(() {
      db.todayHabitList.add([_newHabitController.text, false]);
    });
    /* Clears the textfield */
    _newHabitController.clear();
    /* Pops the dialog box */
    Navigator.of(context).pop();
    /* Update database */
    db.updateDatabase();
  }

  /* Cancel new habit */
  void cancelNewHabit() {
    /* Clears the textfield */
    _newHabitController.clear();
    /* Pops the dialog box */
    Navigator.of(context).pop();
  }

  /* Create a new habit */
  void createNewHabit() {
    /* Show alert dialog for user to enter habit details */
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitController,
            onSave: saveNewHabit,
            onCancel: cancelNewHabit,
            hintText: "New habit",
          );
        });
    /* Update database */
    db.updateDatabase();
  }

  /* Habit settings */
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (builder) {
        return MyAlertBox(
          controller: _newHabitController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelNewHabit,
          hintText: db.todayHabitList[index][0],
        );
      },
    );
  }

  /* Save existing habit */
  void saveExistingHabit(int index) {
    setState(() {
      db.todayHabitList[index][0] = _newHabitController.text;
    });
    _newHabitController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  /* Delete habit at index */
  void deleteHabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      /* Action button to create new habits */
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      body: ListView(
        children: [
          /* Monthly summary heat map */
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.get("START_DATE"),
          ),

          /* List of habits */
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todayHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitCompleted: db.todayHabitList[index][1],
                habitName: db.todayHabitList[index][0],
                onChange: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
          ),
        ],
      ),
    );
  }
}

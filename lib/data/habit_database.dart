import 'package:cal_heatmap/dateTime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

/* Reference the box */
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todayHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  /* Create initial default data */
  void createDefaultData() {
    /* Default list */
    todayHabitList = [
      ["Morning run", false],
      ["Reading book", false],
      ["Lmaoing", false],
    ];

    /* Inititial date */
    _myBox.put("START_DATE", todayDateFormatted());
  }

  /* Load data if already exists */
  void loadData() {
    /* If its a new day, get havit list from data */
    if (_myBox.get(todayDateFormatted()) == null) {
      todayHabitList = _myBox.get("CURRENT_HABIT_LIST");
      /* Sets all habits to false since its a new day */
      for (int i = 0; i < todayHabitList.length; i++) {
        todayHabitList[i][1] = false;
      }
    }
    /* If its not a new day, load today's list */
    else {
      todayHabitList = _myBox.get(todayDateFormatted());
    }
  }

  /* Update database */
  void updateDatabase() {
    /* Update today entry */
    _myBox.put(todayDateFormatted(), todayHabitList);

    /* Update universal havit list in case it changed (new habit, edit habit, delete habit) */
    _myBox.put("CURRENT_HABIT_LIST", todayHabitList);

    /* Calculate habit complete percentages for each day */
    calculateHabitPercentages();

    /* Load heatmap */
    loadHeatMap();
  }

  /* Calulating percentage */
  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todayHabitList.length; i++) {
      if (todayHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    /* Represent as string */
    String percent = todayHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todayHabitList.length).toStringAsFixed(1);

    /* Key: "PERCENTAGE_SUMMARY_yyyymmdd" */
    /* Value: string of 1dp number between 0.0 - 1.0 inclusive */
    _myBox.put("PERCENTAGE_SUMMARY_${todayDateFormatted()}", percent);
  }

  /* Loading of heatmap */
  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    /* Count number of days to load */
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    /* Go from start date to today and add each percentage to the dataset */
    /* "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database */
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToString(startDate.add(Duration(days: i)));

      double strengthAsPercentage =
          double.parse(_myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0");

      /* Split the datetime up like below so it doesnt worry about hours/mins/secs etc */

      /* Year */
      int year = startDate.add(Duration(days: i)).year;

      /* Month */
      int month = startDate.add(Duration(days: i)).month;

      /* Days */
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercentage).toInt()
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      // ignore: avoid_print
      print(heatMapDataSet);
    }
  }
}

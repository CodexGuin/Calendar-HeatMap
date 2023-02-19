import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChange;

  const HabitTile({
    super.key,
    required this.habitCompleted,
    required this.habitName,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            /* Checkbox */
            Checkbox(
              value: habitCompleted,
              onChanged: onChange,
            ),

            /* Habit name */
            Text(habitName),
          ],
        ),
      ),
    );
  }
}

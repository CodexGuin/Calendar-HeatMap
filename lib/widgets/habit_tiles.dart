import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChange;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitCompleted,
    required this.habitName,
    required this.onChange,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            /* Settings */
            SlidableAction(
              onPressed: settingsTapped,
              backgroundColor: Colors.grey.shade700,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(15),
            ),
            /* Delete */
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(15),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
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
      ),
    );
  }
}

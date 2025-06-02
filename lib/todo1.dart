 // Update the path accordingly

import 'package:flutter_application_1/todo.dart';

class TaskService {
  List<Task> filterTasks(List<Task> allTasks, String query) {
    final q = query.toLowerCase();
    return allTasks.where((t) {
      return t.title.toLowerCase().contains(q) || t.description.toLowerCase().contains(q);
    }).toList();
  }

  List<Task> paginateTasks(List<Task> filteredTasks, int pageIndex, int pageSize) {
    int start = pageIndex * pageSize;
    return filteredTasks.skip(start).take(pageSize).toList();
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.year == date.year &&
        tomorrow.month == date.month &&
        tomorrow.day == date.day;
  }
}

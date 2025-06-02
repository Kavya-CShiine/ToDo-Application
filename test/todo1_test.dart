// test/task_service_te

import 'package:flutter_application_1/todo.dart';
import 'package:flutter_application_1/todo1.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final taskService = TaskService();

  final tasks = [
    Task(
      id: 1,
      title: 'Buy groceries',
      description: 'Milk and eggs',
      dueDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Task(
      id: 2,
      title: 'Meeting',
      description: 'Project sync-up',
      dueDate: DateTime.now().add(Duration(days: 1)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Task(
      id: 3,
      title: 'Dentist',
      description: 'Teeth checkup',
      dueDate: DateTime.now().add(Duration(days: 3)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  test('Filter tasks by title', () {
    final result = taskService.filterTasks(tasks, 'buy');
    expect(result.length, 1);
    expect(result[0].title, 'Buy groceries');
  });

  test('Pagination returns correct subset', () {
    final result = taskService.paginateTasks(tasks, 0, 2);
    expect(result.length, 2);
    expect(result[0].id, 1);
    expect(result[1].id, 2);
  });

  test('Identify today\'s task', () {
    final today = tasks[0].dueDate;
    expect(taskService.isToday(today), true);
  });

  test('Identify tomorrow\'s task', () {
    final tomorrow = tasks[1].dueDate;
    expect(taskService.isTomorrow(tomorrow), true);
  });

  test('Non-today task returns false', () {
    final notToday = tasks[2].dueDate;
    expect(taskService.isToday(notToday), false);
  });
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class Task {
  int id;
  String title;
  String description;
  DateTime dueDate;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({Key? key, required String sessionId}) : super(key: key);

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp>
    with SingleTickerProviderStateMixin {
  
  final String apiUrl = 'http://localhost:3000';

  
  List<Task> _allTasks = [];

  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _todayPage = 0;
  int _tomorrowPage = 0;
  int _upcomingPage = 0;
  final int _pageSize = 5;

  late TabController _tabController;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 3, vsync: this);
    _fetchTasks();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() {});
  });
    
  }

  
  Future<void> _fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/tasks'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allTasks = data.map((json) {
            print(json);
            return Task.fromJson(json);}).toList();
        });
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
    
      debugPrint('Error fetching tasks: $e');
    }
  }

  
  Future<void> _addTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        
        _fetchTasks();
      } else {
        throw Exception('Failed to add task');
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  
  Future<void> _updateTask(Task task) async {
    try {
      print(jsonEncode(task.toJson()));
      final response = await http.put(
        Uri.parse('http://localhost:3000/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode == 200) {
        _fetchTasks();
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
    }
  }


  Future<void> _deleteTask(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/tasks/$id'),
      );
      if (response.statusCode == 200) {
        _fetchTasks();
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }
  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.year == date.year &&
        tomorrow.month == date.month &&
        tomorrow.day == date.day;
  }

  
  void _showTaskDialog({Task? editTask}) {
    final bool isEditing = (editTask != null);
    final TextEditingController titleController =
        TextEditingController(text: editTask?.title ?? '');
    final TextEditingController descController =
        TextEditingController(text: editTask?.description ?? '');
    DateTime selectedDate = editTask?.dueDate ?? DateTime.now().add(const Duration(hours: 1));
    TimeOfDay selectedTime = editTask != null
        ? TimeOfDay(hour: editTask.dueDate.hour, minute: editTask.dueDate.minute)
        : TimeOfDay.now();

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Task' : 'Add Task'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Title field
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title cannot be empty';
                          }
                          
                          final titleLower = value.trim().toLowerCase();
                          final duplicate = _allTasks.any((t) {
                            if (isEditing && t.id == editTask.id) return false;
                            return t.title.toLowerCase() == titleLower;
                          });
                          if (duplicate) {
                            return 'A task with this title already exists';
                          }
                          return null;
                        },
                      ),
                      
                      Row(
                        children: [
                          Text(
                            'Due Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              DateTime now = DateTime.now();
                              DateTime firstDate = now;
                              DateTime lastDate = now.add(const Duration(days: 365 * 5));
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: firstDate,
                                lastDate: lastDate,
                              );
                              if (pickedDate != null) {
                                setStateDialog(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                            child: const Text('Pick Date'),
                          ),
                        ],
                      ),
                    
                      Row(
                        children: [
                          Text(
                            'Time: ${selectedTime.format(context)}',
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              final TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (pickedTime != null) {
                                setStateDialog(() {
                                  selectedTime = pickedTime;
                                });
                              }
                            },
                            child: const Text('Pick Time'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              child: Text(isEditing ? 'Update' : 'Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                
                  final DateTime combinedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  if (isEditing) {
                  
                    final updatedTask = Task(
                      id: editTask.id,
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      dueDate: combinedDate,
                      createdAt: editTask.createdAt,
                      updatedAt: DateTime.now(),
                    );
                    setState(() {
                    
                      final index = _allTasks.indexWhere((t) => t.id == editTask.id);
                      if (index != -1) {
                        _allTasks[index] = updatedTask;
                      }
                    });
                    _updateTask(updatedTask);
                  } else {
                  
                    final newTask = Task(
                      id: 0, 
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      dueDate: combinedDate,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    setState(() {
                      _allTasks.add(newTask); 
                    });
                    _addTask(newTask);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  
  Widget _buildTaskList(List<Task> tasks, int pageIndex, VoidCallback prevPage, VoidCallback nextPage) {
    
    List<Task> filtered = tasks.where((t) {
      final q = _searchQuery.toLowerCase();
      return t.title.toLowerCase().contains(q) || t.description.toLowerCase().contains(q);
    }).toList();
    filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));

  
    int start = pageIndex * _pageSize;
    int end = start + _pageSize;
    bool hasPrev = pageIndex > 0;
    bool hasNext = end < filtered.length;
    List<Task> pageItems = filtered.skip(start).take(_pageSize).toList();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: pageItems.length,
            itemBuilder: (context, index) {
              final task = pageItems[index];
            
              Duration diff = task.dueDate.difference(DateTime.now());
              String remaining;
              if (diff.isNegative) {
                remaining = 'Past due';
              } else if (diff.inDays >= 1) {
                int days = diff.inDays;
                int hours = diff.inHours % 24;
                remaining = '${days}d ${hours}h left';
              } else if (diff.inHours >= 1) {
                int hours = diff.inHours;
                int mins = diff.inMinutes % 60;
                remaining = '${hours}h ${mins}m left';
              } else {
                int mins = diff.inMinutes;
                remaining = '${mins}m left';
              }
              
              Color bgColor = (index % 2 == 0) ? const Color.fromARGB(255, 175, 234, 205) : Colors.grey;
              return Dismissible(
                key: Key(task.id.toString()),
                background: Container(color: Colors.redAccent),
                onDismissed: (direction) {
                  setState(() {
                    _allTasks.removeWhere((t) => t.id == task.id);
                  });
                  _deleteTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${task.title} deleted')),
                  );
                },
                child: Container(
                  color: bgColor,
                  child: ListTile(
                    title: Text(task.title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Remaining: ${DateFormat('yyyy-MM-dd – kk:mm').format(task.dueDate)} ($remaining)'),
                        Text(
                            'Created on: ${DateFormat('yyyy-MM-dd – kk:mm').format(task.createdAt)}'),
                        if (task.updatedAt.isAfter(task.createdAt))
                          Text(
                              'Updated on: ${DateFormat('yyyy-MM-dd – kk:mm').format(task.updatedAt)}'),
                      ],
                    ),
                    onTap: () {
                      
                      _showTaskDialog(editTask: task);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        
        if (filtered.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: hasPrev ? prevPage : null,
                  child: const Text('<'),
                ),
                Text('Page ${pageIndex + 1} of ${((filtered.length - 1) ~/ _pageSize) + 1}'),
                ElevatedButton(
                  onPressed: hasNext ? nextPage : null,
                  child: const Text('>'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Stay on page
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: ()async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('sessionId');
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage())); // Go to login
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  
    List<Task> todayTasks = _allTasks.where((t) => _isToday(t.dueDate)).toList();
    List<Task> tomorrowTasks = _allTasks.where((t) => _isTomorrow(t.dueDate)).toList();
    List<Task> upcomingTasks = _allTasks.where((t) =>
        !_isToday(t.dueDate) && !_isTomorrow(t.dueDate)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do list'), centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
        backgroundColor: Colors.cyanAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Tomorrow'),
            Tab(text: 'Upcoming'),
          ],
          indicatorColor: Colors.redAccent, 
          labelColor: Colors.redAccent, 
          unselectedLabelColor: Colors.black,
        ),
      ),
      body: Column(
        children: [
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _todayPage = _tomorrowPage = _upcomingPage = 0;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                            _todayPage = _tomorrowPage = _upcomingPage = 0;
                          });
                        },
                      )
                    : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
      
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
            
                _buildTaskList(
                  todayTasks,
                  _todayPage,
                  () { setState(() { _todayPage--; }); },
                  () { setState(() { _todayPage++; }); },
                ),
                
                _buildTaskList(
                  tomorrowTasks,
                  _tomorrowPage,
                  () { setState(() { _tomorrowPage--; }); },
                  () { setState(() { _tomorrowPage++; }); },
                ),
              
                _buildTaskList(
                  upcomingTasks,
                  _upcomingPage,
                  () { setState(() { _upcomingPage--; }); },
                  () { setState(() { _upcomingPage++; }); },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

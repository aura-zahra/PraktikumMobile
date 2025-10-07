import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Tambahkan impor ini
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TaskScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getStringList('tasks') ?? [];
    setState(() {
      _tasks.addAll(tasksData.map((task) => Map<String, dynamic>.from(taskDecode(task))));
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = _tasks.map((task) => taskEncode(task)).toList();
    await prefs.setStringList('tasks', tasksData);
  }

  String taskEncode(Map<String, dynamic> task) => jsonEncode(task);

  Map<String, dynamic> taskDecode(String task) => jsonDecode(task);

  void _addTask(String name, String details, DateTime deadline) {
    setState(() {
      _tasks.add({
        'name': name,
        'details': details,
        'deadline': deadline.toIso8601String(),
        'isDone': false,
      });
    });
    _saveTasks();
  }

  void _editTask(int index, String name, String details, DateTime deadline) {
    setState(() {
      _tasks[index] = {
        'name': name,
        'details': details,
        'deadline': deadline.toIso8601String(),
        'isDone': _tasks[index]['isDone'],
      };
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _showAddOrEditTaskDialog({int? index}) {
    final _nameController = TextEditingController();
    final _detailsController = TextEditingController();
    DateTime? _selectedDate;

    if (index != null) {
      _nameController.text = _tasks[index]['name'];
      _detailsController.text = _tasks[index]['details'];
      _selectedDate = DateTime.parse(_tasks[index]['deadline']);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Tambah Tugas' : 'Edit Tugas'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nama Tugas'),
                ),
                TextField(
                  controller: _detailsController,
                  decoration: InputDecoration(labelText: 'Detail Tugas'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        _selectedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      }
                    }
                  },
                  child: Text(_selectedDate == null
                      ? 'Pilih Deadline'
                      : 'Deadline: ${_selectedDate.toString()}'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _detailsController.text.isNotEmpty &&
                    _selectedDate != null) {
                  if (index == null) {
                    _addTask(
                      _nameController.text,
                      _detailsController.text,
                      _selectedDate!,
                    );
                  } else {
                    _editTask(
                      index,
                      _nameController.text,
                      _detailsController.text,
                      _selectedDate!,
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text(
                'Belum ada tugas. Tambahkan tugas baru!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final deadline = DateTime.parse(task['deadline']);
                final formattedDate = DateFormat('yyyy-MM-dd').format(deadline);
                final formattedTime = DateFormat('HH:mm').format(deadline);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Checkbox(
                      value: task['isDone'],
                      onChanged: (value) {
                        setState(() {
                          _tasks[index]['isDone'] = value!;
                        });
                        _saveTasks();
                      },
                    ),
                    title: Text(
                      task['name'],
                      style: TextStyle(
                        decoration: task['isDone']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      '${task['details']}\nDeadline: $formattedDate\nTime: $formattedTime',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showAddOrEditTaskDialog(index: index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteTask(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditTaskDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
  final prefs = await SharedPreferences.getInstance();
  final schedulesData = prefs.getStringList('schedules') ?? [];

  setState(() {
    _schedules.clear();
    _schedules.addAll(
      schedulesData.map((scheduleStr) {
        final decoded = jsonDecode(scheduleStr) as Map<String, dynamic>;

        // Pastikan 'subjects' dikonversi ke List<Map<String, String>>
        final subjects = (decoded['subjects'] as List)
            .map((item) => Map<String, String>.from(item))
            .toList();

        return {
          'day': decoded['day'],
          'subjects': subjects,
        };
      }).toList(),
    );
  });
}

  Future<void> _saveSchedules() async {
  final prefs = await SharedPreferences.getInstance();
  final schedulesData = _schedules.map((schedule) => jsonEncode(schedule)).toList();
  await prefs.setStringList('schedules', schedulesData);
}

  String scheduleEncode(Map<String, dynamic> schedule) => jsonEncode(schedule);

  Map<String, dynamic> scheduleDecode(String schedule) => jsonDecode(schedule);

  void _addSchedule(String day, List<Map<String, String>> subjects) {
    setState(() {
      _schedules.add({
        'day': day,
        'subjects': subjects,
      });
    });
    _saveSchedules();
  }

  void _editSchedule(int index, String day, List<Map<String, String>> subjects) {
    setState(() {
      _schedules[index] = {
        'day': day,
        'subjects': subjects,
      };
    });
    _saveSchedules();
  }

  void _deleteSchedule(int index) {
    setState(() {
      _schedules.removeAt(index);
    });
    _saveSchedules();
  }

  void _showAddOrEditScheduleDialog({int? index}) {
    final _subjectController = TextEditingController();
    TimeOfDay? _startTime;
    TimeOfDay? _endTime;
    List<Map<String, String>> _subjects = [];
    String? _selectedDay;

    if (index != null) {
      _selectedDay = _schedules[index]['day'];
      _subjects = List<Map<String, String>>.from(_schedules[index]['subjects']);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(index == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedDay,
                      items: _days.map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Hari'),
                    ),
                    TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(labelText: 'Mata Kuliah'),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _startTime = pickedTime;
                              });
                            }
                          },
                          child: Text(_startTime == null
                              ? 'Pilih Jam Mulai'
                              : 'Mulai: ${_startTime!.format(context)}'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _endTime = pickedTime;
                              });
                            }
                          },
                          child: Text(_endTime == null
                              ? 'Pilih Jam Selesai'
                              : 'Selesai: ${_endTime!.format(context)}'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_subjectController.text.isNotEmpty &&
                            _startTime != null &&
                            _endTime != null) {
                          setState(() {
                            _subjects.add({
                              'subject': _subjectController.text,
                              'time':
                                  '${_startTime!.format(context)} - ${_endTime!.format(context)}',
                            });
                            _subjectController.clear();
                            _startTime = null;
                            _endTime = null;
                          });
                        }
                      },
                      child: Text('Tambah Mata Kuliah'),
                    ),
                    SizedBox(height: 10),
                    ..._subjects.map((subject) {
                      return ListTile(
                        title: Text(subject['subject']!),
                        subtitle: Text(subject['time']!),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedDay != null && _subjects.isNotEmpty) {
                      if (index == null) {
                        _addSchedule(_selectedDay!, _subjects);
                      } else {
                        _editSchedule(index, _selectedDay!, _subjects);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];
  String? _selectedDay;

  void _showAddScheduleDialog() {
    final _subjectController = TextEditingController();
    TimeOfDay? _startTime;
    TimeOfDay? _endTime;
    List<Map<String, String>> _subjects = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Tambah Jadwal'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedDay,
                      items: _days.map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Hari'),
                    ),
                    TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(labelText: 'Mata Kuliah'),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0, // Jarak horizontal antar elemen
                      runSpacing: 4.0, // Jarak vertikal antar elemen
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _startTime = pickedTime;
                              });
                            }
                          },
                          child: Text(_startTime == null
                              ? 'Pilih Jam Mulai'
                              : 'Mulai: ${_startTime!.format(context)}'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _endTime = pickedTime;
                              });
                            }
                          },
                          child: Text(_endTime == null
                              ? 'Pilih Jam Selesai'
                              : 'Selesai: ${_endTime!.format(context)}'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_subjectController.text.isNotEmpty &&
                            _startTime != null &&
                            _endTime != null) {
                          setState(() {
                            _subjects.add({
                              'subject': _subjectController.text,
                              'time':
                                  '${_startTime!.format(context)} - ${_endTime!.format(context)}',
                            });
                            _subjectController.clear();
                            _startTime = null;
                            _endTime = null;
                          });
                        }
                      },
                      child: Text('Tambah Mata Kuliah'),
                    ),
                    SizedBox(height: 10),
                    ..._subjects.map((subject) {
                      return ListTile(
                        title: Text(subject['subject']!),
                        subtitle: Text(subject['time']!),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedDay != null && _subjects.isNotEmpty) {
                      _addSchedule(_selectedDay!, _subjects);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _schedules.isEmpty
          ? Center(
              child: Text(
                'Belum ada jadwal. Tambahkan jadwal baru!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ExpansionTile(
                    title: Text(
                      schedule['day'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ...schedule['subjects'].map((subject) {
                        return ListTile(
                          title: Text(subject['subject']!),
                          subtitle: Text(subject['time']!),
                        );
                      }).toList(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showAddOrEditScheduleDialog(index: index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteSchedule(index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = "Aura Zahra";
  String _educationLevel = "Mahasiswa";
  String _major = "Sistem Informasi";
  String _profileImageUrl = "https://via.placeholder.com/150"; // Default URL

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "Aura Zahra";
      _educationLevel = prefs.getString('educationLevel') ?? "Mahasiswa";
      _major = prefs.getString('major') ?? "Sistem Informasi";
      _profileImageUrl = prefs.getString('profileImageUrl') ??
          "https://via.placeholder.com/150"; // Default URL
    });
  }

  Future<void> _savePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void _showEditDialog(String title, String initialValue, Function(String) onSave) {
    final _controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: title),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEducationLevelDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Jenjang Pendidikan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('SMA'),
                onTap: () {
                  setState(() {
                    _educationLevel = 'SMA';
                  });
                  _savePreference('educationLevel', 'SMA');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Mahasiswa'),
                onTap: () {
                  setState(() {
                    _educationLevel = 'Mahasiswa';
                  });
                  _savePreference('educationLevel', 'Mahasiswa');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileImageDialog() {
    _showEditDialog('Link Foto Profil', _profileImageUrl, (value) {
      setState(() {
        _profileImageUrl = value;
      });
      _savePreference('profileImageUrl', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showEditProfileImageDialog,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profileImageUrl),
                child: Icon(Icons.edit, size: 30, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Nama Pengguna'),
              subtitle: Text(_username),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog('Nama Pengguna', _username, (value) {
                    setState(() {
                      _username = value;
                    });
                    _savePreference('username', value);
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Jenjang Pendidikan'),
              subtitle: Text(_educationLevel),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: _showEducationLevelDialog,
              ),
            ),
            ListTile(
              title: Text('Jurusan / Program Studi'),
              subtitle: Text(_major),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog('Jurusan / Program Studi', _major, (value) {
                    setState(() {
                      _major = value;
                    });
                    _savePreference('major', value);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
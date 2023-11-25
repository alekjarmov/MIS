import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '206012'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List <String> courses = [
    'Mobilni i Informaciski Sistemi',
    'Implementacija na Sistemi so Sloboden i Otvoren Kod',
    'Timski Proekt',
    'Programski Paradigmi',
    'Prava na Drushtva',
    'Modeliranje i Simulacija'
  ];

  final TextEditingController _courseController = TextEditingController();

  void _addCourse(String courseName) {
    if (courseName.isNotEmpty) {
      setState(() {
        courses.add(courseName);
        _courseController.clear();
      });
    }
  }

  void _removeCourse(String course) {
    setState(() {
      courses.remove(course);
    });
  }

  List<Widget> _buildCourses() {
    return courses.map((course) => _buildCourse(course)).toList();
  }
  Widget _buildCourse(String course) {
    return ListTile(
      title: Text(course),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _removeCourse(course),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _buildCourses(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Expanded(
                  child: TextField(
                    // Customize the TextField as needed
                    decoration: const InputDecoration(
                      hintText: 'Enter course name',
                    ),
                    controller: _courseController,
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () => _addCourse(_courseController.text),
                  tooltip: 'Add a subject',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

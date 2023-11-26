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
      home: const MyHomePage(title: 'Clothes App'),
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

  List <String> clothes = [
    'Hoodie',
    'Pants',
    'Hat',
    'T-Shirt'
  ];

  final TextEditingController _clothesController = TextEditingController();

  void _addCourse(String courseName) {
    if (courseName.isNotEmpty) {
      setState(() {
        clothes.add(courseName);
        _clothesController.clear();
      });
    }
  }

  void _removeClothing(String course) {
    setState(() {
      clothes.remove(course);
    });
  }
  void _updateClothing(String oldCourseName, String newCourseName) {
    // Find the index of the old course in the list
    int index = clothes.indexOf(oldCourseName);

    // Update the course at the found index
    if (index != -1) {
      setState(() {
        clothes[index] = newCourseName;
      });
    }
  }

  void _editClothing(String course) {
    TextEditingController _controller = TextEditingController();
    _controller.text = course;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Course', style: TextStyle(color: Colors.blue)),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'New Course Name',
              labelStyle: TextStyle(
              color: Colors.blue, // Set the color to blue
            ),),
            style: TextStyle(fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                // Perform the update logic here
                String newCourseName = _controller.text;
                _updateClothing(course, newCourseName);

                Navigator.of(context).pop();
              },
              child: Text('Save' , style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildClothes() {
    return clothes.map((course) => _buildClothing(course)).toList();
  }

  Widget _buildClothing(String course) {
    return ListTile(
      title: Text(course, style: TextStyle(color: Colors.blue)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editClothing(course),
              color: Colors.red,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.green[200]),
                backgroundColor: MaterialStateProperty.all(Colors.green),
              )
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _removeClothing(course),
            color: Colors.red,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.green[200]),
              backgroundColor: MaterialStateProperty.all(Colors.green),

            )
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: TextStyle(color: Colors.blue)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _buildClothes(),
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
                      hintStyle: TextStyle(
                        color: Colors.blue, // Set the color to blue
                      ),
                    ),
                    controller: _clothesController,
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () => _addCourse(_clothesController.text),
                  tooltip: 'Add a subject',
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.red,
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

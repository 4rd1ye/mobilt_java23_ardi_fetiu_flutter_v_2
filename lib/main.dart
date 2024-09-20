import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/second': (context) => const SecondPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _sliderValue = 20;
  bool _radioValue = false;
  int _selectedIndex = 0;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sliderValue = prefs.getDouble('sliderValue') ?? 20;
      _textController.text = prefs.getString('textValue') ?? '';
      _radioValue = prefs.getBool('radioValue') ?? false;
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('sliderValue', _sliderValue);
    prefs.setString('textValue', _textController.text);
    prefs.setBool('radioValue', _radioValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              Navigator.pushNamed(context, '/second');
            }
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_forward),
            label: 'Second Page',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                'https://upload.wikimedia.org/wikipedia/hif/b/bd/Liverpool_FC.png',
                width: 250,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text('Slider Value: ${_sliderValue.toInt()}'),
              Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                onChanged: (newValue) {
                  setState(() {
                    _sliderValue = newValue;
                    _saveData();
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Skriv något',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  _saveData();
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Välj alternativ:'),
                  Radio<bool>(
                    value: true,
                    groupValue: _radioValue,
                    onChanged: (bool? value) {
                      setState(() {
                        _radioValue = value!;
                        _saveData();
                      });
                    },
                  ),
                  const Text('Alternativ 1'),
                  Radio<bool>(
                    value: false,
                    groupValue: _radioValue,
                    onChanged: (bool? value) {
                      setState(() {
                        _radioValue = value!;
                        _saveData();
                      });
                    },
                  ),
                  const Text('Alternativ 2'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Second Page!'),
      ),
    );
  }
}

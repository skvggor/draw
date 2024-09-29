import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruletti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ruletti'),
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
  final List<String> _items = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _addItem(String value) {
    setState(() {
      _items.add(value);
      _textController.clear();
      _focusNode.requestFocus();
    });
  }

  void _clearItems() {
    setState(() {
      _items.clear();
      _textController.clear();
      _focusNode.requestFocus();
    });
  }

  void _removeItem(String item) {
    setState(() {
      _items.remove(item);
      _textController.clear();
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _items.isEmpty
                    ? const Text('No items added yet.')
                    : const Text('Added items:'),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    children: _items.map((item) {
                      return Chip(
                        label: Text(item),
                        onDeleted: () => _removeItem(item),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Add a new item',
                    ),
                    onSubmitted: (value) => _addItem(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(children: [
                    IconButton(
                      tooltip: 'Add',
                      icon: const Icon(Icons.add),
                      onPressed: () => _addItem(_textController.text),
                    ),
                    IconButton(
                      tooltip: 'Clear',
                      icon: const Icon(Icons.not_interested),
                      onPressed: () => _clearItems(),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

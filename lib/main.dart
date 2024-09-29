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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _addItem(String value) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        final normalizedValue = _normalizeValue(value);

        if (normalizedValue.contains(',')) {
          _addMultipleItems(normalizedValue);
        } else {
          _addSingleItem(normalizedValue);
        }

        _clearInput();
      });
    }
  }

  String _normalizeValue(String value) {
    return value.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
  }

  void _addMultipleItems(String value) {
    final items = value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty && !_items.contains(item))
        .toList();

    _items.addAll(items);
    _sortItems();
  }

  void _addSingleItem(String item) {
    if (!_items.contains(item)) {
      _items.add(item);
      _sortItems();
    }
  }

  void _sortItems() {
    _items.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  void _clearItems() {
    setState(() {
      _items.clear();
      _clearInput();
    });
  }

  void _removeItem(String item) {
    setState(() {
      _items.remove(item);
      _clearInput();
    });
  }

  String? _validate(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      _clearInput();

      return 'Please enter an item.';
    }

    if (_items.contains(value.trim())) {
      _clearInput();
      return 'Item already added.';
    }

    return null;
  }

  void _clearInput() {
    _textController.clear();
    _focusNode.requestFocus();
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
            child: Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _textController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Add a new item',
                          ),
                          validator: (value) => _validate(value!),
                          onFieldSubmitted: (value) => _addItem(value),
                        ),
                        if (_formKey.currentState?.hasError ?? false)
                          const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        tooltip: 'Add',
                        icon: const Icon(Icons.add),
                        onPressed: () => _addItem(_textController.text),
                      ),
                      IconButton(
                        tooltip: 'Clear',
                        icon: const Icon(Icons.not_interested),
                        onPressed: () => _clearItems(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on FormState? {
  get hasError => null;
}

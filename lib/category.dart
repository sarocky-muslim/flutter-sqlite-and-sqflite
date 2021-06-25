import 'package:flutter/material.dart';
import 'dbCategory.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  CategoryDB categoryDB = new CategoryDB();
  List<Map<String, dynamic>> _items = [];
  String _initValue = '';
  String _inputValue = '';
  bool _isEditing = false;
  int? _selectId;

  void _displayItems() async {
    List<Map<String, dynamic>> list = await categoryDB.getAll();
    setState(() {
      _items = list;
    });
  }

  void _addItem() async {
    await categoryDB.insert({'name': _inputValue});
    _displayItems();
  }

  void _selectItem(Map<String, dynamic> item) async {
    _isEditing = true;
    _selectId = int.parse(item['_id'].toString());
    setState(() {
      _initValue = item['name'].toString();
    });
  }

  void _updateItem() async {
    await categoryDB.update({'_id': _selectId, 'name': _inputValue});
    _displayItems();
    _isEditing = false;
  }

  void _deleteItem(int id) async {
    await categoryDB.delete(id);
    _displayItems();
  }

  Widget itemView(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Text(
              item['name'].toString(),
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => _selectItem(item),
              icon: Icon(
                Icons.edit,
                color: Colors.blue[700],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => _deleteItem(item['_id']),
              icon: Icon(
                Icons.delete,
                color: Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    categoryDB.database().then((value) => _displayItems());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Category CRUD'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: TextEditingController(text: _initValue),
              decoration: InputDecoration(
                hintText: 'Enter the name here',
              ),
              onChanged: (value) => _inputValue = value,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (value) {
                if (value != '') {
                  if (_isEditing) return _updateItem();
                  return _addItem();
                }
              },
            ),
            ListView(
              shrinkWrap: true,
              children: _items.reversed.map((item) => itemView(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

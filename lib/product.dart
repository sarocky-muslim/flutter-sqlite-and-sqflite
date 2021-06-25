import 'package:flutter/material.dart';
import 'dbCategory.dart';
import 'dbProduct.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  CategoryDB categoryDB = new CategoryDB();
  ProductDB productDB = new ProductDB();
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _categories = [];
  String _initValue = '';
  String _inputValue = '';
  bool _isEditing = false;
  int? _selectId;
  int? _selectedCategory;

  void _displayItems() async {
    List<Map<String, dynamic>> categoryList = await categoryDB.getAll();
    List<Map<String, dynamic>> list = await productDB.getAll();
    setState(() {
      _categories = categoryList;
      _items = list;
    });
  }

  void _addItem() async {
    await productDB
        .insert({'category': _selectedCategory, 'name': _inputValue});
    _displayItems();
  }

  void _selectItem(Map<String, dynamic> item) async {
    _isEditing = true;
    _selectId = int.parse(item['_id'].toString());
    setState(() {
      _selectedCategory = int.parse(item['category']['_id'].toString());
      _initValue = item['name'].toString();
    });
  }

  void _updateItem() async {
    await productDB.update(
        {'category': _selectedCategory, '_id': _selectId, 'name': _inputValue});
    _displayItems();
    _isEditing = false;
  }

  void _deleteItem(int id) async {
    await productDB.delete(id);
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
              '${item['category']['name']} - ${item['name']}',
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
    categoryDB.database();
    productDB.database().then((value) => _displayItems());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Relationship Product CRUD'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            DropdownButtonFormField(
              hint: Text('Select Category'),
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                    value: int.parse(category['_id'].toString()),
                    child: Text(category['name'].toString()));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = int.parse(value.toString());
                });
              },
            ),
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

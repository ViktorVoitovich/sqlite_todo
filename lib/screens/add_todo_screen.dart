import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../models/todo_model.dart';
import '../extensions/string_extension.dart';

class AddtodoScreen extends StatefulWidget {
  final VoidCallback updateTodos;
  final Todo? todo;

  const AddtodoScreen({
    required this.updateTodos,
    this.todo,
    Key? key,
  }) : super(key: key);

  @override
  _AddtodoScreenState createState() => _AddtodoScreenState();
}

class _AddtodoScreenState extends State<AddtodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Todo? _todo;
  late TextEditingController _nameController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _todo = widget.todo;
    } else {
      _todo = Todo(
        name: '',
        date: DateTime.now(),
        priorityLevel: PriorityLevel.medium,
        completed: false,
      );
    }

    _nameController = TextEditingController(text: _todo!.name);
    _dateController =
        TextEditingController(text: DateFormat.MMMMEEEEd().format(_todo!.date));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.todo != null;

  Future<void> _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _todo!.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      _dateController.text = DateFormat.MMMMEEEEd().format(date);
      setState(() {
        _todo = _todo!.copyWith(date: date);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!_isEditing) {
        DatabaseService.instance.insert(_todo!);
      } else {
        DatabaseService.instance.update(_todo!);
      }
      widget.updateTodos();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEditing ? const Text('Update Todo') : const Text('Add Todo'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 40.0,
            horizontal: 20.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Please enter a name' : null,
                  onSaved: (value) => _todo = _todo!.copyWith(name: value),
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: const InputDecoration(labelText: 'Date'),
                  onTap: _handleDatePicker,
                ),
                const SizedBox(height: 32.0),
                DropdownButtonFormField<PriorityLevel>(
                  value: _todo!.priorityLevel,
                  icon: const Icon(Icons.arrow_drop_down_circle),
                  iconSize: 22.0,
                  iconEnabledColor: Theme.of(context).primaryColor,
                  items: PriorityLevel.values
                      .map(
                        (level) => DropdownMenuItem(
                          value: level,
                          child: Text(
                            EnumToString.convertToString(level).capitalize(),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                  style: const TextStyle(fontSize: 16.0),
                  decoration:
                      const InputDecoration(labelText: 'Priority Level'),
                  onChanged: (value) => setState(
                    () => _todo = _todo!.copyWith(priorityLevel: value),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    primary: _isEditing ? Colors.orange : Colors.green,
                    minimumSize: const Size.fromHeight(45.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Save' : 'Add',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: () {
                      DatabaseService.instance.delete(_todo!.id!);
                      widget.updateTodos();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

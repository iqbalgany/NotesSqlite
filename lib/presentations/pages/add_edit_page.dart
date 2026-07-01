import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_sqlite/domain/entities/note_entity.dart';
import 'package:notes_sqlite/presentations/cubits/note_cubit.dart';

class AddEditPage extends StatefulWidget {
  const AddEditPage({super.key});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  List<Color> colors = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.amber,
    Colors.purple,
    Colors.deepOrange,
    Colors.grey,
  ];

  DateTime? _rawSelectedDate;

  int _selectedColorIndex = 0;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();

  Future<void> _selecDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _rawSelectedDate = pickedDate;
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Add a title',
                  ),
                ),
                SizedBox(height: 20),

                TextFormField(
                  controller: _contentController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a content';
                    }
                    return null;
                  },
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Add a content',
                  ),
                ),
                SizedBox(height: 20),

                TextFormField(
                  readOnly: true,
                  controller: _dateController,
                  onTap: () {
                    _selecDate(context);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Add a date',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: colors.asMap().entries.map((entry) {
                    int index = entry.key;
                    Color color = entry.value;

                    bool isSelected = index == _selectedColorIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,

                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(width: 2, color: Colors.black)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final content = _contentController.text.trim();
                      final title = _titleController.text.trim();
                      final selectedColor = colors[_selectedColorIndex];
                      if (content.isNotEmpty &&
                          title.isNotEmpty &&
                          _rawSelectedDate != null) {
                        context.read<NoteCubit>().insertNote(
                          NoteEntity(
                            title: title,
                            content: content,
                            color: selectedColor.toARGB32().toString(),
                            createdAt: _rawSelectedDate,
                          ),
                        );
                        // if (_isEditMode) {
                        //   context.read<TransactionCubit>().updateTransaction(
                        //     widget.transaction!.copyWith(
                        //       id: widget.transaction!.id,
                        //       amount: int.parse(_amount.text.trim()),
                        //       category: _selectedCategory,
                        //       transactionDate: _rawSelectedDate,
                        //     ),
                        //   );
                        // } else {
                        //   // context.read<TransactionCubit>().addTransaction(
                        //   //   category: _selectedCategory!,
                        //   //   amount: int.parse(_amount.text.trim()),
                        //   //   transactionDate: _rawSelectedDate!,
                        //   // );
                        // }

                        _titleController.clear();
                        _contentController.clear();
                        _dateController.clear();

                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('All fields must be filled out!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 10,
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Save',
                    // _isEditMode ? 'Update' : 'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

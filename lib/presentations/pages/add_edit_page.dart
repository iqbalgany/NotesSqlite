import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_sqlite/domain/entities/note_entity.dart';
import 'package:notes_sqlite/presentations/cubits/note_cubit.dart';

import '../widgets/custom_text_form_field.dart';

class AddEditPage extends StatefulWidget {
  final NoteEntity? note;
  const AddEditPage({super.key, this.note});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();

  List<Color> colors = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.amber,
    Colors.purple,
    Colors.deepOrange,
    Colors.grey,
  ];

  bool get _isEditMode => widget.note != null;

  DateTime? _rawSelectedDate;
  int _selectedColorIndex = 0;

  Future<void> _selecDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _rawSelectedDate ?? DateTime.now(),
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
  void initState() {
    super.initState();

    if (_isEditMode) {
      final note = widget.note!;
      _titleController.text = note.title;
      _contentController.text = note.content;

      _rawSelectedDate = note.createdAt;
      if (_rawSelectedDate != null) {
        _dateController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_rawSelectedDate!);
      }

      _selectedColorIndex = colors.indexWhere(
        (color) => color.toARGB32() == int.parse(note.color),
      );
      if (_selectedColorIndex == -1) _selectedColorIndex = 0;
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
      appBar: AppBar(title: Text(_isEditMode ? 'Edit Note' : 'Add Note')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _titleController,
                  text: 'title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                CustomTextFormField(
                  controller: _contentController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a content';
                    }
                    return null;
                  },
                  text: 'content',
                ),
                SizedBox(height: 20),

                CustomTextFormField(
                  text: 'date',
                  readOnly: true,
                  controller: _dateController,
                  onTap: () {
                    _selecDate(context);
                  },
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
                        if (_isEditMode) {
                          context.read<NoteCubit>().updateNote(
                            NoteEntity(
                              id: widget.note!.id,
                              title: title,
                              content: content,
                              color: selectedColor.toARGB32().toString(),
                              createdAt: _rawSelectedDate,
                            ),
                          );
                        } else {
                          context.read<NoteCubit>().insertNote(
                            NoteEntity(
                              title: title,
                              content: content,
                              color: selectedColor.toARGB32().toString(),
                              createdAt: _rawSelectedDate,
                            ),
                          );
                        }

                        _titleController.clear();
                        _contentController.clear();
                        _dateController.clear();

                        Navigator.pop(context);

                        context.read<NoteCubit>().getNotes();
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
                    backgroundColor: colors[_selectedColorIndex],
                    elevation: 10,
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _isEditMode ? 'Update' : 'Save',
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

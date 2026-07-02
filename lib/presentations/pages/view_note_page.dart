import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_sqlite/domain/entities/note_entity.dart';
import 'package:notes_sqlite/presentations/pages/add_edit_page.dart';

import '../cubits/note_cubit.dart';

class ViewNotePage extends StatefulWidget {
  final NoteEntity? note;
  const ViewNotePage({super.key, this.note});

  @override
  State<ViewNotePage> createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {
  @override
  void initState() {
    context.read<NoteCubit>().getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        NoteEntity currentNote = widget.note!;

        if (state is NoteSuccess) {
          currentNote = state.notes!.firstWhere(
            (note) => note.id == widget.note!.id,
            orElse: () => widget.note!,
          );
        }

        return Scaffold(
          backgroundColor: Color(int.parse(currentNote.color)),
          appBar: AppBar(
            backgroundColor: Color(int.parse(currentNote.color)),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditPage(note: currentNote),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  context.read<NoteCubit>().deleteNote(currentNote.id!);

                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),

          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentNote.title,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat(
                        'dd / MM / yyyy',
                      ).format(currentNote.createdAt!),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    color: Colors.white,
                  ),
                  child: Text(
                    currentNote.content,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

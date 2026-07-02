import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_sqlite/presentations/cubits/note_cubit.dart';
import 'package:notes_sqlite/presentations/pages/add_edit_page.dart';
import 'package:notes_sqlite/presentations/pages/view_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<NoteCubit>().getNotes();
    super.initState();
  }

  Future<void> _refreshNotes() async {
    await context.read<NoteCubit>().getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (state is NoteSuccess) {
            if (state.notes!.isEmpty) {
              return Center(child: Text('Notes is Empty'));
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  await _refreshNotes();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: state.notes!.length,
                  itemBuilder: (context, index) {
                    final note = state.notes![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewNotePage(note: note),
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(int.parse(note.color)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    DateFormat(
                                      'dd / MM / yyyy',
                                    ).format(note.createdAt!),
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                note.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
          return SizedBox.shrink();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditPage()),
          );

          _refreshNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

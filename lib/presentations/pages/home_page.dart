import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_sqlite/presentations/cubits/note_cubit.dart';
import 'package:notes_sqlite/presentations/pages/add_edit_page.dart';

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
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: state.notes!.length,
                itemBuilder: (context, index) {
                  final note = state.notes![index];
                  Card(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(child: Text(note.title)),
                    ),
                  );
                  return null;
                  // return null;
                },
              );
            }
          }
          return SizedBox.shrink();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

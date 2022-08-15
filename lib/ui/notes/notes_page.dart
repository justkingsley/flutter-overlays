/*
 * Copyright (c) 2022 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for
 * pedagogical or instructional purposes related to programming, coding,
 * application development, or information technology.  Permission for such
 * use, copying, modification, merger, publication, distribution, sublicensing,
 * creation of derivative works, or sale is expressly withheld.
 *
 * This project and source code may use libraries or frameworks that are
 * released under various Open-Source licenses. Use of those libraries and
 * frameworks are governed by their own individual licenses.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:flutter/material.dart';

import '../../data/models/note_model.dart';
import '../../data/repository/notes_repository.dart';
import '../_shared/widgets/progress_widget.dart';
import 'widgets/note_body_widget.dart';
import 'widgets/save_note_icon_widget.dart';
import 'widgets/sort_notes_icon_widget.dart';

class NotesPage extends StatefulWidget {
  static const String route = 'notes';

  final NotesRepository notesRepository;

  const NotesPage({Key? key, required this.notesRepository}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<NoteModel> notes;
  bool isLoading = true;
  NotesRepository get notesRepository => widget.notesRepository;

  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(),
        body: isLoading
            ? const ProgressWidget()
            : NoteBodyWidget(
                notes: notes,
                onDelete: deleteNote,
                onEdit: editNote,
              ),
      );

  AppBar buildAppBar() => AppBar(
        title: const Text('Simply Noted!'),
        actions: [
          SaveNoteIconWidget(onSaveNotePressed: saveNewNote),
          SortNotesIconWidget(
            sortNotesByNewestFirst: sortByNewestFirst,
            sortNotesByOldestFirst: sortByOldestFirst,
          ),
        ],
      );

  Future<void> fetchNotes() async {
    try {
      await notesRepository.initialize();
      final fetchedNotes = await notesRepository.fetchNotes();
      if (mounted) {
        setState(() {
          notes = fetchedNotes;
          isLoading = false;
        });
      }
    } on Exception catch (_) {
      showErrorSnackBar('Error while fetching the notes!');
    }
  }

  Future<void> saveNewNote(NoteModel note) async {
    try {
      final isAdded = await notesRepository.saveNewNote(note);
      if (isAdded && mounted) {
        Navigator.of(context).pop();
        setState(() => notes.insert(0, note));
      }
    } on Exception catch (_) {
      showErrorSnackBar('Error while adding the note!');
    }
  }

  Future<void> editNote(NoteModel editedNote) async {
    try {
      final isEdited = await notesRepository.editNote(editedNote);
      if (isEdited && mounted) {
        notes.removeWhere((it) => it == editedNote);
        setState(() => notes.insert(0, editedNote));
      }
    } on Exception catch (_) {
      showErrorSnackBar('Error while editing the note!');
    }
  }

  Future<void> deleteNote(NoteModel deletedNote) async {
    try {
      final isDeleted = await notesRepository.deleteNote(deletedNote);
      if (isDeleted && mounted) {
        setState(() {
          notes.removeWhere((it) => it == deletedNote);
        });
      }
    } on Exception catch (_) {
      showErrorSnackBar('Error while deleting the note!');
    }
  }

  void reorderNotes(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = notes.removeAt(oldIndex);
    setState(() {
      notes.insert(newIndex, item);
    });
  }

  void sortByOldestFirst() => setState(() {
        notes.sort(
          (prev, next) => prev.dateCreated.compareTo(next.dateCreated),
        );
      });

  void sortByNewestFirst() => setState(() {
        notes.sort(
          (prev, next) => next.dateCreated.compareTo(prev.dateCreated),
        );
      });

  ScaffoldFeatureController showErrorSnackBar(String errorString) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorString),
        ),
      );
}

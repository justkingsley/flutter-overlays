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

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_model.dart';
import 'initial_notes.dart';

const String _kNotesKey = 'notes';

class NotesRepository {
  const NotesRepository();

  Future<void> initialize() async {
    if (await _doesStoreExist()) return;
    await _saveNoteList(getInitialNotes());
  }

  Future<bool> saveNewNote(NoteModel note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await fetchNotes(preferences: prefs);
    final index = notes.indexWhere((e) => e == note);
    if (index > -1) {
      throw Exception('The note already exists');
    }
    notes.add(note);
    return prefs.setStringList(_kNotesKey, notes.toJsonList);
  }

  Future<bool> editNote(NoteModel note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await fetchNotes(preferences: prefs);
    final index = notes.indexWhere((e) => e == note);
    if (index > -1) {
      notes.removeAt(index);
    }
    notes.add(note);
    return prefs.setStringList(_kNotesKey, notes.toJsonList);
  }

  Future<bool> deleteNote(NoteModel note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await fetchNotes(preferences: prefs);
    if (notes.isEmpty) return false;
    notes.remove(note);
    return prefs.setStringList(_kNotesKey, notes.toJsonList);
  }

  Future<List<NoteModel>> fetchNotes({SharedPreferences? preferences}) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    final notes = prefs.getStringList(_kNotesKey) ?? [];
    return notes.toNoteList;
  }

  Future<bool> _doesStoreExist() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(_kNotesKey);
    return notes != null;
  }

  Future<bool> _saveNoteList(List<NoteModel> noteList) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await fetchNotes(preferences: prefs);
    notes.addAll(noteList);
    return prefs.setStringList(_kNotesKey, notes.toJsonList);
  }
}

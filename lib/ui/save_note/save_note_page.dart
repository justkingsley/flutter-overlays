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
import '../_shared/mixin/overlay_mixin.dart';
import 'widgets/save_note_confirmation_widget.dart';
import 'widgets/save_note_form_widget.dart';

const _kAnimationDuration = Duration(milliseconds: 100);
const _kPadding = EdgeInsets.symmetric(vertical: 70, horizontal: 24);

final formKey = GlobalKey<FormState>();

class SaveNotePage extends StatefulWidget {
  static const String route = 'save_note';

  final NoteCallback onNoteSaved;
  final NoteModel? noteToEdit;

  const SaveNotePage({
    Key? key,
    required this.onNoteSaved,
    this.noteToEdit,
  }) : super(key: key);


  @override
  _SaveNotePageState createState() => _SaveNotePageState();

}
///
class _SaveNotePageState extends State<SaveNotePage> with OverlayStateMixin{
  late NoteModel note = widget.noteToEdit ?? NoteModel();

  bool get hasChanges {
    final isHeaderChanged = widget.noteToEdit?.header != note.header;
    final isTextChanged = widget.noteToEdit?.text != note.header;
    return isHeaderChanged || isTextChanged;
  }

  bool get isEditMode => widget.noteToEdit != null;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets + _kPadding;

    return AnimatedPadding(
      padding: padding,
      curve: Curves.ease,
      duration: _kAnimationDuration,
      child: SaveNoteFormWidget(
        formKey: formKey,
        onSavePressed: saveNote,
        initialHeader: note.header,
        initialText: note.text,
        onHeaderUpdated: (value) => note = note.copyWith(header: value),
        onTextUpdated: (value) => note = note.copyWith(text: value),
      ),
    );
  }

  void saveNote() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// TODO 6: Check page has edits and show confirmation overlay before
      /// saving the edits
      if(isEditMode && hasChanges){
        toggleOverlay(
          SaveNoteConfirmationWidget(
              onConfirm: () => widget.onNoteSaved(note),
              onCancel: removeOverlay),
        );
      }else{
        widget.onNoteSaved(note);
    }
    }
  }
}

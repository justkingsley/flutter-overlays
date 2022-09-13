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

import '../../../data/models/note_model.dart';
import '../../_shared/mixin/overlay_mixin.dart';
import '../../_shared/utils/app_colors.dart';
import '../../_shared/utils/datetime_utils.dart';
import '../../save_note/save_note_page.dart';
import 'delete_note_icon_widget.dart';

class NoteItemWidget extends StatefulWidget {
  final NoteModel note;
  final NoteCallback onDelete;
  final NoteCallback onEdit;

  const NoteItemWidget({
    Key? key,
    required this.note,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  _NoteItemWidgetState createState() => _NoteItemWidgetState();
}

class _NoteItemWidgetState extends State<NoteItemWidget>
    with OverlayStateMixin {
  NoteModel get note => widget.note;

  /// TODO 5: Use [WillPopScope] and [isOverlayShown] to prevent popping

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        if (isOverlayShown) {
          removeOverlay();
          return false;
        }
        return true;
      },
      child: buildListTile());

  Widget buildListTile() {
    final textTheme = Theme.of(context).textTheme;
    final noteHeader = note.header != null && note.header!.isNotEmpty
        ? note.header!
        : 'Untitled Note';
    final subtitleText = textTheme.bodyText2!.copyWith(
      color: AppColors.black,
      height: 2,
    );

    return ListTile(
      tileColor: AppColors.secondaryColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      title: Text(
        noteHeader,
        style: textTheme.subtitle1!,
      ),
      subtitle: Text(
        DateTimeUtils.formattedDate(note.dateCreated),
        style: subtitleText,
      ),
      leading: const Icon(Icons.menu),
      trailing: DeleteNoteIconWidget(
        onDelete: () => widget.onDelete(note),
      ),
      onTap: onNoteTap,
    );
  }

  void onNoteTap() {
    toggleOverlay(SaveNotePage(
        noteToEdit: note,
        onNoteSaved: (editedNote) {
          widget.onEdit(editedNote);
          removeOverlay();
        }));
  }
}

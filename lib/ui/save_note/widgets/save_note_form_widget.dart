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

import '../../_shared/utils/app_colors.dart';

class SaveNoteFormWidget extends StatelessWidget {
  const SaveNoteFormWidget({
    Key? key,
    required this.formKey,
    required this.onSavePressed,
    required this.initialHeader,
    required this.initialText,
    required this.onHeaderUpdated,
    required this.onTextUpdated,
  }) : super(key: key);

  final GlobalKey formKey;
  final VoidCallback onSavePressed;
  final String? initialHeader;
  final String initialText;
  final FormFieldSetter<String>? onHeaderUpdated;
  final FormFieldSetter<String>? onTextUpdated;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        editHeaderField(),
        Expanded(child: editBodyField()),
        const SizedBox(height: 25),
        buildSaveButton(textTheme),
      ],
    );

    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: column,
        ),
      ),
    );
  }

  ElevatedButton buildSaveButton(TextTheme textTheme) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.primary),
        ),
        onPressed: onSavePressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Save',
            style: textTheme.headline6!.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      );

  TextFormField editHeaderField() => TextFormField(
        decoration: const InputDecoration(labelText: 'Title'),
        onSaved: onHeaderUpdated,
        initialValue: initialHeader,
      );

  TextFormField editBodyField() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Note',
          alignLabelWithHint: true,
        ),
        initialValue: initialText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        keyboardType: TextInputType.multiline,
        expands: true,
        autofocus: true,
        maxLines: null,
        onSaved: onTextUpdated,
      );
}

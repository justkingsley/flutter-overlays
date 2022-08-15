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

import 'dart:convert';

import 'package:flutter/material.dart';

typedef NoteCallback = void Function(NoteModel);

@immutable
class NoteModel {
  NoteModel({
    this.text = '',
    this.header,
    DateTime? dateCreated,
  }) : dateCreated = dateCreated ?? DateTime.now();

  final String text;
  final String? header;
  final DateTime dateCreated;

  Key get key => ValueKey(dateCreated.toIso8601String());

  NoteModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        header = json['header'],
        dateCreated = DateTime.parse(json['dateCreated']);

  Map<String, dynamic> toJson() => {
        'text': text,
        'dateCreated': dateCreated.toIso8601String(),
        'header': header,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteModel &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;

  NoteModel copyWith({
    String? text,
    String? header,
  }) {
    return NoteModel(
      text: text ?? this.text,
      header: header ?? this.header,
      dateCreated: dateCreated,
    );
  }
}

extension NoteListExtension on List<NoteModel> {
  List<String> get toJsonList {
    if (isEmpty) return [];
    return map((e) => e.toJson()).map(jsonEncode).toList();
  }
}

extension StringListExtension on List<String> {
  List<NoteModel> get toNoteList {
    if (isEmpty) return [];
    return map(jsonDecode).map((e) => NoteModel.fromJson(e)).toList();
  }
}

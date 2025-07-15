import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:quiver/core.dart' as quiver;

import 'ids.dart';

class FAQ implements Comparable {
  const FAQ({
    required this.id,
    required this.questionDE,
    required this.questionEN,
    required this.questionAnswerDE,
    required this.questionAnswerEN
  });

  factory FAQ.fromJson(Map<String, dynamic> json) => FAQ(
      id: json['id'],
      questionDE: json['question_de'],
      questionEN: json['question_en'],
      questionAnswerDE: json['question_answer_de'],
      questionAnswerEN: json['question_answer_en']
  );

  final String id;
  final String questionDE;
  final String questionEN;
  final String questionAnswerDE;
  final String questionAnswerEN;

  @override
  int compareTo(other) {
    // TODO: implement compareTo
    throw UnimplementedError();
  }

  @override
  int get hashCode => quiver.hashObjects([
    id.hashCode,
    questionDE.hashCode,
    questionEN.hashCode,
    questionAnswerDE.hashCode,
    questionAnswerEN.hashCode
  ]);
}

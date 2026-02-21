import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'Daily', 'Weekly', 'Zen'
  final String imagePath;
  final IconData icon;
  bool isCompleted;
  bool isBonus;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imagePath,
    required this.icon,
    this.isCompleted = false,
    this.isBonus = false,
  });
}

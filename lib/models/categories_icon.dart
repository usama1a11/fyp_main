import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CategoriesIcons{
  final String title;
  final IconData icon;
  CategoriesIcons({
    required this.icon,
    required this.title,
  });
}
List AllCategories=[
  CategoriesIcons(icon: Icons.search, title: "All"),
  CategoriesIcons(icon: Icons.event_seat_outlined, title: "Chair"),
  CategoriesIcons(icon: Icons.table_restaurant_outlined, title: "Table"),
  CategoriesIcons(icon: Icons.chair_outlined, title: "Sofa"),
  CategoriesIcons(icon: Icons.bed_outlined, title: "Bed"),
];
/*
List demoCategories=[
  CategoriesIcons(icon: Icons.search, title: "All"),
  CategoriesIcons(icon: Icons.event_seat_outlined, title: "Chair"),
  CategoriesIcons(icon: Icons.table_restaurant_outlined, title: "Table"),
  CategoriesIcons(icon: Icons.chair_outlined, title: "Sofa"),
  CategoriesIcons(icon: Icons.bed_outlined, title: "Bed"),
];
List ChairCategories=[
  CategoriesIcons(icon: Icons.search, title: "All"),
  CategoriesIcons(icon: Icons.event_seat_outlined, title: "Chair"),
  CategoriesIcons(icon: Icons.table_restaurant_outlined, title: "Table"),
  CategoriesIcons(icon: Icons.chair_outlined, title: "Sofa"),
  CategoriesIcons(icon: Icons.bed_outlined, title: "Bed"),
];
List TableCategories=[
  CategoriesIcons(icon: Icons.search, title: "All"),
  CategoriesIcons(icon: Icons.event_seat_outlined, title: "Chair"),
  CategoriesIcons(icon: Icons.table_restaurant_outlined, title: "Table"),
  CategoriesIcons(icon: Icons.chair_outlined, title: "Sofa"),
  CategoriesIcons(icon: Icons.bed_outlined, title: "Bed"),
];
List SofaCategories=[
  CategoriesIcons(icon: Icons.search, title: "All"),
  CategoriesIcons(icon: Icons.event_seat_outlined, title: "Chair"),
  CategoriesIcons(icon: Icons.table_restaurant_outlined, title: "Table"),
  CategoriesIcons(icon: Icons.chair_outlined, title: "Sofa"),
  CategoriesIcons(icon: Icons.bed_outlined, title: "Bed"),
];
List BedCategories=[
  CategoriesIcons(icon: Icons.search, title: "All"),
  CategoriesIcons(icon: Icons.event_seat_outlined, title: "Chair"),
  CategoriesIcons(icon: Icons.table_restaurant_outlined, title: "Table"),
  CategoriesIcons(icon: Icons.chair_outlined, title: "Sofa"),
  CategoriesIcons(icon: Icons.bed_outlined, title: "Bed"),
];*/

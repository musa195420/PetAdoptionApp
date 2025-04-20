class SelectionBox {
  int id;
  String image;
  String? description;
  String name;
  bool selected;

  SelectionBox({
    required this.image,
    this.description = "",
    required this.name,
    required this.id,
    this.selected = false,
});
}

class COINUNIT {
  static const tblContact = 'contacts';
  static const colId = 'id';
  static const colValue = 'value';

  COINUNIT.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    value = map[colValue];
  }

  int? id;
  String? value;

  COINUNIT({
    this.id,
    this.value,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colValue: value,

    };
    if (id != null) map[colId] = id;
    return map;
  }
}

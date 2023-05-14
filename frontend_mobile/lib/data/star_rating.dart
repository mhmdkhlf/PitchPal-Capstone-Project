class StarRating {
  String? uuid;
  num value;

  StarRating({
    required this.uuid,
    required this.value,
  });

  factory StarRating.fromJson(Map<String, dynamic> json) {
    return StarRating(
      uuid: json['_id'],
      value: json['value'],
    );
  }

  StarRating.fromInput({
    required this.value,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'value': value,
    };
  }

  @override
  String toString() {
    return 'uuid = $uuid; value : $value';
  }
}

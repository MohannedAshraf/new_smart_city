class ImpressionsCount {
  int? like, love, care, laugh, sad, hate, total;

  ImpressionsCount({this.like, this.love, this.care, this.laugh, this.sad, this.hate, this.total});

  factory ImpressionsCount.fromJson(Map<String, dynamic> json) {
    return ImpressionsCount(
      like: json['like'],
      love: json['love'],
      care: json['care'],
      laugh: json['laugh'],
      sad: json['sad'],
      hate: json['hate'],
      total: json['total'],
    );
  }
}

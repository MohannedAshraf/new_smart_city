class ImpressionsCount {
  int? like, love, care, laugh, sad, hate, total;

  ImpressionsCount({
    this.like,
    this.love,
    this.care,
    this.laugh,
    this.sad,
    this.hate,
    this.total,
  });

  factory ImpressionsCount.fromJson(Map<String, dynamic> json) {
    int like = json['like'] ?? 0;
    int love = json['love'] ?? 0;
    int care = json['care'] ?? 0;
    int laugh = json['laugh'] ?? 0;
    int sad = json['sad'] ?? 0;
    int hate = json['hate'] ?? 0;

    int total = like + love + care + laugh + sad + hate;

    return ImpressionsCount(
      like: like,
      love: love,
      care: care,
      laugh: laugh,
      sad: sad,
      hate: hate,
      total: total,
    );
  }
}

class InterpretationModel {
  final String? chartId;
  final String? chartType;
  final String? system;
  final String? rawInterpretation;
  final int? wordLimit;
  final bool? saved;

  InterpretationModel({
    this.chartId,
    this.chartType,
    this.system,
    this.rawInterpretation,
    this.wordLimit,
    this.saved,
  });

  factory InterpretationModel.fromJson(Map<String, dynamic> json) {
    return InterpretationModel(
      chartId: json['chart_id'],
      chartType: json['chart_type'],
      system: json['system'],
      rawInterpretation: json['interpretation'],
      wordLimit: json['word_limit_applied'],
      saved: json['saved'],
    );
  }

  // Helper to split the interpretation into clean sections if needed
  Map<String, String> get formattedSections {
    if (rawInterpretation == null) return {};
    Map<String, String> sections = {};
    final parts = rawInterpretation!.split('\n\n');
    for (var part in parts) {
      if (part.contains('**')) {
        final title = part.split('**')[1];
        final content = part.split('**').last.trim();
        sections[title] = content;
      }
    }
    return sections;
  }
}
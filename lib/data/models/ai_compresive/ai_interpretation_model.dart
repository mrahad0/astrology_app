// lib/data/models/ai_interpretation_model.dart

class AIInterpretationModel {
  final String chartId;
  final String chartType;
  final String system;
  final String interpretation;
  final int wordLimit;
  final bool usageCounted;
  final bool saved;

  AIInterpretationModel({
    required this.chartId,
    required this.chartType,
    required this.system,
    required this.interpretation,
    required this.wordLimit,
    required this.usageCounted,
    required this.saved,
  });

  factory AIInterpretationModel.fromJson(Map<String, dynamic> json) {
    return AIInterpretationModel(
      chartId: json['chart_id'] ?? '',
      chartType: json['chart_type'] ?? '',
      system: json['system'] ?? '',
      interpretation: json['interpretation'] ?? '',
      wordLimit: json['word_limit_applied'] ?? 0,
      usageCounted: json['usage_counted'] ?? false,
      saved: json['saved'] ?? false,
    );
  }

  int get wordCount {
    if (interpretation.isEmpty) return 0;
    return interpretation.split(RegExp(r'\s+')).length;
  }

  // Extract sections from interpretation (markdown based)
  List<InterpretationSection> get sections {
    List<InterpretationSection> sectionList = [];

    // Split by markdown headers (##)
    final RegExp headerPattern = RegExp(r'##\s+(.+?)(?=\n|$)');
    final matches = headerPattern.allMatches(interpretation);

    int sectionNumber = 1;
    for (var match in matches) {
      final title = match.group(1) ?? '';
      final startIndex = match.end;

      // Find next header or end of text
      final nextMatch = headerPattern.firstMatch(
          interpretation.substring(startIndex)
      );

      final endIndex = nextMatch != null
          ? startIndex + nextMatch.start
          : interpretation.length;

      final content = interpretation
          .substring(startIndex, endIndex)
          .trim();

      if (title.isNotEmpty && content.isNotEmpty) {
        sectionList.add(InterpretationSection(
          number: sectionNumber++,
          title: title,
          content: content,
          wordCount: content.split(RegExp(r'\s+')).length,
        ));
      }
    }

    return sectionList;
  }
}

class InterpretationSection {
  final int number;
  final String title;
  final String content;
  final int wordCount;

  InterpretationSection({
    required this.number,
    required this.title,
    required this.content,
    required this.wordCount,
  });
}

class AIInterpretationResponse {
  final List<AIInterpretationModel> results;

  AIInterpretationResponse({required this.results});

  factory AIInterpretationResponse.fromJson(Map<String, dynamic> json) {
    List<AIInterpretationModel> resultsList = [];

    if (json['results'] != null && json['results'] is List) {
      resultsList = (json['results'] as List)
          .map((item) => AIInterpretationModel.fromJson(item))
          .toList();
    }

    return AIInterpretationResponse(results: resultsList);
  }
}
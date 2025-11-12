class AnalysisReport {
  const AnalysisReport({
    required this.isSafe,
    required this.riskScore,
    required this.verdict,
    required this.indicators,
    required this.recommendations,
  });

  final bool isSafe;
  final int riskScore;
  final String verdict;
  final List<String> indicators;
  final List<String> recommendations;

  Map<String, dynamic> toJson() => {
        'isSafe': isSafe,
        'riskScore': riskScore,
        'verdict': verdict,
        'indicators': indicators,
        'recommendations': recommendations,
      };
}

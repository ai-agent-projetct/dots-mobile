class Poll {
  final String question;
  final List<String> options;
  final List<int> votes;
  final bool allowMultipleAnswers;

  Poll({
    required this.question,
    required this.options,
    required this.allowMultipleAnswers,
  }) : votes = List<int>.filled(options.length, 0);
}

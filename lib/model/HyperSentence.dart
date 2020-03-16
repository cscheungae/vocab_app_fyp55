class HyperSentence {
  String text;
  String link;

  HyperSentence({String text, String link}) {
    this.text = text;
    this.link = link;
  }

  static List<HyperSentence> fromJson({List<dynamic> sentencesArray}) {
    return sentencesArray.map((sentenceEntry) =>
      new HyperSentence(text: sentenceEntry['text'], link: sentenceEntry['link'])
    ).toList();
  }
}
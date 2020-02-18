class FlashcardBundle
{
  // Fields
  int fid;
  DateTime dateLastReviewed;
  int daysBetweenReview;
  double overdue;
  double difficulty;

  FlashcardBundle({this.fid, this.dateLastReviewed, this.daysBetweenReview, this.overdue, this.difficulty});
}
class FlashcardBundle
{
  // Fields
  int fid;
  DateTime dateLastReviewed;
  int daysBetweenReview;
  double overdue;
  int rating;

  FlashcardBundle({this.fid, this.dateLastReviewed, this.daysBetweenReview, this.overdue, this.rating});
}
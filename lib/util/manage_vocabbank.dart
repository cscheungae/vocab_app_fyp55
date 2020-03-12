import 'package:vocab_app_fyp55/model/vocab.dart';


/* Compare Vocab based on Word */
bool isShorterThan( String a, String b )
{
  int shorterLength = ( a.length < b.length )? a.length : b.length; 
  int count = 0;
  
  while ( count != shorterLength )
  {
    if ( a.codeUnitAt(count) == b.codeUnitAt(count)  )
    { count++; }  
    else if ( a.codeUnitAt(count) < b.codeUnitAt(count) )
    { return true;  }
    else 
    { return false; }
  }

  if ( shorterLength == a.length ){ return true; }
  else { return false; }
}


/* Sort Vocab List by Letter, Linear Sorting */
List<Vocab> sortVocabListByWords( List<Vocab> originalList )
{
  var resultList = originalList;
  Vocab key;

  for ( int i = 0; i < resultList.length; i++ )
  {
    int index = i;
    while ( index > 0 )
    {
      if (  isShorterThan(resultList[index].word, resultList[index-1].word) ) 
      { 
        key = resultList[index];
        resultList[index] = resultList[index-1];
        resultList[index-1] = key;
        index--;
      }  
      else
      {break;}   
    }
  }
  return resultList;
}



/* A linear Search of Vocab List */
List<Vocab> getSearchResultVocabList( List<Vocab> originalList , final String query )
{
  List<Vocab> resultList = [];
  for ( int i = 0; i < originalList.length; i++ )
  {
    if ( query.length <= originalList[i].word.length  )
    {
      if ( originalList[i].word.substring(0, query.length).toLowerCase() == query )
      { resultList.add(originalList[i]);  }
    }
  }
  return resultList;
}


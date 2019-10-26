
import 'package:flutter/material.dart';
import '../States/vocabularyState.dart';


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
List<vocabulary> sortVocabListByWords( List<vocabulary> originalList )
{
  var resultList = originalList;
  vocabulary key;

  for ( int i = 0; i < resultList.length; i++ )
  {
    int index = i;
    while ( index > 0 )
    {
      if (  isShorterThan(resultList[index].getWord(), resultList[index-1].getWord())  ) 
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
List<vocabulary> getSearchResultVocabList( List<vocabulary> originalList , final String query )
{
  List<vocabulary> resultList = [];

  for ( int i = 0; i < originalList.length; i++ )
  {
    if ( query.length <= originalList[i].getWord().length  )
    {
      if ( originalList[i].getWord().substring(0, query.length).toLowerCase() == query )
      { resultList.add(originalList[i]);  }
    }
  }

  return resultList;
}


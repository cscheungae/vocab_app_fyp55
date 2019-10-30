import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'vocabularyState.dart';

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//import 'package:shared_preferences/shared_preferences.dart';

class vocabularyBankState
{
  //We only want one instance of vocabularyBank State (singleton) throughout the whole program
  //Hence the private constructor, static instance
  static final vocabularyBankState _instance = vocabularyBankState._();
  vocabularyBankState._(); 
  static vocabularyBankState get instance { return _instance; }

  //database
  static Database _database;

  //whole list of vocabularies, unaltered
  static List<vocabulary> _vocabList = [];   

  //constant value related to database
  static final String dbName = "FYPVocabDB.db";
  static final String tableName = "VocabBank";
  static final int dbVersion = 1;


  //get database, initialize it if not yet
  Future<Database> get database async
  {
    if (_database == null )
      _database = await initializeDB();
    return _database;
  }


  //initialize the database
  Future<Database> initializeDB() async
  {
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dbDirectory.path, dbName );
    return await openDatabase( 
      dbPath, 
      version: dbVersion, 
      onOpen:(db){},
      onCreate: (Database db, int version ) async {
        _initializeVocabTable(db);
      }
    );
  }



  Future<void> _initializeVocabTable(Database db) async{
    await db.execute( 
      "CREATE TABLE "+ tableName + " (word TEXT, meaning TEXT, imageSource TEXT, sampleSentence TEXT, wordForm TEXT)");
  }




  //get vocablist, which is always fetched from SQLite by default  
  Future<List<vocabulary>> getVocabList({ bool forceUpdate = true }) async
  {
    if ( forceUpdate || _vocabList.isEmpty )
      _vocabList = await readAllVocabs();
    return _vocabList; 
  }


  //getting the string list of the vocabulary words
  List<String> getVocabStringList()
  {
    List<String> resultVocabStringList = [];
    for ( vocabulary vocab in _vocabList ){
      resultVocabStringList.add(vocab.getWord());
    }
    return resultVocabStringList;
  }




  /* CRUD Operation */
  Future<int> createNewVocab(vocabulary vocab) async
  {
    //Prevent Repetitive
    if ( await readVocab(vocab.getWord()) != null ){
      return 0;
    }

    final db = await database;
    var response = await db.insert( tableName, vocab.toJson() );
    return response;
  }


  Future<vocabulary> readVocab(String word) async
  {
    final db = await database;
    List<Map> response;

    try { response = await db.query( tableName, where: "word = ?", whereArgs:[word]); }
    catch (SqfliteDatabaseException ){ //table doesn't exist
      await _initializeVocabTable(db);
      response = await db.query( tableName, where: "word = ?", whereArgs:[word]);
    }
    

    if ( response.isNotEmpty )
      return vocabulary.fromJson(response.first);
    else
      return null;
  }


  Future<List<vocabulary>> readAllVocabs() async
  {
    final db = await database;
    List<Map> response;
    
    try { response = await db.query( tableName );
    } catch ( SqfliteDatabaseException ){
      await _initializeVocabTable(db);
      response = await db.query(tableName );
    }

    List<vocabulary> resultVocabList = [];

    for ( int i = 0; i < response.length; i++ )
    {
      resultVocabList.add( new vocabulary.fromJson(response[i]));
    }
    return resultVocabList;
  }


  Future<int> updateVocab( vocabulary vocab ) async
  {
    final db = await database;
    var response = await db.update(tableName, vocab.toJson(), where: "word = ?", whereArgs: [vocab.getWord()]);
    return response;
  }


  Future<int> deleteVocab( String word ) async
  {
    final db = await database;
    var response = await db.delete(tableName, where: "word =?", whereArgs: [word]);
    return response;
  }


  Future<int> deleteAllVocabs() async
  {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS " + tableName);
    return 0;
  }


}





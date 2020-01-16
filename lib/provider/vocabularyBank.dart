
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocab_app_fyp55/provider/providerConstant.dart';
import '../model/vocabulary.dart';
import '../model/vocabularyDefinition.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//import 'package:shared_preferences/shared_preferences.dart';

class VocabularyBank
{
  //We only want one instance of vocabularyBank State (singleton) throughout the whole program
  //Hence the private constructor, static instance
  static final VocabularyBank _instance = VocabularyBank._();
  VocabularyBank._(); 
  static VocabularyBank get instance { return _instance; }

  //database
  static Database _database;

  //int
  int nextVID = 0;

  //whole list of vocabularies, unaltered
  static List<vocabulary> _vocabList = [];

  //constant value related to database
  static final String dbName = ProviderConstant.databaseName;
  static final String tableName = ProviderConstant.vocabBankTableName;
  static final String defName = ProviderConstant.vocabDefinitionTableName;
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
      onCreate: (Database db, int version ) async {
        _initializeVocabTables(db);
        debugPrint("Database created");
      },
      onOpen:(db) async { 
        debugPrint("Database opened: " + dbDirectory.path );
        var response = await db.query(tableName);
        nextVID = ( response.isNotEmpty ) ? response.first["vid"] : 0;
      },
    );
  }

  //
  Future<void> _initializeVocabTables(Database db) async{
    try{
      await db.execute( "CREATE TABLE "+ tableName + " (vid INTEGER, zipf INTEGER, frequency INTEGER, name TEXT, image TEXT)");
    } catch(e){ debugPrint(e.toString() + " init vocab table failure"); }

    try{
      await db.execute( "CREATE TABLE " + defName +  " (vid INTEGER, did INTEGER, pos TEXT, pronunciation TEXT, definition TEXT, example TEXT)");
    } catch(e){debugPrint(e.toString() + " init def table failure"); }


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

  //Set up definitions for the vocab

  //Set up definitions for the vocab variable by reading database
  Future<vocabulary> _setUpDefinitions( vocabulary vocab ) async {
    try {
      //Lookup at the definition table
      final db = await database;
      var defResponse = await db.query( defName, where: "vid = ?", whereArgs:[vocab.getVID()] );
      print("vid of vocab: " + vocab.getWord() + "is " + vocab.getVID().toString() );
      for ( var item in defResponse ){
        vocab.addDefinition(VocabDefinition.fromJson(item));
      }
    } catch ( Exception ){debugPrint("Exceptions in setting up vocabulary's definitions");}
    return vocab;
  }

  /* CRUD Operation */
  //CREATE new vocabulary
  Future<int> createNewVocab(vocabulary vocab) async
  {
    final db = await database;

    //If such vocab already exist, update it instead
    if ( await readVocab(vocab.getWord()) != null ){
      debugPrint("Such vocab already exist: Instead of creating a new one it's updated instead");
      await updateVocab(vocab);
      return 0;
    }

    //Insert
    try {
      //Assign vid value
      nextVID++;
      vocab.setVID(nextVID);
      await db.insert( tableName, vocab.toJson(needDef: false) );
    } catch (Exception){ debugPrint("create vocabulary failed"); nextVID--; }
    
    //Insert Definitions
    try {
      var definitions = vocab.getAllDefinitions();  
      for ( int i = 0; i < definitions.length; i++ ){
        definitions[i].did = vocab.getVID();
        definitions[i].did = i;
        await db.insert(defName, definitions[i].toJson() );
      } 
      return 1;
    } catch (Exception){ debugPrint("create definition failed"); return -1; }
  }



  //READ
  Future<vocabulary> readVocab(String word) async
  {
    final db = await database;
    List<Map> response;
    //Receive Vocabulary
    try { 
      response = await db.query( tableName, where: "name = ?", whereArgs:[word]);
      if ( response.isNotEmpty ){
        vocabulary vocab = vocabulary.fromJson(response.first);
        vocab = await _setUpDefinitions(vocab);
        return vocab;
      } else return null;
    }
    catch ( Exception ){  debugPrint("Reading vocabulary failed!"); return null;}
  }

  ///READ: Reading All vocabs
  Future<List<vocabulary>> readAllVocabs() async
  {
    final db = await database;
    List<Map> response;
    
    //Receive Response
    try { response = await db.query( tableName );
    } catch ( SqfliteDatabaseException ){
      await _initializeVocabTables(db);
      response = await db.query(tableName);
    }

    //Get all vocabularies and setup the definitions
    List<vocabulary> resultVocabList = [];
    for ( int i = 0; i < response.length; i++ ){
      vocabulary vocab = new vocabulary.fromJson(response[i]);
      vocab = await _setUpDefinitions(vocab);
      resultVocabList.add(vocab);
    }
    return resultVocabList;
  }




  //Update vocab as well as definitions table
  Future<int> updateVocab( vocabulary vocab ) async
  {
    // final db = await database;
    
    //DID should not be replaced
    vocabulary newVocab = vocab;
    vocabulary oldVocab = await readVocab(vocab.getWord());
    newVocab.setVID(oldVocab.getVID());
    
    await deleteVocab(oldVocab);
    await createNewVocab(newVocab);
    return 1;

  }




  //Delete vocabs as well as definition table;
  Future<int> deleteVocab( vocabulary vocab ) async
  {
    try {
      final db = await database;
      await db.rawDelete("DELETE FROM " + defName + " WHERE vid = ?", [vocab.getVID()]);
      await db.rawDelete("DELETE FROM " + tableName + " WHERE name = ?", [vocab.getWord()]);
      return 1;
    } catch (Exception){ print("Deletion Failed\n" + Exception.toString()); return 0;}
  }

  //Delete All tables
  Future<int> deleteAllVocabs() async
  {
    try {
      final db = await database;
      await db.execute("DROP TABLE IF EXISTS " + defName);
      await db.execute("DROP TABLE IF EXISTS " + tableName);
      return 1;
    } catch (e){ debugPrint("Delete tables Failed"); return -1;}
  }

  //Delete Database
  static Future<void> deleteDB() async{
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dbDirectory.path, dbName );
    await deleteDatabase(dbPath);    
    debugPrint("Database deleted");
  }


}





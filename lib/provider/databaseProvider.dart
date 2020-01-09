import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocab_app_fyp55/model/Bundle/DefinitionBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/ExampleBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/FlashcardBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/PronunciationBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/VocabBundle.dart';
import 'package:vocab_app_fyp55/model/definition.dart';
import 'package:vocab_app_fyp55/model/example.dart';
import 'package:vocab_app_fyp55/model/flashcard.dart';
import 'package:vocab_app_fyp55/model/pronunciation.dart';
import 'package:vocab_app_fyp55/model/stat.dart';
import 'package:vocab_app_fyp55/provider/providerConstant.dart';
import '../model/vocab.dart';
import '../model/vocabularyDefinition.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider
{
  static final DatabaseProvider _instance = DatabaseProvider._();
  DatabaseProvider._();
  static DatabaseProvider get instance { return _instance; }

  // database
  static Database _database;

  // constant value related to database
  static final String dbName = providerConstant.anotherDatabaseName;
  static final String vocabTableName = providerConstant.vocabularyTableName;
  static final String statisticTableName = providerConstant.statisticsTableName;
  static final String definitionTableName = providerConstant.definitionTableName;
  static final String pronunciationTableName = providerConstant.pronunciationTableName;
  static final String exampleTableName = providerConstant.exampleTableName;
  static final String flashcardTableName = providerConstant.flashcardTableName;
  static final int dbVersion = 1;

  // get database, initialize it if not yet
  Future<Database> get database async
  {
    if (_database == null )
      _database = await initializeDB();
    return _database;
  }

  // initialize the database
  Future<Database> initializeDB() async
  {
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    print(dbDirectory.toString());
    String dbPath = join(dbDirectory.path, dbName);
    return await openDatabase(
        dbPath,
        version: dbVersion,
        onCreate: (Database db, int version) async {
          _initializeTables(db);
          debugPrint("Database created");
        },
      onOpen: (db) async {
        debugPrint("Database opened");
      }
    );
  }

  Future<void> _initializeTables(Database db) async
  {
    // TODO:: tables to be created
    // TODO:: Example, Pronunciation, Definition, Vocab, Stat, Flashcard
    try {
      String query = "CREATE TABLE " + exampleTableName + " (eid INTEGER PRIMARY KEY, did INTEGER NOT NULL, sentence TEXT, CONSTRAINT fk_ex_definition FOREIGN KEY (did) REFERENCES " + definitionTableName +"(did) ON DELETE CASCADE)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ exampleTableName +" table failure");}

    try {
      String query = "CREATE TABLE " +  pronunciationTableName + " (pid INTEGER PRIMARY KEY, did INTEGER NOT NULL, ipa TEXT, audioUrl TEXT, CONSTRAINT fk_pron_definition FOREIGN KEY (did) REFERENCES " + definitionTableName +"(did) ON DELETE CASCADE)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ pronunciationTableName +" table failure");}

    try {
      String query = "CREATE TABLE " + definitionTableName + " (did INTEGER PRIMARY KEY, vid INTEGER NOT NULL, pos TEXT, defineText Text, CONSTRAINT fk_df_vocab FOREIGN KEY (vid) REFERENCES " + vocabTableName +"(vid) ON DELETE CASCADE)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ definitionTableName +" table failure");}

    try {
      String query = "CREATE TABLE " + vocabTableName + " (vid INTEGER PRIMARY KEY, word TEXT, imageUrl TEXT, wordFreq INTEGER, trackFreq INTEGER, status INTEGER)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ vocabTableName +" table failure");}

    try{
      String query = "CREATE TABLE " + flashcardTableName + " (fid INTEGER PRIMARY KEY, vid INTEGER NOT NULL, dateLastReviewed TEXT, daysBetweenReview INTEGER, overdue REAL, rating INTEGER, CONSTRAINT fk_fc_vocab FOREIGN KEY (vid) REFERENCES " + vocabTableName +"(vid) ON DELETE CASCADE)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ flashcardTableName +" table failure");}

    try {
      String query = "CREATE TABLE " + statisticTableName + " (sid INTEGER PRIMARY KEY, logDate TEXT NOT NULL, trackingCount INTEGER NOT NULL, learningCount INTEGER NOT NULL, maturedCount INTEGER NOT NULL)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ statisticTableName +" table failure");}

  } // end of _initializeTables

// TODO:: Basic Operation First CRUD for all table
  // TODO:: create Vocab
  Future<int> insertVocab(Vocab vocab) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(vocabTableName, vocab.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create vocab failure"); response = null;}
    return response;
  }
  // TODO:: read Vocab
  Future<Vocab> readVocab(int vid) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
       response = await db.rawQuery("SELECT * FROM " + vocabTableName + " WHERE vid =" + vid.toString());
      if(response.length <=0 ) {
        throw new Exception("non-existing vid");
      }else if(response.length > 1) {
        throw new Exception("more than one vocab has been returned which is not acceptable as each vid is unique");
      }
    } catch(e) { debugPrint(e.toString() + "read vocab failure"); response = null;}
    return response != null ? Vocab.fromJson(response.first) : null;
  }
  // TODO:: update Vocab
  Future<int> updateVocab(Vocab vocab) async
  {
    // check if there is vid properties in the vocab, if no --> cannot update the vocab
    int response;
    try {
      if(vocab.vid == null){
      throw new Exception("Invalid Vocab: missing vid");
      } else {
        final db = await database;
        response =  await db.update(vocabTableName, vocab.toJson(), where: "vid = ?", whereArgs: [vocab.vid]);
      }
    } catch(e) {
      debugPrint("updateVocab failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }
  // TODO:: delete Vocab
  Future<int> deleteVocab(int vid) async
  {
    int response;
    try {
      if(vid == null) {
        throw new Exception("Invalid Vocab: missing vid");
      } else {
        final db = await database;
        response = await db.delete(vocabTableName, where: "vid = ?", whereArgs: [vid]);
      }
    } catch(e) {
      debugPrint("deleteVocab failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }
  // TODO:: create pronunciation
  Future<int> insertPronunciation(Pronunciation pron) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(pronunciationTableName, pron.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create pronunication failure"); response = null;}
    return response;
  }
  // TODO:: read pronunciation
  Future<List<Pronunciation>> readPronunciation(int did) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + pronunciationTableName + " WHERE did =" + did.toString());
      if(response.length <=0 ) {
        throw new Exception("non-existing pronunciation instance");
      }
    } catch(e) { debugPrint(e.toString() + "read pronunciation failure"); response = null;}
    return response != null ? response.map( (item) => Pronunciation.fromJson(item)) : null;
  }
  // TODO:: update pronunciation
  Future<int> updatePronunciation(Pronunciation pron) async
  {
    // check if there is vid properties in the vocab, if no --> cannot update the vocab
    int response;
    try {
      if(pron.pid == null){
        throw new Exception("Invalid Pronunciation: missing pid");
      } else {
        final db = await database;
        response =  await db.update(pronunciationTableName, pron.toJson(), where: "pid = ?", whereArgs: [pron.pid]);
      }
    } catch(e) {
      debugPrint("updatePronunciation failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }
  // TODO:: delete pronunciation
  Future<int> deletePronunciation(int pid) async
  {
    int response;
    try {
      if(pid == null) {
        throw new Exception("Invalid Pronunciation: missing pid");
      } else {
        final db = await database;
        response = await db.delete(pronunciationTableName, where: "pid = ?", whereArgs: [pid]);
      }
    } catch(e) {
      debugPrint("deletePronunciation failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }

  // TODO:: create definition
  Future<int> insertDefinition(Definition def) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(definitionTableName, def.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create definition failure"); response = null;}
    return response;
  }
  // TODO:: read definition
  Future<List<Definition>> readDefinition(int vid) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + definitionTableName + " WHERE vid =" + vid.toString());
      if(response.length <=0 ) {
        throw new Exception("non-existing definition instance");
      }
    } catch(e) { debugPrint(e.toString() + "read definition failure"); response = null;}
    return response != null ? response.map( (item) => Definition.fromJson(item)) : null;
  }
  // TODO:: update definition
  Future<int> updateDefinition(Definition def) async
  {
    // check if there is vid properties in the vocab, if no --> cannot update the vocab
    int response;
    try {
      if(def.did == null){
        throw new Exception("Invalid Definition: missing did");
      } else {
        final db = await database;
        response =  await db.update(definitionTableName, def.toJson(), where: "did = ?", whereArgs: [def.did]);
      }
    } catch(e) {
      debugPrint("updateDefinition failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }
  // TODO:: delete definition
  Future<int> deleteDefinition(int did) async
  {
    int response;
    try {
      if(did == null) {
        throw new Exception("Invalid Definition: missing did");
      } else {
        final db = await database;
        response = await db.delete(definitionTableName, where: "did = ?", whereArgs: [did]);
      }
    } catch(e) {
      debugPrint("deleteDefinition failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }

  // TODO:: create example
  Future<int> insertExample(Example example) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(exampleTableName, example.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create example failure"); response = null;}
    return response;
  }
  // TODO:: read example
  Future<List<Example>> readExample(int did) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + exampleTableName + " WHERE did =" + did.toString());
      if(response.length <=0 ) {
        throw new Exception("non-existing definition instance");
      }
    } catch(e) { debugPrint(e.toString() + "read example failure"); response = null;}
    return response != null ? response.map( (item) => Example.fromJson(item)) : null;
  }
  // TODO:: update example
  Future<int> updateExample(Example example) async
  {
    // check if there is vid properties in the vocab, if no --> cannot update the vocab
    int response;
    try {
      if(example.eid == null){
        throw new Exception("Invalid Example: missing eid");
      } else {
        final db = await database;
        response =  await db.update(exampleTableName, example.toJson(), where: "eid = ?", whereArgs: [example.eid]);
      }
    } catch(e) {
      debugPrint("updateExample failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }
  // TODO:: delete example
  Future<int> deleteExample(int eid) async
  {
    int response;
    try {
      if(eid == null) {
        throw new Exception("Invalid Example: missing eid");
      } else {
        final db = await database;
        response = await db.delete(exampleTableName, where: "eid = ?", whereArgs: [eid]);
      }
    } catch(e) {
      debugPrint("deleteExample failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }

  // TODO:: create flashcard
  Future<int> insertFlashcard(Flashcard flashcard) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(flashcardTableName, flashcard.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create flashcard failure"); response = null;}
    return response;
  }
  // TODO:: read flashcard
  Future<Flashcard> readFlashcard(int vid) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + flashcardTableName + " WHERE vid =" + vid.toString());
      if(response.length <=0 ) {
        throw new Exception("non-existing definition instance");
      }
    } catch(e) { debugPrint(e.toString() + "read example failure"); response = null;}
    return response != null ? Flashcard.fromJson(response.first) : null;
  }
  // TODO:: update flashcard
  Future<int> updateFlashcard(Flashcard flashcard) async
  {
    // check if there is vid properties in the vocab, if no --> cannot update the vocab
    int response;
    try {
      if(flashcard.fid == null){
        throw new Exception("Invalid Example: missing eid");
      } else {
        final db = await database;
        response =  await db.update(flashcardTableName, flashcard.toJson(), where: "fid = ?", whereArgs: [flashcard.fid]);
      }
    } catch(e) {
      debugPrint("updateFlashcard failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }
  // TODO:: delete flashcard
  Future<int> deleteFlashcard(int fid) async
  {
    int response;
    try {
      if(fid == null) {
        throw new Exception("Invalid Example: missing fid");
      } else {
        final db = await database;
        response = await db.delete(flashcardTableName, where: "fid = ?", whereArgs: [fid]);
      }
    } catch(e) {
      debugPrint("deleteFlashcard failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }

  // TODO:: Think of the operation of stat!!
  // TODO:: create stat
  Future<int> insertStat(Stat stat) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(statisticTableName, stat.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create flashcard failure"); response = null;}
    return response;
  }
  // TODO:: read stat
  Future<List<Stat>> readStat(int sid) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.query(statisticTableName, columns: ["sid", "logDate", "trackingCount", "learningCount", "maturedCount"], where: '$sid = ?', whereArgs: [sid]);
      if(response.length <=0 ) {
        throw new Exception("non-existing statistics instance");
      }else if(response.length > 1) {
        throw new Exception("more than one statistics has been returned which is not acceptable as each sid is unique");
      }
    } catch(e) { debugPrint(e.toString() + "read statistics failure"); response = null;}
    return response != null ? response.map( (item) => Stat.fromJson(item)) : null;
  }
  // TODO:: update stat
  Future<int> updateStat(Stat stat) async
  {
    // check if there is vid properties in the vocab, if no --> cannot update the vocab
    int response;
    try {
      if(stat.sid == null){
        throw new Exception("Invalid Stat: missing sid");
      } else {
        final db = await database;
        response =  await db.update(statisticTableName, stat.toJson(), where: "sid = ?", whereArgs: [stat.sid]);
      }
    } catch(e) {
      debugPrint("updateStat failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }
  // TODO:: delete stat
  Future<int> deleteStat(int sid) async
  {
    int response;
    try {
      if(sid == null) {
        throw new Exception("Invalid Stat: missing sid");
      } else {
        final db = await database;
        response = await db.delete(statisticTableName, where: "sid = ?", whereArgs: [sid]);
      }
    } catch(e) {
      debugPrint("deleteStat failure");
      debugPrint(e.toString());
      response = null;
    }
    return response;
  }

// TODO:: Selection of Join Operation results (make a big vocabulary)
  Future<List<Vocab>> readAllVocab() async
  {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + vocabTableName);
    } catch(e) { debugPrint(e.toString() + "read vocab failure"); response = null;}
    return response != null ? response.map((item) => Vocab.fromJson(item)) : null;
  }

  Future<VocabBundle> readVocabBundle(int vid) async
  {
    // obtain a vocab bundle (with all the info. of a word)
    final db = await database;
    Vocab vocab = await readVocab(vid);
    Flashcard flashcard = await readFlashcard(vid);
    FlashcardBundle flashcardBundle = FlashcardBundle(
        fid: flashcard.fid,
        dateLastReviewed: flashcard.dateLastReviewed,
        daysBetweenReview: flashcard.daysBetweenReview,
        overdue: flashcard.overdue,
        rating: flashcard.rating
    );

    // Special operation need to loop to create each step by step
    List<Definition> definitions = await readDefinition(vid);
    // for each definition, find its examples and pronunciation, assign to the definition bundle
    List<DefinitionBundle> definitionsBundle;
   for (int i=0; i<definitions.length; i++) {
     // search its pronunciation and examples
     Definition definition = definitions[i];
     List<Pronunciation> pronunciations = await readPronunciation(definition.did);
     List<Example> examples = await readExample(definition.did);
     // construct pronunciationsBundle and examplesBundle
     List<PronunciationBundle> pronunciationsBundle = pronunciations.map((item) => PronunciationBundle(pid: item.pid, ipa: item.ipa, audioUrl: item.audioUrl));
     List<ExampleBundle> examplesBundle = examples.map((item) => ExampleBundle(eid: item.eid, sentence: item.sentence));
     definitionsBundle.add(
         DefinitionBundle(
             did: definition.did,
             pos: definition.pos,
             pronunciationsBundle: pronunciationsBundle,
             examplesBundle: examplesBundle
         )
     );
   }

   return VocabBundle(
     vid: vocab.vid,
     word: vocab.word,
     imageUrl: vocab.imageUrl,
     wordFreq: vocab.wordFreq,
     trackFreq: vocab.trackFreq,
     status: vocab.status,
     flashcardBundle: flashcardBundle,
     definitionsBundle: definitionsBundle,
   );
  }
}
import 'dart:math';

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
import 'package:vocab_app_fyp55/model/vocabulary.dart';
import 'package:vocab_app_fyp55/provider/providerConstant.dart';
import '../model/vocab.dart';
import '../model/vocabularyDefinition.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocab_app_fyp55/provider/Status' as ImportStatus;

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
      },
      onConfigure: (db) async {
          // enable the foreign key s.t. ON DELETE CASCADE works
          await db.execute('PRAGMA foreign_keys = ON');
      }
    );
  }

  Future<void> _initializeTables(Database db) async
  {
    /// Tables to be created
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
      String query = "CREATE TABLE " + vocabTableName + " (vid INTEGER PRIMARY KEY, word TEXT UNIQUE, imageUrl TEXT, wordFreq INTEGER, trackFreq INTEGER, status INTEGER)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ vocabTableName +" table failure");}

    try{
      String query = "CREATE TABLE " + flashcardTableName + " (fid INTEGER PRIMARY KEY, vid INTEGER NOT NULL UNIQUE, dateLastReviewed TEXT, daysBetweenReview INTEGER, overdue REAL, difficulty REAL, CONSTRAINT fk_fc_vocab FOREIGN KEY (vid) REFERENCES " + vocabTableName +"(vid) ON DELETE CASCADE)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ flashcardTableName +" table failure");}

    try {
      String query = "CREATE TABLE " + statisticTableName + " (sid INTEGER PRIMARY KEY, logDate TEXT NOT NULL, trackingCount INTEGER NOT NULL, learningCount INTEGER NOT NULL, maturedCount INTEGER NOT NULL)";
      await db.execute(query);
    } catch(e) {debugPrint(e.toString() + "init "+ statisticTableName +" table failure");}

  } // end of _initializeTables

  /// Basic Operation First CRUD for all table
  /// ***************************** Vocab Route *****************************
  Future<int> insertVocab(Vocab vocab) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(vocabTableName, vocab.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
      await triggerStatLog();
    } catch(e) { debugPrint(e.toString() + "create vocab failure"); response = null;}
    return response;
  }

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

  Future<int> deleteAllVocab() async
  {
    int response;
    try {
      final db = await database;
      response = await db.delete(vocabTableName);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  /// ***************************** Pronunciation Route *****************************
  Future<int> insertPronunciation(Pronunciation pron) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(pronunciationTableName, pron.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create pronunication failure"); response = null;}
    return response;
  }

  Future<List<Pronunciation>> readPronunciation(int did) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + pronunciationTableName + " WHERE did =" + did.toString());
      if(response.length <=0 ) {
        throw new Exception("non-existing pronunciation instance");
      }
    } catch(e) { debugPrint(e.toString() + "read pronunciation failure"); response = null;}
    return response != null ? response.map( (item) => Pronunciation.fromJson(item)).toList() : null;
  }

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

  Future<int> deleteAllPronunciation() async
  {
    int response;
    try {
      final db = await database;
      response = await db.delete(pronunciationTableName);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  /// ***************************** Definition Route *****************************
  Future<int> insertDefinition(Definition def) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(definitionTableName, def.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create definition failure"); response = null;}
    return response;
  }

  Future<List<Definition>> readDefinition(int vid) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + definitionTableName + " WHERE vid =" + vid.toString());
      if(response.length <=0 ) {
        throw new Exception("non-existing definition instance");
      }
    } catch(e) { debugPrint(e.toString() + "read definition failure"); response = null;}
    return response != null ? response.map( (item) => Definition.fromJson(item)).toList() : null;
  }

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

  Future<int> deleteAllDefinition() async
  {
    int response;
    try {
      final db = await database;
      response = await db.delete(definitionTableName);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  /// ***************************** Example Route *****************************
  Future<int> insertExample(Example example) async
  {
    int response;
    try {
      final db = await database;
      response = await db.insert(exampleTableName, example.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create example failure"); response = null;}
    return response;
  }

  Future<List<Example>> readExample(int did) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + exampleTableName + " WHERE did =" + did.toString());
      if(response.length <=0 ) {
        throw new Exception("non-existing definition instance");
      }
    } catch(e) { debugPrint(e.toString() + "read example failure"); response = null;}
    return response != null ? response.map( (item) => Example.fromJson(item)).toList() : null;
  }

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


  Future<int> deleteAllExample() async
  {
    int response;
    try {
      final db = await database;
      response = await db.delete(exampleTableName);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  /// ***************************** Flashcard Route *****************************
  Future<int> insertFlashcard(Flashcard flashcard) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(flashcardTableName, flashcard.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
      await triggerStatLog();
    } catch(e) { debugPrint(e.toString() + "create flashcard failure"); response = null;}
    return response;
  }

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

  Future<List<Flashcard>> getStudyFlashcards(int quantity) async {
    List<Map<String, dynamic>> response;
    try {
      final db = await database;
      // TODO:: update the overdue attributes
      int changeDateIndex = await db.rawUpdate(
          '''
          UPDATE $flashcardTableName
          SET "overdue" = julianday('now') - julianday("dateLastReviewed")
          '''
      );
      int minOverdueIndex = await db.rawUpdate(
        '''
        UPDATE $flashcardTableName
        SET "overdue" = 2
        WHERE "overdue" > 2
        '''
      );
      // TODO:: rank the flashcard table by descending overdue order
      response = await db.rawQuery(
        '''
        SELECT *
        FROM $flashcardTableName
        ORDER BY "overdue" DESC
        WHERE strftime('%H','now') - strftime('%H', "overdue") > 8
        LIMIT $quantity
        '''
      );

    } catch(e) { debugPrint(e.toString() + " failure in getStudyFlashcards"); response = null; }
    return response != null ? response.map((item) => Flashcard.fromJson(item)).toList() : null;
  }

  // This is a pure update Flashcard function with no logic
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

  // This is a update Flashcard function based on rating and old Flashcard
  Future<int> reviseFlashcard(Flashcard oldFlashcard, double rating) async {
    double percentOverdue = rating > providerConstant.passCutoff ? min(2, (DateTime.now().difference(oldFlashcard.dateLastReviewed).inDays).toDouble()/oldFlashcard.daysBetweenReview.toDouble()) : 1.0;
    double newDifficulty = percentOverdue / 17 * (8-9*rating);
    double difficultyWeight = 3 - 1.7*newDifficulty;
    int newDaysBetweenReviews = rating > providerConstant.passCutoff ? (1 + (difficultyWeight - 1) * percentOverdue).floor() : min(1, (1 / pow(difficultyWeight, 2)).floor());
    // Change the status as the card is matured.
    if (newDaysBetweenReviews >= providerConstant.maturePeriod ) {
      try {
        // obtain the vocab
        Vocab vocab = await readVocab(oldFlashcard.vid);
        // Set a new state to Status.matured
        vocab.status = Status.matured;
        // upload to the vocab table in the database
        await updateVocab(vocab);
        // trigger stat log
        await triggerStatLog();
      } catch(e) { debugPrint(e.toString() + "failure in reviseFlashcard"); }
    } else if (newDaysBetweenReviews < providerConstant.maturePeriod && oldFlashcard.daysBetweenReview > providerConstant.maturePeriod) {
      try {
      // obtain the vocab
      Vocab vocab = await readVocab(oldFlashcard.vid);
      // Set a new state to Status.matured
      vocab.status = Status.learning;
      // upload to the vocab table in the database
      await updateVocab(vocab);
      // trigger stat log
      await triggerStatLog();
      } catch(e) { debugPrint(e.toString() + "failure in reviseFlashcard"); }
    }
    return await updateFlashcard(Flashcard(vid: oldFlashcard.vid, fid: oldFlashcard.fid, dateLastReviewed: DateTime.now().toIso8601String(), daysBetweenReview: newDaysBetweenReviews, difficulty: newDifficulty));
  }

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


  Future<int> deleteAllFlashcard() async
  {
    int response;
    try {
      final db = await database;
      response = await db.delete(flashcardTableName);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  /// ***************************** Stat Route *****************************
  Future<int> insertStat(Stat stat) async
  {
    int response;
    final db = await database;
    try {
      response = await db.insert(statisticTableName, stat.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString() + "create flashcard failure"); response = null;}
    return response;
  }

  Future<int> triggerStatLog() async
  {
    int response;
    try {
      final db = await database;
      // TODO:: find the number of tracking, learning and matured in the vocab status
      var res = await db.rawQuery(
        '''
        SELECT COUNT (*)
        FROM $vocabTableName
        WHERE "status" = 0
        '''
      );
      int trackingCount = Sqflite.firstIntValue(res);
      // TODO:: create a stat instance
      res = await db.rawQuery(
          '''
        SELECT COUNT (*)
        FROM $vocabTableName
        WHERE "status" = 0
        '''
      );
      int learningCount = Sqflite.firstIntValue(res);
      // TODO:: insert to Stat
      res = await db.rawQuery(
          '''
        SELECT COUNT (*)
        FROM $vocabTableName
        WHERE "status" = 0
        '''
      );
      int maturedCount = Sqflite.firstIntValue(res);

      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      Stat stat = Stat(logDate: date, trackingCount: trackingCount, learningCount: learningCount, maturedCount: maturedCount);
      response = await insertStat(stat);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  Future<Stat> readStat(int sid) async {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.query(statisticTableName, columns: ["sid", "logDate", "trackingCount", "learningCount", "maturedCount"], where: 'sid = ?', whereArgs: [sid]);
      if(response.length <=0 ) {
        throw new Exception("non-existing statistics instance");
      }else if(response.length > 1) {
        throw new Exception("more than one statistics has been returned which is not acceptable as each sid is unique");
      }
    } catch(e) { debugPrint(e.toString() + "read statistics failure"); response = null;}
    return response != null ? Stat.fromJson(response.first) : null;
  }

  Future<List<Stat>> readAllStat() async
  {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + statisticTableName);
    } catch(e) { debugPrint(e.toString() + " read all statistics failure"); response = null; }
    return response != null ? response.map((item) => Stat.fromJson(item)).toList() : null;
  }

  Future<List<Stat>> getUserStistics() async
  {
    List<Map<String, dynamic>> response;
    try {
      final db = await database;
      // TODO:: Clear the outdated log
      await deleteOutdatedStat();
      // TODO:: Return the list of stat
      response = await db.query(statisticTableName);
    } catch(e) { debugPrint(e.toString() + " failure in getUserStistics"); response = null; }
    return response != null ? response.map((item) => Stat.fromJson(item)).toList() : null;
  }


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

  Future<int> deleteOutdatedStat() async
  {
    int rowsDeleted;
    try {
      final db = await database;
      var res = await.rawQuery(
      '''
      DELETE *
      FROM $statisticTableName
      WHERE NOT EXISTS (SELECT "sid", "logDate", max("trackingCount"), max("learningCount"), max(maturedCount)
                        FROM STAT
                        GROUP BY "logDate")
      '''
      );
      rowsDeleted = Sqflite.firstIntValue(res);
    } catch(e) { debugPrint(e.toString() + " failure in deleteOutdatedStat"); rowsDeleted = null; }
    return rowsDeleted;
  }


  Future<int> deleteAllStat() async
  {
    int response;
    try {
      final db = await database;
      response = await db.delete(statisticTableName);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  /// ***************************** Handy Methods Route *****************************
  Future<Vocab> getVocab(String word) async
  {
    List<Map<String, dynamic>> response;
    try {
      final db = await database;
      response = await db.query(vocabTableName, columns: ["vid", "word", "imageUrl", "wordFreq", "trackFreq", "status"], where: "word = ?", whereArgs: [word]);
      if(response.length <=0 ) {
        throw new Exception("Word does not exist.");
      } else if (response.length > 1) {
        throw new Exception("More than one Vocab instances are returned which violates the UNIQUE Constraint");
      }
    } catch(e) { debugPrint(e.toString() + "getVocab error"); response = null; }
    return response != null ? Vocab.fromJson(response.first) : null;
  }

  Future<List<Vocab>> readAllVocab() async
  {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + vocabTableName);
    } catch(e) { debugPrint(e.toString() + "read vocab failure"); response = null;}
    return response != null ? response.map((item) => Vocab.fromJson(item)).toList() : null;
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
        difficulty: flashcard.difficulty
    );

    // Special operation need to loop to create each step by step
    List<Definition> definitions = await readDefinition(vid);
    // for each definition, find its examples and pronunciation, assign to the definition bundle
    List<DefinitionBundle> definitionsBundle = [];
   for (int i=0; i<definitions.length; i++) {
     // search its pronunciation and examples
     Definition definition = definitions[i];
     List<Pronunciation> pronunciations = await readPronunciation(definition.did);
     List<Example> examples = await readExample(definition.did);
     // construct pronunciationsBundle and examplesBundle
     List<PronunciationBundle> pronunciationsBundle = pronunciations.map((item) => PronunciationBundle(pid: item.pid, ipa: item.ipa, audioUrl: item.audioUrl)).toList();
     List<ExampleBundle> examplesBundle = examples.map((item) => ExampleBundle(eid: item.eid, sentence: item.sentence)).toList();
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

  Future<int> dropDatabase() async {
    List<Map<String, dynamic>> response;
    try {
      Directory dbDirectory = await getApplicationDocumentsDirectory();
      print(dbDirectory.toString());
      String dbPath = join(dbDirectory.path, dbName);
      deleteDatabase(dbPath);
    } catch(e) { debugPrint(e.toString()); return null; }
    return 1;
  }

}

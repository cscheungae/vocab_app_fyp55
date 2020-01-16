import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocab_app_fyp55/model/Bundle/DefinitionBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/ExampleBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/FlashcardBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/PronunciationBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/VocabBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/UserBundle.dart';
import 'package:vocab_app_fyp55/model/Genre.dart';
import 'package:vocab_app_fyp55/model/User.dart';
import 'package:vocab_app_fyp55/model/definition.dart';
import 'package:vocab_app_fyp55/model/example.dart';
import 'package:vocab_app_fyp55/model/flashcard.dart';
import 'package:vocab_app_fyp55/model/pronunciation.dart';
import 'package:vocab_app_fyp55/model/stat.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
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
  static final String dbName = ProviderConstant.anotherDatabaseName;
  static final String vocabTableName = ProviderConstant.vocabularyTableName;
  static final String userTableName = ProviderConstant.userTableName;
  static final String statisticTableName = ProviderConstant.statisticsTableName;
  static final String definitionTableName = ProviderConstant.definitionTableName;
  static final String pronunciationTableName = ProviderConstant.pronunciationTableName;
  static final String exampleTableName = ProviderConstant.exampleTableName;
  static final String flashcardTableName = ProviderConstant.flashcardTableName;
  static final String genreTableName = ProviderConstant.genreTableName;
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
    ///
    try{
        String query = "CREATE TABLE " + userTableName + " (uid INTEGER PRIMARY KEY, name TEXT UNIQUE, trackThres INTEGER NOT NULL, wordFreqThres INTEGER NOT NULL, region TEXT NOT NULL)";
        await db.execute(query);
    } catch(e) { debugPrint(e.toString() + " failure in create User table"); }

    try {
      String query = "CREATE TABLE " + vocabTableName + " (vid INTEGER PRIMARY KEY, word TEXT UNIQUE, imageUrl TEXT, wordFreq INTEGER, trackFreq INTEGER, status INTEGER)";
      await db.execute(query);
      print("Successful vocab table");
    } catch(e) {debugPrint(e.toString() + "init "+ vocabTableName +" table failure");}

    try {
      String query = "CREATE TABLE " + genreTableName + " (gid INTEGER PRIMARY KEY, category TEXT, uid INTEGER NOT NULL, CONSTRAINT fk_user FOREIGN KEY (uid) REFERENCES " + userTableName + "(uid) ON DELETE CASCADE)";
    } catch(e) {debugPrint(e.toString() + "init "+ genreTableName +" table failure");}

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
  /// ***************************** User Route *****************************
  Future<int> insertUser(User user) async
  {
    int response;
    try {
      final db = await database;
      response = await db.insert(userTableName, user.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  Future<User> readUser(int uid) async {
    List<Map<String, dynamic>> response;
    try{
      final db = await database;
      response = await db.query(userTableName, columns: null, where: "uid = ?", whereArgs: [uid]);
    } catch(e) { debugPrint(e.toString() + " failure in reading User"); response = null; }
    return response != null ? User.fromJson(response.first) : null;
  }

  Future<int> updateUser(User user) async
  {
    int response;
    try {
      if(user.uid == null) throw new Exception("Invalid update of User: missing uid");
      final db = await database;
      response = await db.update(userTableName, user.toJson(), where: "uid = ?", whereArgs: [user.uid]);
    } catch(e) { debugPrint(e.toString() + " failure in reading User"); response = null; }
    return response;
  }

  Future<int> deleteUser(int uid) async
  {
    int response;
    try {
      if(uid == null) throw new Exception("Invalid delete of User: missing uid");
      final db = await database;
      response = await db.delete(userTableName, where: "uid = ?", whereArgs: [uid]);
    } catch(e) { debugPrint(e.toString() + " failure in deleteUser()"); response = null; }
    return response;
  }

  Future<UserBundle> getUserBundle(int uid) async
  {
    UserBundle userBundle;
    try {
      User user = await readUser(uid);
      List<Genre> genres = await getGenreByUid(uid);
      // Create the UserBundle and GenreBundle
      List<String> genreBundle = [];
      genres.forEach((genre) {
        genreBundle.add(genre.category);
      });
      userBundle = new UserBundle(uid: user.uid, name: user.name, trackThres: user.trackThres, wordFreqThres: user.wordFreqThres, region: user.region, genreBundle: genreBundle);
    } catch(e) { debugPrint(e.toString() + " failure in getUserBundle()"); userBundle = null; }
    return userBundle;
  }

  /// ***************************** Genre Route *****************************
  Future<int> insertGenre(Genre genre) async
  {
    int response;
    try {
      final db = await database;
      response = await db.insert(genreTableName, genre.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch(e) { debugPrint(e.toString()); response = null; }
    return response;
  }

  Future<Genre> readGenre(int gid) async
  {
    List<Map<String, dynamic>> response;
    try{
      final db = await database;
      response = await db.query(genreTableName, columns: null, where: "gid = ?", whereArgs: [gid]);
    } catch(e) { debugPrint(e.toString() + " failure in reading genre"); response = null; }
    return response != null ? Genre.fromJson(response.first) : null;
  }

  Future<List<Genre>> getGenreByUid(int uid) async
  {
    List<Map<String, dynamic>> response;
    try{
      final db = await database;
      response = await db.query(genreTableName, columns: null, where: "uid = ?", whereArgs: [uid]);
    } catch(e) { debugPrint(e.toString() + " failure in getGenreByUid()"); response = null; }
    return response != null ? response.map((item) => Genre.fromJson(item)).toList() : null;
  }

  Future<int> updateGenre(Genre genre) async
  {
    int response;
    try {
      if(genre.gid == null) throw new Exception("Invalid update of Genre: missing gid");
      final db = await database;
      response = await db.update(genreTableName, genre.toJson(), where: "gid = ?", whereArgs: [genre.gid]);
    } catch(e) { debugPrint(e.toString() + " failure in reading Genre"); response = null; }
    return response;
  }

  Future<int> deleteGenre(int gid) async
  {
    int response;
    try {
      if(gid == null) throw new Exception("Invalid delete of Genre: missing gid");
      final db = await database;
      response = await db.delete(genreTableName, where: "gid = ?", whereArgs: [gid]);
    } catch(e) { debugPrint(e.toString() + " failure in deleteGenre()"); response = null; }
    return response;
  }

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

  Future<List<Flashcard>> readAllFlashcard() async
  {
    final db = await database;
    List<Map<String, dynamic>> response;
    try {
      response = await db.rawQuery("SELECT * FROM " + flashcardTableName);
    } catch(e) { debugPrint(e.toString() + " read all statistics failure"); response = null; }
    return response != null ? response.map((item) => Flashcard.fromJson(item)).toList() : null;
  }

  Future<List<Flashcard>> getStudyFlashcards(int quantity) async {
    List<Map<String, dynamic>> response;
    try {
      final db = await database;
      // TODO:: update the overdue attributes
      await db.rawUpdate(
          '''
          UPDATE $flashcardTableName
          SET overdue = julianday('now') - julianday(dateLastReviewed, 'utc') / daysBetweenReview
          '''
      );
      await db.rawUpdate(
        '''
        UPDATE $flashcardTableName
        SET overdue = 2
        WHERE overdue > 2
        '''
      );
      // TODO:: rank the flashcard table by descending overdue order
      response = await db.rawQuery(
        '''
        SELECT * 
        FROM $flashcardTableName
        WHERE strftime('%s','now', 'localtime') - strftime('%s', dateLastReviewed) > 0
        ORDER BY overdue DESC
        LIMIT $quantity
        '''
      );

    } catch(e) { debugPrint(e.toString() + " failure in getStudyFlashcards"); response = null; }
    return response != null ? response.map((item) => Flashcard.fromJson(item)).toList() : null;
  }

  Future<List<VocabBundle>> getStudyVocabs(int quantity) async {
    List<VocabBundle> response = [];
    try {
      // TODO:: call the getStudyFlashcards which return a set of Flashcard
      List<Flashcard> flashcards = await getStudyFlashcards(quantity);
      // TODO:: by looping through the set of flashcards, get its vocabBundle and attach the the response
      await Future.forEach(flashcards, (flashcard) async {
        VocabBundle vocab = await readVocabBundle(flashcard.vid);
        response.add(vocab);
      });
    } catch(e) { debugPrint(e.toString()); }
    return response.isNotEmpty ? response : null;
  }

  Future<String> getTime() async
  {
    List<Map<String, dynamic>> response;
    try {
      final db = await database;
      response = await db.rawQuery(
        '''
        SELECT julianday('now', 'utc')
        '''
      );
    } catch(e) { debugPrint(e.toString() + " failure in getTime()"); }
    return response.toString();
  }

  // This is a pure update Flashcard function with no logic
  Future<int> updateFlashcard(Flashcard flashcard) async
  {
    debugPrint("Update flashcard: ${flashcard.toString()}");
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
    double percentOverdue = rating > ProviderConstant.passCutoff ? min(2, (DateTime.now().difference(oldFlashcard.dateLastReviewed).inDays).toDouble()/oldFlashcard.daysBetweenReview.toDouble()) : 1.0;
    double newDifficulty = percentOverdue / 17 * (8-9*rating) + oldFlashcard.difficulty;
    // clamp newDifficulty to [0.0, 1.0]
    newDifficulty = max(newDifficulty, 0);
    newDifficulty = min(1, newDifficulty);
    double difficultyWeight = 3 - 1.7*newDifficulty;
//    int newDaysBetweenReviews = oldFlashcard.daysBetweenReview * (rating > providerConstant.passCutoff ? (1 + (difficultyWeight - 1) * percentOverdue).floor() : max(1, (1 / pow(difficultyWeight, 2)).floor()));
    int newDaysBetweenReviews;
    if( rating > ProviderConstant.passCutoff ) {
      newDaysBetweenReviews = (oldFlashcard.daysBetweenReview * (1 + (difficultyWeight - 1) * percentOverdue)).floor();
    } else {
      newDaysBetweenReviews = max(1, (oldFlashcard.daysBetweenReview * (1/pow(difficultyWeight, 2)))).floor();
    }
    // Change the status as the card is matured.
    if (newDaysBetweenReviews >= ProviderConstant.maturePeriod ) {
      try {
        debugPrint("vocab becomes matured.");
        // obtain the vocab
        Vocab vocab = await readVocab(oldFlashcard.vid);
        // Set a new state to Status.matured
        vocab.status = Status.matured;
        // upload to the vocab table in the database
        await updateVocab(vocab);
        // trigger stat log
        await triggerStatLog();
      } catch(e) { debugPrint(e.toString() + "failure in reviseFlashcard"); }
    } else if (newDaysBetweenReviews < ProviderConstant.maturePeriod && oldFlashcard.daysBetweenReview > ProviderConstant.maturePeriod) {
      try {
      debugPrint("vocab returned back to learning state.");
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
    return await updateFlashcard(Flashcard(vid: oldFlashcard.vid, fid: oldFlashcard.fid, dateLastReviewed: DateTime.now(), daysBetweenReview: newDaysBetweenReviews, difficulty: newDifficulty, overdue: percentOverdue));
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
      res = await db.rawQuery(
          '''
        SELECT COUNT (*)
        FROM $vocabTableName
        WHERE "status" = 1
        '''
      );
      int learningCount = Sqflite.firstIntValue(res);
      res = await db.rawQuery(
          '''
        SELECT COUNT (*)
        FROM $vocabTableName
        WHERE "status" = 2
        '''
      );
      int maturedCount = Sqflite.firstIntValue(res);

      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      // TODO:: create a stat instance
      Stat stat = Stat(logDate: date, trackingCount: trackingCount, learningCount: learningCount, maturedCount: maturedCount);
      // TODO:: insert to Stat
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

  Future<List<Stat>> getUserStatistics() async
  {
    List<Map<String, dynamic>> response;
    try {
      final db = await database;

      // TODO:: create an optimize one which could remove the outdated Stat entries, as a result, only the latest stats remains.
      // TODO:: Clear the outdated log
      // TODO:: Return the list of stat


      // Unoptimized
      response = await db.rawQuery(
        '''
        SELECT sid, logDate, trackingCount, learningCount, maturedCount
        FROM (SELECT sid, logDate, trackingCount, learningCount, maturedCount
              FROM $statisticTableName
              ORDER BY trackingCount, learningCount, maturedCount) as orderStat
        GROUP BY logDate
        '''
      );
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

  // Terminology: Ready vocab is the vocab that is ready to be prepared as a Flashcard
  Future<List<Vocab>> getReadyVocab(int threshold) async
  {
    List<Map<String, dynamic>> response;
    try {
      final db = await database;
      // TODO:: implement the wordFreq exceeds user defined wordfreq as well
      response = await db.query(vocabTableName, columns: null, where: "status = ?, trackFreq > ?", whereArgs: [Status.tracked.index, threshold]);
    } catch(e) { debugPrint( e.toString() + "getReadyVocab failure"); response = null;}
    return response != null ? response.map((item) => Vocab.fromJson(item)).toList() : null;
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
    Vocab vocab = await readVocab(vid);
    Flashcard flashcard = await readFlashcard(vid);
    FlashcardBundle flashcardBundle = (flashcard != null ?
      FlashcardBundle(
          fid: flashcard.fid,
          dateLastReviewed: flashcard.dateLastReviewed,
          daysBetweenReview: flashcard.daysBetweenReview,
          overdue: flashcard.overdue,
          difficulty: flashcard.difficulty
      ) : null
    );

    // Special operation need to loop to create each step by step
    List<Definition> definitions = await readDefinition(vid);
    // for each definition, find its examples and pronunciation, assign to the definition bundle
    List<DefinitionBundle> definitionsBundle = [];
    if(definitions.isNotEmpty){
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
              pronunciationsBundle: pronunciationsBundle.isNotEmpty ? pronunciationsBundle : null,
              examplesBundle: examplesBundle.isNotEmpty ? examplesBundle : null,
            )
        );
      }
    }

   return VocabBundle(
     vid: vocab.vid,
     word: vocab.word,
     imageUrl: vocab.imageUrl,
     wordFreq: vocab.wordFreq,
     trackFreq: vocab.trackFreq,
     status: vocab.status,
     flashcardBundle: flashcardBundle,
     definitionsBundle: definitionsBundle.isNotEmpty ? definitionsBundle : null,
   );
  }

  Future<void> dropDatabase() async {
    try {
      Directory dbDirectory = await getApplicationDocumentsDirectory();
      print(dbDirectory.toString());
      String dbPath = join(dbDirectory.path, dbName);
      final db = await database;
      await db.close();
      await deleteDatabase(dbPath);
    } catch(e) { debugPrint("Delete Database Error\n" + e.toString());}
  }
}
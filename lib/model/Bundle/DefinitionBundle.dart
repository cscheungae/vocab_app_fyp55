import 'package:vocab_app_fyp55/model/Bundle/ExampleBundle.dart';
import 'package:vocab_app_fyp55/model/Bundle/PronunciationBundle.dart';

class DefinitionBundle
{
  //Field
  int did;
  String pos;
  String defineText;
  List<PronunciationBundle> pronunciationsBundle;
  List<ExampleBundle> examplesBundle;

  DefinitionBundle({ this.did, this.pos, this.defineText, this.pronunciationsBundle, this.examplesBundle });
}
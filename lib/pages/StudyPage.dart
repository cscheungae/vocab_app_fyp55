import 'dart:ui';

import 'package:toast/toast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:vocab_app_fyp55/components/DefinitionBlock.dart';
import 'package:vocab_app_fyp55/components/NoYesButtons.dart';
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/res/theme.dart' as CustomTheme;
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';

class StudyPage extends StatefulWidget {
  //Constructor
  StudyPage({Key key}) : super(key: key);

  @override
  _StudyPage createState() => _StudyPage();
}

class _StudyPage extends State<StudyPage> with TickerProviderStateMixin {
  ///controller and animation
  AnimationController animeController;
  Animation fadeAnimation;

  //State related to vocab
  List<Vocab> _vocabList;
  int _studyIndex = -1;
  VocabBundle vb;

  //State related to presntation layer
  double rating = 0;
  bool showBlur = true;
  bool showRating = false;
  bool showAnimation = true;

  @override
  void initState() {
    super.initState();
    animeController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    fadeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(animeController);
  }

  @override
  void dispose() {
    animeController.dispose();
    super.dispose();
  }

  //initialize the vocab list
  Future<List<Vocab>> initVocabCardList({forceUpdate = false}) async {
    try {
      if (_vocabList == null || forceUpdate == true ){
        _vocabList = await DatabaseProvider.instance.getStudyVocabs(50);
        _vocabList = _vocabList ?? {};
      }
    } catch (exception) {
      print("Failure in getting vocab");
      _vocabList = [];
    }
    return _vocabList;
  }

  Future<VocabBundle> getvocabBundle(int index) async =>
      await DatabaseProvider.instance
          .readVocabBundle(this._vocabList[index].vid);

  /// Move to next vocab page
  /// [value] - how much steps to jump
  Future<void> gotoNextStudyVocabPage({int value = 1}) async {
    if ( _vocabList == null || _vocabList.length == 0 ){
      setState(() {
        this._studyIndex = -1;
        this.vb = null;
        this.showAnimation = true;
        this.showRating = false;
        this.showBlur = true;
        this.rating = 0;
      });
    } else if (_studyIndex + value >= _vocabList.length) {
      Toast.show("There is no more vocabulary available to study", context);
    } else if (_studyIndex + value < 0) {
      Toast.show("This already is the first vocabulary", context);
    } else {
      this._studyIndex += value;
      this.vb = await getvocabBundle(this._studyIndex);
      setState(() {
        this.showAnimation = true;
        this.showRating = false;
        this.showBlur = true;
        this.rating = 0;
      });
    }
  }

  /// Submit ranking, AND move to next vocab page
  Future<void> submitRanking(int vid, double rating) async {
    try {
      /* Update Scheduling Time */
      var flashcard = await DatabaseProvider.instance.readFlashcard(vid);
      await DatabaseProvider.instance.reviseFlashcard(flashcard, rating);
      this._vocabList.removeAt(this._studyIndex);
      this._studyIndex--;
      await this.gotoNextStudyVocabPage();
    } catch (exception) {
      Toast.show(
          "Oops! seems like something is wrong when submitting your rating",
          context);
      print(exception);
    }
  }

  //Start Page of The App
  Widget buildStartPage() {
    return ListView(
      children: <Widget>[
        SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20.0),
            child: RichText(
              maxLines: 3,
              text: TextSpan(children: [
                TextSpan(
                  text: "Word that will be tested are as follows:",
                  style: TextStyle(fontSize: 18.0),
                ),
              ]),
            ),
          ),
        ),

        //Vocabulary
        FutureBuilder<List<Vocab>>(
          future: initVocabCardList(),
          builder: ( context, AsyncSnapshot<List<Vocab>> snapshot ){
            if ( snapshot.hasData )
            {
              //No Vocabulary
              if (  _vocabList.length == 0 ){
                return Container(
                  child: Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image(image: AssetImage("assets/empty.png"), fit: BoxFit.contain, ),
                    ),
                    Text("Seems like everything's done! Great job!!"),
                  ],),
                );
              }
              else return 
              Container(
                child: Tags(
                  itemCount: _vocabList.length,
                  columns: 4,
                  itemBuilder: (position){
                    return ItemTags(
                      index: position,
                      title: _vocabList[position].word,
                      textStyle: TextStyle(fontSize: 18),
                      pressEnabled: false,
                    );
                  },
                )
              );
            } else if ( snapshot.hasError ){
              return Container(child: Text("Problem in loading the words", style: TextStyle(color: Colors.red),),);
            }
            else return  Container();
          }
        ), 
      ],
    );
  }

  Widget buildStudyVocabPage(VocabBundle vb) {
    List<Widget> list = <Widget>[
      SafeArea(child: Text("")),

      //Image
      Stack(
        children: <Widget>[
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            child: vb.getImage(),
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 1000),
            opacity: showBlur ? 1.0 : 0.0,
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: GestureDetector(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey.withOpacity(0.1),
                      child: Text(
                        (showBlur)
                            ? "want a hint? Click to show the image"
                            : "",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    this.showAnimation = false;
                    this.showBlur = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    ];

    List<Widget> descriptions =
        (vb.definitionsBundle == null || vb.definitionsBundle.isEmpty)
            ? [
                Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image(
                    image: AssetImage("assets/empty.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    child: Text("Seem like no definition for this word!")),
              ]
            : vb.definitionsBundle.map((context) {
                return ExpansionTile(
                  title: Text("Definition"),
                  initiallyExpanded: true,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: new DefinitionBlock(
                        header: "Meaning",
                        body: context.defineText ?? "",
                        initiallyExpanded: false,
                      ),
                    ),
                    (context.examplesBundle.length > 0)
                        ? Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: new DefinitionBlock(
                              header: "Example 1",
                              body: context.examplesBundle[0].sentence,
                              initiallyExpanded: false,
                            ),
                          )
                        : Container(),
                    (context.examplesBundle.length > 1)
                        ? Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: new DefinitionBlock(
                              header: "Example 2",
                              body: context.examplesBundle[1].sentence,
                              initiallyExpanded: false,
                            ),
                          )
                        : Container(),
                    (context.examplesBundle.length > 2)
                        ? Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: new DefinitionBlock(
                              header: "Example 3",
                              body: context.examplesBundle[2].sentence,
                              initiallyExpanded: false,
                            ),
                          )
                        : Container(),
                  ],
                );
              }).toList();

    list.addAll(descriptions);

    return ListView(
      children: list,
    );
  }

  Widget buildStudyVocabAppBar(VocabBundle vb) {
    return AppBar(
      title: Text(
        vb.word,
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      elevation: 2,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        SizedBox(
          width: 50,
          child: RaisedButton(
              color: Colors.transparent,
              elevation: 0,
              child: Icon(Icons.arrow_back),
              onPressed: () async {
                await this.gotoNextStudyVocabPage(value: -1);
              }),
        ),
        SizedBox(
          width: 50,
          child: RaisedButton(
              color: Colors.transparent,
              elevation: 0,
              child: Icon(
                Icons.arrow_forward,
              ),
              onPressed: () async {
                await this.gotoNextStudyVocabPage();
              }),
        ),
      ],
    );
  }

  Widget buildStartBottomBar() {
    return buildButton("Refresh", "Start", () async {
      await initVocabCardList(forceUpdate: true);
      Toast.show("Refreshed!", context);
      setState(() {});
    }, () async {
      await this.gotoNextStudyVocabPage();
    });
  }

  Widget buildStudyVocabBottomBar(VocabBundle vb) {
    return buildButton("I forgot...", "I know this word!", () async {
      this.rating = 0;
      await submitRanking(vb.vid, this.rating);
    }, () {
      setState(() {
        this.showAnimation = false;
        this.showRating = true;
      });
    });
  }

  Widget buildStudyStarRatingBar(VocabBundle vb) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Text(
              "How well do you remember?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
                //fix overflow of Star Rating by taking variable space on the list of stars
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SmoothStarRating(
                    allowHalfRating: false,
                    onRatingChanged: (v) {
                      setState(() {
                        this.rating = v;
                      });
                    },
                    starCount: 5,
                    size: 40,
                    rating: rating,
                    filledIconData: Icons.blur_off,
                    halfFilledIconData: Icons.blur_on,
                    color: CustomTheme.WHITE,
                    borderColor: CustomTheme.WHITE,
                    spacing: 0.0),
                RaisedButton(
                    child: Text("Submit"),
                    onPressed: () async {
                      await submitRanking(vb.vid, this.rating);
                    }),
              ],
            )),
          ],
        ));
  }

  //Function for Wrapping Animation to certain widget
  //know that the animation will also be instantly triggered
  //unless animation is set to false
  Widget buildFadeAnimatedPage(Widget child) {
    if (animeController != null) animeController.dispose();
    animeController = new AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((dur) {
      animeController.forward();
    });

    if (!this.showAnimation)
      return child;
    else
      return FadeTransition(
        opacity: animeController,
        child: child,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: (this._studyIndex < 0) ? null : buildStudyVocabAppBar(this.vb),
      body: (this._studyIndex < 0)
          ? this.buildStartPage()
          : this.buildFadeAnimatedPage(this.buildStudyVocabPage(this.vb)),
      bottomNavigationBar: AnimatedContainer(
        height: 70,
        duration: Duration(milliseconds: 400),
        child: (this._studyIndex < 0)
            ? this.buildStartBottomBar()
            : ((this.showRating)
                ? this.buildStudyStarRatingBar(this.vb)
                : this.buildStudyVocabBottomBar(this.vb)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_dictionary/src/domain/models/word.dart';

import '../../bloc/definition/definition_bloc.dart';
import '../../bloc/radio_toggle/radio_toggle_bloc.dart';
import '../../bloc/validate/validate_cubit.dart';
import '../../bloc/word/word_bloc.dart';
import '../../common/widgets.dart';
import '../../constant/functions.dart';
import '../add_page/widgets/radio_name_button.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';

class EditWordScreen extends StatefulWidget {
  const EditWordScreen({super.key});

  @override
  State<EditWordScreen> createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  late RadioToggleBloc radioToggleBloc;
  late DefinitionBloc definitionBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _secMeaningController;
  late TextEditingController _mainMeaningController;
  late TextEditingController _mainExampleController;

  late LanguageMode mode;
  late Word wordData;
  
  List<String> secDefs = [];
  List<String> mainDefs = [];
  List<String> mainExample = [];
  @override
  void initState() {
    _titleController = TextEditingController();
    _secMeaningController = TextEditingController();
    _mainMeaningController = TextEditingController();
    _mainExampleController = TextEditingController();
    _titleController.addListener(() =>
        context.read<ValidateCubit>().isEmptyValidate(_titleController.text));
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _secMeaningController.dispose();
    _mainMeaningController.dispose();
    _mainExampleController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setValue();
  }

  void setValue() {
    radioToggleBloc = context.read<RadioToggleBloc>();
    definitionBloc = context.read<DefinitionBloc>();
    mode = context.read<WordBloc>().state.mode;
    String id = ModalRoute.of(context)?.settings.arguments as String;
    wordData = context.read<WordBloc>().fetchWordByIdEvent(id);
    _titleController.text = wordData.title;
    secDefs.addAll(wordData.secMeaning);
    mainDefs.addAll(wordData.mainMeaning);
    mainExample.addAll(wordData.mainExample);
    definitionBloc.add(
      AddDefsEvent(faDefs: secDefs, enDefs: mainDefs, mainExample: mainExample),
    );
    radioToggleBloc.add(
      SetToggleEvent(
        nounToggle: wordData.noun,
        adjectiveToggle: wordData.adj,
        adverbToggle: wordData.adverb,
        verbToggle: wordData.verb,
        phrasesToggle: wordData.phrases,
      ),
    );
  }

  void saveWord() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Word editedWord = Word(
      id: wordData.id,
      noun: radioToggleBloc.state.nounToggle,
      adj: radioToggleBloc.state.adjectiveToggle,
      adverb: radioToggleBloc.state.adverbToggle,
      verb: radioToggleBloc.state.verbToggle,
      phrases: radioToggleBloc.state.phrasesToggle,
      title: _titleController.text.trim(),
      secMeaning: definitionBloc.state.secDefs,
      mainMeaning: definitionBloc.state.mainDefs,
      mainExample: definitionBloc.state.mainExample,
    );
    context
        .read<WordBloc>()
        .add(UpdateWordEvent(updatedWord: editedWord, id: editedWord.id));
    Navigator.pop(context);
  }

  void addToSecDef() {
    if (_secMeaningController.text.trim().isNotEmpty) {
      definitionBloc
          .add(AddToSecDefsEvent(faDef: _secMeaningController.text.trim()));
      _secMeaningController.clear();
    }
  }

  void addToMainExample() {
    if (_mainExampleController.text.trim().isNotEmpty) {
      definitionBloc.add(
          AddToMainExEvent(mainExample: _mainExampleController.text.trim()));
      _mainExampleController.clear();
    }
  }

  void removeFromMainExample(int index) {
    definitionBloc.add(RemoveFromMainExEvent(index: index));
  }

  void addToMainDef() {
    if (_mainMeaningController.text.trim().isNotEmpty) {
      definitionBloc
          .add(AddToMainDefsEvent(enDef: _mainMeaningController.text.trim()));
      _mainMeaningController.clear();
    }
  }

  void removeFromSecDef(int index) {
    definitionBloc.add(RemoveFromSecDefEvent(index: index));
  }

  void removeFromMainDef(int index) {
    definitionBloc.add(RemoveFromMainDefEvent(index: index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.grey.shade100,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(200, 40),
            backgroundColor: ColorManager.primary,
            shape: StadiumBorder(),
          ),
          onPressed: saveWord,
          child: Text(
            AppStrings.save,
            style: TextStyle(fontSize: 17, color: ColorManager.white),
          )),
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.06,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.1),
                        child: TextFormField(
                          controller: _titleController,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return AppStrings.notEmpty;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(fontSize: 14),
                            hintText: AppStrings.word,
                            errorText:
                                context.watch<ValidateCubit>().state.isValid
                                    ? null
                                    : AppStrings.notEmpty,
                          ),
                        ),
                      ),
        
                      BlocBuilder<RadioToggleBloc, RadioToggleState>(
                        builder: (context, state) {
                          return SizedBox(
                            height: constraints.maxWidth >= 450
                                ? constraints.maxHeight * 0.18
                                : constraints.maxHeight * 0.14,
                            child: GridView(
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          constraints.maxWidth >= 450 ? 5 : 3,
                                      childAspectRatio: 3.5),
                              children: [
                                RadioNameButton(
                                  val: state.nounToggle,
                                  name: AppStrings.noun,
                                  function: (_) {
                                    radioToggleBloc.add(NounToggleEvent());
                                  },
                                ),
                                RadioNameButton(
                                  val: state.adjectiveToggle,
                                  name: AppStrings.adjective,
                                  function: (_) {
                                    radioToggleBloc.add(AdjToggleEvent());
                                  },
                                ),
                                RadioNameButton(
                                  val: state.adverbToggle,
                                  name: AppStrings.adverb,
                                  function: (_) {
                                    radioToggleBloc.add(AdverbToggleEvent());
                                  },
                                ),
                                RadioNameButton(
                                  val: state.verbToggle,
                                  name: AppStrings.verb,
                                  function: (_) {
                                    radioToggleBloc.add(VerbToggleEvent());
                                  },
                                ),
                                RadioNameButton(
                                  val: state.phrasesToggle,
                                  name: AppStrings.phrases,
                                  function: (_) {
                                    radioToggleBloc.add(PhrasesToggleEvent());
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
        
                      /// Second definition textfield
        
                      customTextFormField(
                        constraints,
                        getDefText(mode).set(Order.second),
                        TextDirection.rtl,
                        _secMeaningController,
                        addToSecDef,
                      ),
        
                      /// List of second definition
                      BlocBuilder<DefinitionBloc, DefinitionState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: constraints.maxWidth >= 450
                                  ? constraints.maxHeight * 0.09
                                  : constraints.maxHeight * 0.06,
                              width: constraints.maxWidth,
                              child: state.secDefs.isEmpty
                                  ? Center(
                                      child: Text(getEmptyDefText(mode).set(Order.second)),
                                    )
                                  : Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListView.builder(
                                        // shrinkWrap: true,
                                        itemCount: state.secDefs.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => defItem(
                                          index,
                                          state.secDefs,
                                          TextDirection.rtl,
                                          () => removeFromSecDef(index),
                                        ),
                                      )),
                            ),
                          );
                        },
                      ),
        
                      /// Main definition textfield
                      customTextFormField(
                        constraints,
                        getDefText(mode).set(Order.main),
                        TextDirection.ltr,
                        _mainMeaningController,
                        addToMainDef,
                      ),
        
                      /// List of main Definition
                      BlocBuilder<DefinitionBloc, DefinitionState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: constraints.maxWidth >= 450
                                  ? constraints.maxHeight * 0.09
                                  : constraints.maxHeight * 0.06,
                              child: state.mainDefs.isEmpty
                                  ? Center(
                                      child: Text(
                                        getEmptyDefText(mode).set(Order.main),
                                      ),
                                    )
                                  : Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: ListView.builder(
                                        itemCount: state.mainDefs.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => defItem(
                                          index,
                                          state.mainDefs,
                                          TextDirection.ltr,
                                          () => removeFromMainDef(index),
                                        ),
                                      )),
                            ),
                          );
                        },
                      ),
        
                      /// Main example textfield
                      customTextFormField(
                        constraints,
                        AppStrings.example,
                        TextDirection.ltr,
                        _mainExampleController,
                        addToMainExample,
                      ),
        
                      /// List of main example
                      BlocBuilder<DefinitionBloc, DefinitionState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: constraints.maxHeight * 0.06,
                              child: state.mainExample.isEmpty
                                  ? const Center(
                                      child: Text(
                                        AppStrings.addExample,
                                      ),
                                    )
                                  : Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: ListView.builder(
                                        itemCount: state.mainExample.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => defItem(
                                          index,
                                          state.mainExample,
                                          TextDirection.ltr,
                                          () => removeFromMainExample(index),
                                        ),
                                      )),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

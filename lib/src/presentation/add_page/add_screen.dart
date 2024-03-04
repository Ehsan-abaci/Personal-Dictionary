import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_dictionary/src/bloc/radio_toggle/radio_toggle_bloc.dart';
import 'package:your_dictionary/src/bloc/word/word_bloc.dart';
import 'package:your_dictionary/src/constant/functions.dart';
import 'package:your_dictionary/src/domain/models/word.dart';
import 'package:your_dictionary/src/presentation/add_page/widgets/radio_name_button.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';
import 'package:your_dictionary/src/presentation/resources/strings_manager.dart';

import '../../bloc/definition/definition_bloc.dart';
import '../../bloc/validate/validate_cubit.dart';
import '../../common/widgets.dart';

class AddScreen extends StatefulWidget {
  AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> with TickerProviderStateMixin {
  late RadioToggleBloc radioToggleBloc;
  late DefinitionBloc definitionBloc;

  Word newWord = Word(
    title: "",
    secMeaning: [],
    mainMeaning: [],
    mainExample: [],
  );

  late TextEditingController _titleController;
  late TextEditingController _secMeaningController;
  late TextEditingController _mainMeaningController;
  late TextEditingController _mainExampleController;
  late LanguageMode mode;
  void saveWord() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    newWord = newWord.copyWith(
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
    context.read<WordBloc>().add(AddWordEvent(wordData: newWord));
    Navigator.pop(context);
  }

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
  void didChangeDependencies() {
    radioToggleBloc = context.read<RadioToggleBloc>();
    definitionBloc = context.read<DefinitionBloc>();
    mode = context.read<WordBloc>().state.mode;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _secMeaningController.dispose();
    _mainMeaningController.dispose();
    _mainExampleController.dispose();
    super.dispose();
  }

  void addToSecDef() {
    if (_secMeaningController.text.trim().isNotEmpty) {
      definitionBloc
          .add(AddToSecDefsEvent(faDef: _secMeaningController.text.trim()));
      _secMeaningController.clear();
    }
  }

  void addToMainDef() {
    if (_mainMeaningController.text.trim().isNotEmpty) {
      definitionBloc
          .add(AddToMainDefsEvent(enDef: _mainMeaningController.text.trim()));
      _mainMeaningController.clear();
    }
  }

  void addToMainExample() {
    if (_mainExampleController.text.trim().isNotEmpty) {
      definitionBloc.add(
          AddToMainExEvent(mainExample: _mainExampleController.text.trim()));
      _mainExampleController.clear();
    }
  }

  void removeFromSecDef(int index) {
    definitionBloc.add(RemoveFromSecDefEvent(index: index));
  }

  void removeFromMainDef(int index) {
    definitionBloc.add(RemoveFromMainDefEvent(index: index));
  }

  void removeFromMainExample(int index) {
    definitionBloc.add(RemoveFromMainExEvent(index: index));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                          keyboardType: TextInputType.name,
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
                                    context
                                        .read<RadioToggleBloc>()
                                        .add(NounToggleEvent());
                                  },
                                ),
                                RadioNameButton(
                                  val: state.adjectiveToggle,
                                  name: AppStrings.adjective,
                                  function: (_) {
                                    context
                                        .read<RadioToggleBloc>()
                                        .add(AdjToggleEvent());
                                  },
                                ),
                                RadioNameButton(
                                  val: state.adverbToggle,
                                  name: AppStrings.adverb,
                                  function: (_) {
                                    context
                                        .read<RadioToggleBloc>()
                                        .add(AdverbToggleEvent());
                                  },
                                ),
                                RadioNameButton(
                                  val: state.verbToggle,
                                  name: AppStrings.verb,
                                  function: (_) {
                                    context
                                        .read<RadioToggleBloc>()
                                        .add(VerbToggleEvent());
                                  },
                                ),
                                RadioNameButton(
                                  val: state.phrasesToggle,
                                  name: AppStrings.phrases,
                                  function: (_) {
                                    context
                                        .read<RadioToggleBloc>()
                                        .add(PhrasesToggleEvent());
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
                              height: constraints.maxHeight * 0.06,
                              width: constraints.maxWidth,
                              child: state.secDefs.isEmpty
                                  ? Center(
                                      child: Text(getAddDefText(mode).set(Order.second)),
                                    )
                                  : Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListView.builder(
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
                              height: constraints.maxHeight * 0.06,
                              child: state.mainDefs.isEmpty
                                  ? Center(
                                      child: Text(getAddDefText(mode).set(Order.main)),
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

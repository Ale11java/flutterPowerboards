// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/auth_storage.dart';
import '../short_uuid/short_uuid.dart';
import '../timu_api/timu_api.dart';
import 'auth_model.dart';
import 'text.dart';

String formatNounUrl(String id) {
  return '/api/graph/core:powerboard/$id';
}

String parseMeetingCode(String code) {
  if (code.contains('#')) {
    return code.substring(code.indexOf('#') + 1);
  } else {
    return code;
  }
}

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.validator,
    this.autofocus = false,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
  });

  final TextInputAction textInputAction;
  final bool autofocus;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0XFFED6464),
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0XFFED6464),
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFAC95FF),
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFFFFFF),
          ),
          borderRadius: BorderRadius.circular(23.0),
        ),
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(maxHeight: 46),
      ),
    );
  }
}

class UsernameField extends StatefulWidget {
  const UsernameField(this.onSubmit, {super.key});

  final Function(String, String) onSubmit;

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();

  @override
  dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    submitForm() {
      if (formKey.currentState!.validate()) {
        widget.onSubmit(firstNameCtrl.text, lastNameCtrl.text);
      }
    }

    onFieldSubmitted(value) {
      submitForm();
    }

    return Form(
      key: formKey,
      child: Column(children: <Widget>[
        InputTextField(
          autofocus: true,
          controller: firstNameCtrl,
          hintText: 'Enter first name',
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
          onFieldSubmitted: onFieldSubmitted,
        ),
        const SizedBox(height: 20),
        InputTextField(
          controller: lastNameCtrl,
          hintText: 'Enter last name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
          onFieldSubmitted: onFieldSubmitted,
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size.fromHeight(42),
          ),
          child: Text('CONTINUE',
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: Color(0xFF484575),
              ))),
        ),
      ]),
    );
  }
}

typedef JoinRedirectBuilder = String Function({required String eventID});

String defaultJoinRedirectBuilder({required String eventID}) {
  return Uri(
      path: '/in-app-page',
      queryParameters: {'nounUrl': formatNounUrl(eventID)}).toString();
}

class JoinPage extends StatefulWidget {
  const JoinPage(
      {super.key, this.redirectBuilder = defaultJoinRedirectBuilder});

  final JoinRedirectBuilder redirectBuilder;

  @override
  State<JoinPage> createState() => _JoinPageState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _JoinPageState extends State<JoinPage> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controller.dispose();

    super.dispose();
  }

  Future<void> createNew() async {
    final noun = await TimuApiProvider.of(context)
        .api
        .create(type: 'core:powerboard', data: {
      'name': 'Untitled',
      'acl': 'private',
      'localAclAdditions': {
        'claims': [
          {
            'name': 'type',
            'role': 'core:reader',
            'value': 'core:guest',
          },
          {
            'name': 'type',
            'role': 'core:reader',
            'value': 'core:user',
          }
        ]
      }
    });
    context.go(widget.redirectBuilder(eventID: fromUUID(noun.id)));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    submitForm() async {
      if (formKey.currentState!.validate()) {
        context.go(
            widget.redirectBuilder(eventID: parseMeetingCode(controller.text)));
      }
    }

    late Widget bottomButton;
    final auth = AuthModel.of(context);

    if (auth.activeAccount != null) {
      bottomButton = FilledButton(
        onPressed: createNew,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size.fromHeight(42),
        ),
        child: Text('NEW POWERBOARD',
            style: GoogleFonts.inter(
                textStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: Color(0XFF484575),
            ))),
      );
    } else {
      bottomButton = FilledButton(
        onPressed: () => redirectToLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size.fromHeight(42),
        ),
        child: Text('LOGIN',
            style: GoogleFonts.inter(
                textStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: Color(0XFF484575),
            ))),
      );
    }

    var footer = (auth.activeAccount != null) ? [const RecentBoardList()] : [];

    return ColoredBox(
      color: const Color(0XFF2F2D57),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const ScreenTitle(text: 'Welcome to Powerboards'),
              const SizedBox(height: 16),
              const ScreenSubtitle(
                text: 'Enter a board link or create a new board to continue',
              ),
              const SizedBox(height: 44),
              IntrinsicWidth(
                child: Row(
                  children: [
                    SizedBox(
                      width: 400,
                      child: Form(
                        key: formKey,
                        child: InputTextField(
                          autofocus: true,
                          controller: controller,
                          hintText: 'Enter URL or Code',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter invite URL';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            submitForm();
                          },
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8),
                            child: FilledButton(
                              onPressed: submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'JOIN NOW',
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: Color(0XFF484575),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(width: 400, child: bottomButton),
              ...footer
            ],
          ),
        ),
      ),
    );
  }
}

class RecentBoardList extends StatefulWidget {
  const RecentBoardList({super.key});

  @override
  State createState() => _RecentBoardListState();
}

class _RecentBoardListState extends State<RecentBoardList> {
  List<Widget> recentBoards = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final api = TimuApiProvider.of(context);
    final profile = MyProfileProvider.of(context).profile;

    api.api
        .list(['core:activity'],
            container: profile.url,
            sort: ['updatedAt desc'],
            filter: "target_type:'core:powerboard' AND kind:'core:view'")
        .then((list) {
      setState(() {
        recentBoards = [];
        if (list.isEmpty) {
          return;
        }
        for (final o in list) {
          final item = MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onSecondaryTapDown: (details) {
                final offset = details.globalPosition;

                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      offset.dx,
                      offset.dy,
                      MediaQuery.of(context).size.width - offset.dx,
                      MediaQuery.of(context).size.height - offset.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        onTap: () async {
                          await api.api.delete(object: o);
                          setState(() {
                            final index = list.indexOf(o);
                            list.removeAt(index);
                            recentBoards.removeAt(index);
                          });
                        },
                        child: const Text('Remove from history'),
                      )
                    ]);
              },
              onTap: () {
                context.go("/editor?id=" +
                    fromUUID(o.rawData["target"] != null
                        ? o.rawData["target"].split("/")[4]
                        : ""));
              },
              child: Container(
                width: 400,
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Color.fromARGB(30, 230, 200, 255)))),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: Text(o.rawData["target_name"],
                    style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 15)),
              ),
            ),
          );

          recentBoards.add(item);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: Column(children: [
      const SizedBox(height: 30),
      Container(
        width: 400,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Recently Viewed',
          style: TextStyle(
              color: Color.fromRGBO(171, 148, 255, 1),
              decoration: TextDecoration.none,
              fontSize: 15),
        ),
      ),
      ...recentBoards
    ]));
  }
}

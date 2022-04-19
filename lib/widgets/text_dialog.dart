import 'package:flutter/material.dart';

class TextDialog extends StatefulWidget {
  final Text title;
  final Text? message;
  final String submitButtonText;
  final TextStyle submitButtonTextStyle;
  final bool force;
  final Function(TextDialogResponse) onSubmitted;
  final Function? onCancelled;
  final bool showCloseButton;

  const TextDialog({
    Key? key,
    required this.title,
    this.message,
    required this.submitButtonText,
    this.submitButtonTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
    this.force = false,
    required this.onSubmitted,
    this.onCancelled,
    this.showCloseButton = true,
  }) : super(key: key);

  @override
  State<TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<TextDialog> {
  final _textController = TextEditingController();
  TextDialogResponse? _response;

  @override
  void initState() {
    super.initState();
    _response = TextDialogResponse(text: '');
  }

  @override
  Widget build(BuildContext context) {
    final _content = Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                widget.title,
                const SizedBox(height: 15),
                widget.message ?? Container(),
                const SizedBox(height: 10),
                TextField(
                  controller: _textController,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 5,
                  // decoration: InputDecoration(
                  //   hintText: widget.commentHint,
                  // ),
                  onChanged: (str) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      suffixIcon: _textController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _textController.clear();
                                setState(() {});
                              },
                            )),
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: Text(
                    widget.submitButtonText,
                    style: widget.submitButtonTextStyle,
                  ),
                  onPressed: _textController.text == ''
                      ? null
                      : () {
                          if (!widget.force) Navigator.pop(context);
                          _response!.text = _textController.text;
                          print(_response);
                          widget.onSubmitted.call(_response!);
                        },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        if (!widget.force &&
            widget.onCancelled != null &&
            widget.showCloseButton) ...[
          IconButton(
            icon: const Icon(Icons.close, size: 24),
            onPressed: () {
              Navigator.pop(context);
              widget.onCancelled!.call();
            },
          ),
        ],
      ],
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: _content,
    );
  }
}

class TextDialogResponse {
  String text;
  TextDialogResponse({this.text = ''});
}

import 'package:astrology_app/views/base/custom_textField.dart';
import 'package:flutter/material.dart';

class AutocompleteLocationField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Future<List<String>> Function(String) getSuggestions;
  final void Function(String)? onSelected;

  const AutocompleteLocationField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.getSuggestions,
    this.validator,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        return await getSuggestions(textEditingValue.text);
      },
      onSelected: (String selection) {
        controller.text = selection;
        if (onSelected != null) {
          onSelected!(selection);
        }
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        // Sync our external controller when the internal one changes
        textEditingController.addListener(() {
          if (controller.text != textEditingController.text) {
             controller.text = textEditingController.text;
          }
        });
        
        // Ensure any pre-filled value is pushed to the internal controller
        if (textEditingController.text.isEmpty && controller.text.isNotEmpty) {
           textEditingController.text = controller.text;
        }

        return CustomTextFromField(
          controller: textEditingController,
          hintText: hintText,
          focusNode: focusNode,
          onFieldSubmitted: (v) => onFieldSubmitted(),
          validator: validator,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            elevation: 4.0,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: MediaQuery.of(context).size.width - 40,
              constraints: const BoxConstraints(maxHeight: 250), // Prevent taking too much space
              decoration: BoxDecoration(
                color: const Color(0xFF262A40),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        option,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

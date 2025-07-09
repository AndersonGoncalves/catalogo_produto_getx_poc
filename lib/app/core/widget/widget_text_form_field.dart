import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetTextFormField extends StatelessWidget {
  final String labelText;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final int? maxLines;
  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final bool? border;
  final bool? removerLinha;
  final Color? fillColor;
  final double? borderRadius;
  final bool? isDense;
  final bool? obscureText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final Function()? prefixIconOnPressed;
  final Function()? suffixIconOnPressed;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;

  const WidgetTextFormField({
    required this.labelText,
    required this.keyboardType,
    required this.textInputAction,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.maxLines = 1,
    this.initialValue,
    this.controller,
    this.hintText,
    this.border = false,
    this.removerLinha = false,
    this.fillColor,
    this.borderRadius = 5.0,
    this.isDense = true,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    /*textCapitalization: sentences: primeira palavra com a letra maiúscula, words: todas palavras com a letra maiúscula, characters: tudo maiúsculo, none: nada maiúsculo*/
    this.textCapitalization = TextCapitalization.sentences,
    this.prefixIconOnPressed,
    this.suffixIconOnPressed,
    this.inputFormatters,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: border == true ? 10 : 0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textCapitalization: textCapitalization,
        enabled: enabled,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: textAlign,
        decoration: InputDecoration(
          fillColor: fillColor ?? Colors.white,
          filled: border == true,
          isDense: isDense,
          hintText: hintText,
          hintStyle: const TextStyle(fontStyle: FontStyle.italic),
          labelText: labelText == '' ? null : labelText,
          prefixIcon: prefixIcon == null
              ? null
              : IconButton(icon: prefixIcon!, onPressed: prefixIconOnPressed),
          suffixIcon: suffixIcon == null
              ? null
              : IconButton(icon: suffixIcon!, onPressed: suffixIconOnPressed),
          border: border == true
              ? OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF000000),
                    width: 1.0,
                    style: BorderStyle.solid,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius!),
                  ),
                  gapPadding: 4.0,
                )
              : removerLinha == true
              ? InputBorder.none
              : null,
        ),
        keyboardType: keyboardType == TextInputType.number
            ? const TextInputType.numberWithOptions(decimal: true, signed: true)
            : keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        maxLines: maxLines,
        initialValue: initialValue,
        controller: controller,
        obscureText: obscureText ?? false,
        inputFormatters: inputFormatters,
        validator: validator,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}

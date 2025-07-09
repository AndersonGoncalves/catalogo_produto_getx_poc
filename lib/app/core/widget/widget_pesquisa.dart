import 'package:flutter/material.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_text_form_field.dart';

class WidgetPesquisa extends StatefulWidget {
  final String? hintText;
  final Color? fillColor;
  final double? radius;
  final Icon? suffixIcon;
  final void Function(String)? onSearch;
  final Function()? suffixIconOnPressed;

  const WidgetPesquisa({
    this.hintText = 'Digite sua pesquisa',
    this.fillColor,
    this.radius = 20,
    this.suffixIcon,
    this.onSearch,
    this.suffixIconOnPressed,
    super.key,
  });

  @override
  State<WidgetPesquisa> createState() => _WidgetPesquisaState();
}

class _WidgetPesquisaState extends State<WidgetPesquisa> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3, left: 5, right: 5),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius!)),
          color: widget.fillColor ?? Colors.white,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 11),
              child: const Icon(Icons.search, size: 20, color: Colors.black54),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 40,
                top: Theme.of(context).platform == TargetPlatform.windows
                    ? 8
                    : 4,
              ),
              child: WidgetTextFormField(
                labelText: '',
                hintText: widget.hintText,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                border: false,
                removerLinha: true,
                isDense: true,
                fillColor: widget.fillColor ?? Colors.white,
                onChanged: widget.onSearch,
                suffixIcon: widget.suffixIcon,
                suffixIconOnPressed: widget.suffixIconOnPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

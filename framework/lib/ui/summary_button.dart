import 'package:flutter/material.dart';

class SummaryButton extends StatelessWidget {
  const SummaryButton({
    super.key,
    required this.graphic,
    required this.title,
    required this.body,
  });
  final Widget graphic;
  final Widget title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            // child: SummaryGraphic(graphic: graphic),
            child: graphic,
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: title,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryButtonTitleText extends StatelessWidget {
  const SummaryButtonTitleText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class SummaryButtonBodyText extends StatelessWidget {
  const SummaryButtonBodyText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class SummaryGraphic extends StatelessWidget {
  const SummaryGraphic({
    super.key,
    required this.graphic,
  });
  final Widget graphic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}

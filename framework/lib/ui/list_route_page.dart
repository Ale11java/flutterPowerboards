import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListRoutesPage extends StatelessWidget {
  const ListRoutesPage({
    super.key,
    required this.routes,
  });

  final List<GoRoute> routes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Wrap(
        spacing: 10,
        children: routes.map((GoRoute route) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => context.push(route.path),
                child: Text(route.name ?? route.path),
              ),
            ),
          );
        }).toList(),
      ),
    ));
  }
}

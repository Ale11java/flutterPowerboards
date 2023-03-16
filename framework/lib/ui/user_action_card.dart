import 'package:flutter/material.dart';

import '../timu_api/websocket.dart';

extension IterableExt<T> on Iterable<T> {
  Iterable<T> superJoin(T separator) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return [];
    }

    final l = [iterator.current];
    while (iterator.moveNext()) {
      l..add(separator)..add(iterator.current);
    }

    return l;
  }
}

final List<Client> clients = [
    Client(
      id: 'Josef',
      metadata: {},
      profile: {
        'id': 'josef',
        'firstName': 'Josef',
        'lastName': 'Kohout',
      }),
    Client(
      id: 'brandon',
      metadata: {},
      profile: {
        'id': 'brandon',
        'firstName': 'Brandon',
        'lastName': 'Bethke',
      }),
  ];

class UserActionCard extends StatelessWidget {
  const UserActionCard({super.key, required this.userName});

  final String userName;

  @override
  build(BuildContext context) {
    return Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(builder: (BuildContext context) {
          return Positioned(
            top: 100,
            right: 100,
            child: Column(children: clients
                .map<Widget>((client) => _ClientWidget(client))
                .superJoin(const SizedBox(height: 10))
                .toList(growable: false)),
            );
        }),
      ],
    );
  }
}

class _ClientWidget extends StatelessWidget {
  const _ClientWidget(this.client);

  final Client client;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0XFF2F2D57),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x3a000000),
                blurRadius: 20,
                offset: Offset(0, 2),
              ),
            ]),
        child: Row(
          children: [
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${client.profile['firstName']} ${client.profile['lastName']}' ,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Colors.white),
                ),
                const Text('Is waiting in lobby...',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Colors.white),
                )
              ]
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
            children: [
              FilledButton(
                onPressed: () => print('approve'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(42),
                ),
                child: const Text('APPROVE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Color(0xFF484575),
                  )),
              ),
                FilledButton(
                  onPressed: () => print('deny'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(42),
                  ),
                  child: const Text('DENY',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: Color(0xFF484575),
                    )
                ),
              ),
            ]),
          ),
        ]),
      );
  }
}

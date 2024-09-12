import 'package:flutter/material.dart';

import '../../models/upgrade.dart';

class UpgradeTile extends StatelessWidget {
  final Upgrade upgrade;
  final VoidCallback onPurchase;

  const UpgradeTile({Key? key, required this.upgrade, required this.onPurchase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(upgrade.name),
      subtitle: Text('Cost: ${upgrade.cost}, CPS: ${upgrade.cps}'),
      trailing: upgrade.isPurchased
          ? const Icon(Icons.check_circle, color: Colors.green)
          : ElevatedButton(
              onPressed: onPurchase,
              child: const Text('Buy'),
            ),
    );
  }
}

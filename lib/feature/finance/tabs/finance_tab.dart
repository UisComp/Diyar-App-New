import 'package:diyar_app/feature/finance/view/widgets/unit_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinanceTab extends StatelessWidget {
  final List<String> units;
  const FinanceTab({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: units.length,
      itemBuilder: (context, index) {
        return UnitExpansionTile(unitName: units[index]);
      },
    );
  }
}

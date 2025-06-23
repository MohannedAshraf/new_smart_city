import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ApplyService extends StatelessWidget {
  const ApplyService({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: const Text(
            'لتجديد رخصة القيادة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}

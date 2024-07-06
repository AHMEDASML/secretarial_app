import 'package:secretarial_app/global/components/text_app_slime.dart';
import 'package:secretarial_app/global/data/local/cache_helper.dart';
import 'package:secretarial_app/global/utils/color_app.dart';
import 'package:flutter/material.dart';

class AccountDataWidget extends StatelessWidget {
  const AccountDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade700,
            child: textSlime(
                text: 'A',
                color: ColorManager.white,
                sizeFont: 30,
                fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textSlime(
                  text: CacheHelper.getData(key: 'name') ?? '',
                fontWeight: FontWeight.w600,
                color: ColorManager.black,
                sizeFont: 16),
            textSlime(
                text: 'ID : ${CacheHelper.getData(key: 'id')?? ''}',
                fontWeight: FontWeight.w400,
                color: ColorManager.grey2,
                sizeFont: 14),
          ],
        )
      ],
    );
  }
}

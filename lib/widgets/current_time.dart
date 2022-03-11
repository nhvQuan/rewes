import 'package:flutter/material.dart';
import 'package:rewes/constants/app_colors.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:rewes/constants/app_colors.dart';

// class PriceText extends StatelessWidget {
//   const PriceText({
//     Key? key,

//     this.color = AppColors.secondaryAccent,
//   }) : super(key: key);

//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     var colorToUse =
//         MediaQuery.of(context).platformBrightness == Brightness.light
//             ? color
//             : AppColors.primaryWhiteColor;
//     return Row(
//       children: [
//         Text(
//           '$datetime',
//           style: Theme.of(context)
//               .textTheme
//               .headline3!
//               .copyWith(color: colorToUse),
//         ),

//       ],
//     );
//   }
// }

class Current_time extends StatefulWidget {
  const Current_time({Key? key, this.color = AppColors.secondaryAccent})
      : super(key: key);
  final Color color;

  @override
  _Current_timeState createState() => _Current_timeState();
}

class _Current_timeState extends State<Current_time> {
  // void Update_time() {
  //   do {
  //     setState(() {
  //       datetime = DateTime.now().toString();
  //     });
  //   } while (true);
  // }

  get color => null;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorToUse =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? color
            : AppColors.primaryWhiteColor;
    return Container(
      child: Row(
        children: [
          Container(
            child: DigitalClock(
              digitAnimationStyle: Curves.elasticInOut,
              is24HourTimeFormat: true,
              areaDecoration: BoxDecoration(color: AppColors.secondaryAccent),
              hourMinuteDigitTextStyle:
                  TextStyle(color: AppColors.primaryWhiteColor, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

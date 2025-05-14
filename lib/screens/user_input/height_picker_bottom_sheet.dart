import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../widgets/app_widget.dart';

class HeightPickerBottomSheet extends StatefulWidget {
  final double initialCmValue;
  final Function(double heightInCm) onHeightSelected;

  const HeightPickerBottomSheet({
    super.key,
    required this.initialCmValue,
    required this.onHeightSelected,
  });

  @override
  State<HeightPickerBottomSheet> createState() =>
      _HeightPickerBottomSheetState();
}

class _HeightPickerBottomSheetState extends State<HeightPickerBottomSheet> {
  bool isCm = true;
  int cm = 170;

  int feet = 5;
  int inches = 7;

  @override
  void initState() {
    super.initState();
    cm = widget.initialCmValue.round();

    // Convert cm to ft + in for initial value
    final totalInches = (widget.initialCmValue / 2.54).round();
    feet = totalInches ~/ 12;
    inches = totalInches % 12;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(isCm ? "Height in cm" : "Height in ft/in",style: Theme.of(context).textTheme.bodyLarge,),
                value: isCm,
                onChanged: (val) => setState(() => isCm = val),
                activeColor: AppColors.buttonGradient,
                activeTrackColor: AppColors.white,
              ),
              SizedBox(height: 30),
              Expanded(child: isCm ? _buildCmPicker() : _buildFeetInchPicker()),
              SizedBox(height: 30),
              buildAppButton(
                context,
                label: AppStrings.selectHeight,
                icon: Icons.height,
                callback: () {
                  double finalHeightInCm =
                      isCm ? cm.toDouble() : ((feet * 12 + inches) * 2.54);
                  widget.onHeightSelected(finalHeightInCm);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCmPicker() {
    return CupertinoPicker(
      itemExtent: 40,
      scrollController: FixedExtentScrollController(initialItem: cm - 50),
      onSelectedItemChanged: (val) => cm = val + 50,
      children: List.generate(251, (index) => Center(child: Text("${index + 50} cm",style: Theme.of(context).textTheme.bodyMedium,))),
    );
  }

  Widget _buildFeetInchPicker() {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(
              initialItem: feet - 1,
            ),
            onSelectedItemChanged: (val) => feet = val + 1,
            children: List.generate(8, (index) => Center(child: Text("${index + 1} ft",style: Theme.of(context).textTheme.bodyMedium,))),
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(initialItem: inches),
            onSelectedItemChanged: (val) => inches = val,
            children: List.generate(12, (index) => Center(child: Text("$index in",style: Theme.of(context).textTheme.bodyMedium,))),
          ),
        ),
      ],
    );
  }
}

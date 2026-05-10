import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaddingData {
  final TextPaddingSet textPaddingSet;

  PaddingData({
      required this.textPaddingSet,
  });
}

class PaddingNotifier extends StateNotifier<PaddingData> {
  PaddingNotifier() : super(
    PaddingData(
      // textStyleSet: TextStyleSet()
      textPaddingSet: TextPaddingSet(),
    )
  );

void updateTextPaddingSet(Map<String, dynamic> newPaddingSet) {
    state = PaddingData(
      textPaddingSet: state.textPaddingSet.updateFromJson(newPaddingSet),
    );
  }



}

final paddingProvider = StateNotifierProvider<PaddingNotifier, PaddingData>((ref) {
  return PaddingNotifier();
});

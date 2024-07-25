import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZekrCounterCubit extends Cubit<ZekrCounterState> {
  ZekrCounterCubit() : super(ZekrCounterInitial());
  static ZekrCounterCubit get(context) => BlocProvider.of(context);
  List<Map<String, dynamic>> morning = Azkar().morning;
  final List<int> downLoops = [];
  final List<int> upLoops = [];
  void fillLoops() {
    for (int i = 0; i < morning.length; i++) {
      downLoops.add(morning[i]['loop']);
      upLoops.add(0);
    }
  }

  void updateCurrentStep(index) {
    if (downLoops[index] > 0) {
      downLoops[index] -= 1;
      upLoops[index] += 1;

      emit(ZekrCounterUpdateSteps());
    }
  }
}

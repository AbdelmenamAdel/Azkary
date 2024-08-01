import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_state.dart';
import 'package:azkar/features/Azkar/manager/model/zekr_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZekrCounterCubit extends Cubit<ZekrCounterState> {
  ZekrCounterCubit() : super(ZekrCounterInitial());
  static ZekrCounterCubit get(context) => BlocProvider.of(context);
// ! ############### Morning Azkar Counter Cubit ###############
  List<Map<String, dynamic>> morning = Azkar().morning;
  List<int> downMorningLoops = [];
  List<int> upMorningLoops = [];
  void fillMorningLoops() {
    for (int i = 0; i < morning.length; i++) {
      downMorningLoops.add(morning[i]['loop']);
      upMorningLoops.add(0);
    }
  }

  void updateMorningCurrentStep(index) {
    if (downMorningLoops[index] > 0) {
      downMorningLoops[index] -= 1;
      upMorningLoops[index] += 1;
      emit(ZekrCounterUpdateSteps());
    }
  }

// ! ############### Night Azkar Counter Cubit ###############
  List<ZekrModel> night = Azkar().night;
  List<int> downNightLoops = [];
  List<int> upNightLoops = [];
  void fillNightLoops() {
    for (int i = 0; i < night.length; i++) {
      downNightLoops.add(night[i].loop!);
      upNightLoops.add(0);
    }
  }

  void updateNightCurrentStep(index) {
    if (downNightLoops[index] > 0) {
      downNightLoops[index] -= 1;
      upNightLoops[index] += 1;

      emit(ZekrCounterUpdateSteps());
    }
  }

// ! ############### After Pray Azkar Counter Cubit ###############
  List<ZekrModel> afterPray = Azkar().afterPray;
  List<int> downAfterPrayLoops = [];
  List<int> upAfterPrayLoops = [];
  void fillAfterPrayLoops() {
    for (int i = 0; i < afterPray.length; i++) {
      downAfterPrayLoops.add(afterPray[i].loop!);
      upAfterPrayLoops.add(0);
    }
  }

  void updateAfterPrayCurrentStep(index) {
    if (downAfterPrayLoops[index] > 0) {
      downAfterPrayLoops[index] -= 1;
      upAfterPrayLoops[index] += 1;
      emit(ZekrCounterUpdateSteps());
    }
  }

// ! ############### Sleeping Azkar Counter Cubit ###############
  List<ZekrModel> sleeping = Azkar().sleeping;
  List<int> downSleepingLoops = [];
  List<int> upSleepingLoops = [];
  void fillSleepingLoops() {
    for (int i = 0; i < sleeping.length; i++) {
      downSleepingLoops.add(sleeping[i].loop!);
      upSleepingLoops.add(0);
    }
  }

  void updateSleepingCurrentStep(index) {
    if (downSleepingLoops[index] > 0) {
      downSleepingLoops[index] -= 1;
      upSleepingLoops[index] += 1;

      emit(ZekrCounterUpdateSteps());
    }
  }

// ! ############### Goame3Eldo3a Azkar Counter Cubit ###############
  List<ZekrModel> goame3Eldo3a = Azkar().goame3Eldo3a;
  List<int> downGoame3Eldo3aLoops = [];
  List<int> upGoame3Eldo3aLoops = [];
  void fillGoame3Eldo3aLoops() {
    for (int i = 0; i < goame3Eldo3a.length; i++) {
      downGoame3Eldo3aLoops.add(goame3Eldo3a[i].loop!);
      upGoame3Eldo3aLoops.add(0);
    }
  }

  void updateGoame3Eldo3aCurrentStep(index) {
    if (downGoame3Eldo3aLoops[index] > 0) {
      downGoame3Eldo3aLoops[index] -= 1;
      upGoame3Eldo3aLoops[index] += 1;

      emit(ZekrCounterUpdateSteps());
    }
  }
}

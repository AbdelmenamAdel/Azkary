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
  List<int> downafterPrayLoops = [];
  List<int> upafterPrayLoops = [];
  void fillafterPrayLoops() {
    for (int i = 0; i < afterPray.length; i++) {
      downafterPrayLoops.add(afterPray[i].loop!);
      upafterPrayLoops.add(0);
    }
  }

  void updateafterPrayCurrentStep(index) {
    if (downafterPrayLoops[index] > 0) {
      downafterPrayLoops[index] -= 1;
      upafterPrayLoops[index] += 1;

      emit(ZekrCounterUpdateSteps());
    }
  }

// ! ############### Sleeping Azkar Counter Cubit ###############
  List<ZekrModel> sleeping = Azkar().sleeping;
  List<int> downsleepingLoops = [];
  List<int> upsleepingLoops = [];
  void fillsleepingLoops() {
    for (int i = 0; i < sleeping.length; i++) {
      downsleepingLoops.add(sleeping[i].loop!);
      upsleepingLoops.add(0);
    }
  }

  void updatesleepingCurrentStep(index) {
    if (downsleepingLoops[index] > 0) {
      downsleepingLoops[index] -= 1;
      upsleepingLoops[index] += 1;

      emit(ZekrCounterUpdateSteps());
    }
  }

// // ! ############### Roqiah Azkar Counter Cubit ###############
//   List<ZekrModel> roqiah = Azkar().roqiah;
//   List<int> downroqiahLoops = [];
//   List<int> uproqiahLoops = [];
//   void fillroqiahLoops() {
//     for (int i = 0; i < roqiah.length; i++) {
//       downroqiahLoops.add(roqiah[i].loop);
//       uproqiahLoops.add(0);
//     }
//   }

//   void updateroqiahCurrentStep(index) {
//     if (downroqiahLoops[index] > 0) {
//       downroqiahLoops[index] -= 1;
//       uproqiahLoops[index] += 1;

//       emit(ZekrCounterUpdateSteps());
//     }
//   }

// // ! ############### Roqiah Azkar Counter Cubit ###############
//   List<ZekrModel> motafareqah = Azkar().motafareqah;
//   List<int> downmotafareqahLoops = [];
//   List<int> upmotafareqahLoops = [];
//   void fillmotafareqahLoops() {
//     for (int i = 0; i < motafareqah.length; i++) {
//       downmotafareqahLoops.add(motafareqah[i].loop);
//       upmotafareqahLoops.add(0);
//     }
//   }

//   void updatemotafareqahCurrentStep(index) {
//     if (downmotafareqahLoops[index] > 0) {
//       downmotafareqahLoops[index] -= 1;
//       upmotafareqahLoops[index] += 1;

//       emit(ZekrCounterUpdateSteps());
//     }
//   }
}

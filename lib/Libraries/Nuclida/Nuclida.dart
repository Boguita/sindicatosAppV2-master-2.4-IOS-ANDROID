import './DataHandling/NuclidaConstants.dart';
import './Tools/NuclidaCarpenter/NuclidaCarpenter.dart';
import '../Nuclogger/Nuclogger.dart';

class Nuclida {
  Nuclogger nuclogger;
  NuclidaCarpenter carpenter;
  NuclidaConstants constants;

  Nuclida() {
    this.nuclogger = Nuclogger();
    this.carpenter = NuclidaCarpenter();

    //Activate auto dispatch by default
    nuclogger.setAutoDispatch(
      state: true
    );
  }

}
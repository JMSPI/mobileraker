import 'package:flutter/widgets.dart';
import 'package:mobileraker/app/AppSetup.locator.dart';
import 'package:mobileraker/service/MachineService.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';

class PullToRefreshPrinter extends ViewModelBuilderWidget<RefreshPrinterViewModel> {
  final Widget? child;

  const PullToRefreshPrinter({Key? key, required this.child}) : super(key: key);

  @override
  Widget builder(BuildContext context, RefreshPrinterViewModel model, Widget? staticChild) {
    return SmartRefresher(
      controller: model.refreshController,
      onRefresh: model.onRefresh,
      child: child,
    );
  }

  @override
  RefreshPrinterViewModel viewModelBuilder(BuildContext context) => RefreshPrinterViewModel();
}

class RefreshPrinterViewModel extends BaseViewModel {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final _machineService = locator<MachineService>();

  onRefresh() {
    var _printerService =
        _machineService.selectedPrinter.valueOrNull?.printerService;
    var oldPrinter = _printerService?.printerStream.value;
    var subscription;
    subscription = _printerService?.printerStream.stream.listen((event) {
      if (event != oldPrinter) refreshController.refreshCompleted();
      subscription.cancel();
    });
    _printerService?.refreshPrinter();
  }
}

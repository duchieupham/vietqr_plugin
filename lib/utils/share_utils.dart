import 'package:viet_qr_plugin/models/vietqr_widget_dto.dart';
import 'package:viet_qr_plugin/utils/currency_utils.dart';
import 'package:viet_qr_plugin/utils/log.dart';

class ShareUtils {
  const ShareUtils._privateConsrtructor();

  static const ShareUtils _instance = ShareUtils._privateConsrtructor();

  static ShareUtils get instance => _instance;

  String getQRTextShare(VietQRWidgetDTO dto) {
    String result = '';
    try {
      result += '${dto.bankAccount}\n${dto.userBankName}';
      result += '\n${dto.bankShortName} - ${dto.bankName}';
      if (dto.amount.isNotEmpty) {
        result +=
            '\nSố tiền: ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND';
      }
      if (dto.content.isNotEmpty) {
        result += '\nNội dung: ${dto.content}';
      }
      result += '\nBy VietQR VN';
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}

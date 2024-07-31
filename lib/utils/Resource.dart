
import 'package:flutter/cupertino.dart';

import '../Resources/Strings/StringsLocalization.dart';

class Resource {
  BuildContext _context;
  String tagLanguage;

  Resource(this._context,this.tagLanguage);


  StringsLocalization get strings  {
    print('--------------------------------------->>>>>>>>>>>>>'+tagLanguage);
    switch (tagLanguage) {

      case 'ar':
        return ArabicStrings();
      case 'hi':
        return HindiStrings();
      case 'fn':
        return FranchStrings();
      default:
        return EnglishStrings();
    }
  }

  static Resource of(BuildContext context,String s) {
    return Resource(context,s);
  }
}
import 'package:flutter/cupertino.dart';

mixin BaseViewInterface<c>{


  Widget buildContent(BuildContext context,c controller);
  c buildController(BuildContext context);
}
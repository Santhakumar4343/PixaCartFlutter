// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobxStateManagement.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Counter on MobxStateManagementBase, Store {
  late final _$likedIndexAtom =
      Atom(name: 'MobxStateManagementBase.likedIndex', context: context);

  @override
  ObservableList<String> get likedIndex {
    _$likedIndexAtom.reportRead();
    return super.likedIndex;
  }

  @override
  set likedIndex(ObservableList<String> value) {
    _$likedIndexAtom.reportWrite(value, super.likedIndex, () {
      super.likedIndex = value;
    });
  }

  late final _$valAtom =
      Atom(name: 'MobxStateManagementBase.val', context: context);

  @override
  int get val {
    _$valAtom.reportRead();
    return super.val;
  }

  @override
  set val(int value) {
    _$valAtom.reportWrite(value, super.val, () {
      super.val = value;
    });
  }

  late final _$MobxStateManagementBaseActionController =
      ActionController(name: 'MobxStateManagementBase', context: context);

  @override
  void like(String itemId) {
    final _$actionInfo = _$MobxStateManagementBaseActionController.startAction(
        name: 'MobxStateManagementBase.like');
    try {
      return super.like(itemId);
    } finally {
      _$MobxStateManagementBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void disliked(String itemId) {
    final _$actionInfo = _$MobxStateManagementBaseActionController.startAction(
        name: 'MobxStateManagementBase.disliked');
    try {
      return super.disliked(itemId);
    } finally {
      _$MobxStateManagementBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
likedIndex: ${likedIndex},
val: ${val}
    ''';
  }
}

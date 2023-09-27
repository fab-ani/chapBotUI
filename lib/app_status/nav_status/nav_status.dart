import 'package:equatable/equatable.dart';

class NavStatus extends Equatable {
  const NavStatus({this.index = 0});
  final int index;
  NavStatus copyWith({int? index}) {
    return NavStatus(index: index ?? this.index);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

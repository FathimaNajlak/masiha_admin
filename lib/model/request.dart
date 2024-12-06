import 'package:equatable/equatable.dart';

class Request extends Equatable {
  final String id;
  final String name;
  final String category;
  final bool isApproved;

  const Request({
    required this.id,
    required this.name,
    required this.category,
    required this.isApproved,
  });

  @override
  List<Object?> get props => [id, name, category, isApproved];
}

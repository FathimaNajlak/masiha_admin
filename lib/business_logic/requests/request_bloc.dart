import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestInitial()) {
    on<RequestEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

import 'package:equatable/equatable.dart';

const defaultServerFailureMessage =
    'There was an error while loading data from the server.\nPlease try again.';
const defaultCacheFailureMessage =
    'There was an error while loading data from the local cache.\nPlease try again.';
const defaultGeneralFailureMessage =
    'An unknown error occured.\nPlease try again.';

abstract class Failure extends Equatable {
  const Failure({this.message});

  final String? message;

  @override
  List<Object?> get props => [];

  String getMessageOrDefault() {
    if (message != null) return message!;

    switch (runtimeType) {
      case ServerFailure:
        return defaultServerFailureMessage;

      case CacheFailure:
        return defaultCacheFailureMessage;

      default:
        return defaultGeneralFailureMessage;
    }
  }
}

class ServerFailure extends Failure with EquatableMixin {
  const ServerFailure({super.message});
}

class CacheFailure extends Failure with EquatableMixin {
  const CacheFailure({super.message});
}

class FirebaseFailure extends Failure with EquatableMixin {
  const FirebaseFailure({super.message});
}

class GeneralFailure extends Failure with EquatableMixin {
  const GeneralFailure({super.message});
}

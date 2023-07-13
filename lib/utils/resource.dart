// ignore_for_file: constant_identifier_names

class Resource<T> {
  Status status;
  T? data;
  String? errorMessage;

  Resource({
    required this.status,
    required this.data,
    required this.errorMessage,
  });

  static Resource<T> success<T>(T data) {
    return Resource(status: Status.SUCCESS, data: data, errorMessage: null);
  }

  static Resource<T> error<T>(String message) {
    return Resource(status: Status.ERROR, data: null, errorMessage: message);
  }
}

enum Status {
  SUCCESS,
  ERROR,
}

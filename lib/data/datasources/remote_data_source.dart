import 'package:pro_pulse_medical_app/data/repositories/base_repository.dart';

abstract class RemoteDataSource {
  Future<ApiResponse<T>> request<T>();
}

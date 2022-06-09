import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late UploadDPAImageUseCase _useCase;
late DPAVariable resultVariable;
late DPAVariable testVariable;
late DPAProcess testProcess;
late String imageName;
late String base64;
late int byteSizes;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _useCase = UploadDPAImageUseCase(
      repository: _repository,
    );

    testProcess = DPAProcess(
      processName: 'process',
    );

    resultVariable = DPAVariable(
      id: 'result',
      property: DPAVariableProperty(),
    );

    testVariable = DPAVariable(
      id: 'test',
      property: DPAVariableProperty(),
    );

    imageName = 'testImage';
    base64 = 'base64';
    byteSizes = 500;

    when(
      () => _repository.uploadImage(
        process: testProcess,
        variable: testVariable,
        imageName: imageName,
        imageFileSizeBytes: byteSizes,
        imageBase64Data: base64,
      ),
    ).thenAnswer(
      (_) async => resultVariable,
    );
  });

  test('Should return the correct DPAVariable', () async {
    final result = await _useCase(
      imageName: imageName,
      process: testProcess,
      imageBase64Data: base64,
      imageFileSizeBytes: byteSizes,
      variable: testVariable,
    );

    expect(result, resultVariable);

    verify(
      () => _repository.uploadImage(
        process: testProcess,
        variable: testVariable,
        imageName: imageName,
        imageFileSizeBytes: byteSizes,
        imageBase64Data: base64,
      ),
    ).called(1);
  });
}

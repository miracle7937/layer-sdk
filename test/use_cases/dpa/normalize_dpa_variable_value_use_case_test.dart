import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/extensions.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases/dpa/normalize_dpa_variable_value_use_case.dart';

late NormalizeDPAVariableValueUseCase _normalizeDPAVariableValueUseCase;

void main() {
  EquatableConfig.stringify = true;
  setUp(() {
    _normalizeDPAVariableValueUseCase = NormalizeDPAVariableValueUseCase();
  });

  test("Test when shouldUploadFile is true", () {
    final variable = DPAVariable(
      id: "test",
      property: DPAVariableProperty(),
      type: DPAVariableType.image,
    );
    final normalized = _normalizeDPAVariableValueUseCase([variable]);

    expect(variable.value, null);
    expect(variable.value, normalized.first.value);
  });

  test("Test when the value of the DPAVariable is DateTime", () {
    final now = DateTime.now();
    final variable = DPAVariable(
      id: "test",
      property: DPAVariableProperty(),
      type: DPAVariableType.dateTime,
      value: now,
    );

    final convertedNow = now.toDTOString(truncateHours: true);
    final normalized = _normalizeDPAVariableValueUseCase([variable]);

    expect(convertedNow, normalized.first.value);
  });

  test("Test when the value of the DPAVariable is a list of strings", () {
    final list = <String>["1", "2", "3"];
    final variable = DPAVariable(
      id: "test",
      property: DPAVariableProperty(),
      type: DPAVariableType.dropdown,
      value: list,
    );

    final convertedList = list.fold<String>(
      '',
      (prev, value) => prev += (prev.isNotEmpty ? '|' : '') + value,
    );
    final normalized = _normalizeDPAVariableValueUseCase([variable]);
    expect(convertedList, normalized.first.value);
  });

  test("Test when the value of the DPAVariable is a DPALinkData", () {
    final originalText = "Hello there";
    final variable = DPAVariable(
      id: "test",
      property: DPAVariableProperty(),
      type: DPAVariableType.link,
      value: DPALinkData(
        beforeLink: "Hey",
        afterLink: "test",
        link: "google.com",
        originalText: originalText,
      ),
    );

    final normalized = _normalizeDPAVariableValueUseCase([variable]);
    expect(originalText, normalized.first.value);
  });

  test("Test when the value of the DPAVariable is a is - no change", () {
    final originalValue = "Hello there";
    final variable = DPAVariable(
      id: "test",
      property: DPAVariableProperty(),
      type: DPAVariableType.link,
      value: originalValue,
    );

    final normalized = _normalizeDPAVariableValueUseCase([variable]);
    expect(originalValue, normalized.first.value);
  });
}

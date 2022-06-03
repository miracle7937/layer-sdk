import 'package:layer_sdk/data_layer/helpers.dart';
import 'package:test/test.dart';

void main() {
  test('Same values, Same order', () async {
    var value1 = "HW_TOKEN,PIN";
    var value2 = "HW_TOKEN,PIN";
    var result = compareCommaSeparatedElements(value1, value2);
    expect(result, true);
  });

  test('Same values, different order', () async {
    var value1 = "HW_TOKEN,PIN";
    var value2 = "PIN,HW_TOKEN";
    var result = compareCommaSeparatedElements(value1, value2);
    expect(result, true);
  });

  test('different values', () async {
    var value1 = "SOFT_TOKEN,PIN";
    var value2 = "PIN,HW_TOKEN";
    var result = compareCommaSeparatedElements(value1, value2);
    expect(result, false);
  });

  test('same values, different case', () async {
    var value1 = "HW_TOKEN,pin";
    var value2 = "PIN,HW_TOKEN";
    var result = compareCommaSeparatedElements(value1, value2);
    expect(result, true);
  });

  test('incorrect input', () async {
    var value2 = "PIN,HW_TOKEN";
    var result = compareCommaSeparatedElements(null, value2);
    expect(result, false);
  });

  test('different values, no comma', () async {
    var value1 = "PIN";
    var value2 = "PIN,HW_TOKEN";
    var result = compareCommaSeparatedElements(value1, value2);
    expect(result, false);
  });

  test('same values, no comma', () async {
    var value1 = "PIN";
    var value2 = "PIN";
    var result = compareCommaSeparatedElements(value1, value2);
    expect(result, true);
  });
}

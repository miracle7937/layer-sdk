import '../environment.dart';

/// The default configuration that uses V3 test environment.
///
/// It can be used to kick start new projects.
class DefaultEnvironmentConfiguration extends EnvironmentConfiguration {
  /// Creates [DefaultEnvironmentConfiguration].
  ///
  /// The [experienceAppId] parameter is optional,
  /// but needed for apps that use the Experience Studio.
  // TODO: consider creating a default experience in the future
  DefaultEnvironmentConfiguration({
    String? experienceAppId,
  }) : super(
          experienceAppId: experienceAppId,
          baseUrl: 'https://v3test.ubanquity.io',
          defaultToken:
              'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE4MDA2MTI5MDIsIl'
              'VzZXIiOiJpb3MiLCJUeXBlIjoicHVibGljIiwiRGV2aWNlX2lkIjpudWxsfQ.AA'
              'Nm43W9rjdInzJ3C7SExZ6H2lqOPHlM2S8Iy_ZV7uDvPW_-XINCfsJcFsZQPGxUS'
              'Np8e69ykmN73FmXS1Ybxm4G-WR7gVe-UDezIZX1Opdp9rtjLf5MRsKSwtfm55t3'
              '9gd0O1XziVUf2OWbP5LfanbzHRWQfkw6eECZIOBfNtfs5JymzUJNOz1KaK0mFux'
              'U9JnewbABMz6nNwFh9aBlJXNeFbFjrg812ZbFFA5jLfbwUFAvLxWE7lR19Qzz17'
              'wFocblMQzzs6ecEbEQxLNWT2GveFjKZQr33R9QDRakwh44RYfSn9YSD5L4-Lre0'
              'fbQA2ZWMouzNgPLbulI_lUwSAs1Llgfpn9gOGUh0w07BzGgA97kXGJZs5g0zUYr'
              '6Ij20uwJUfp5MDNCsFPHO96IWyVxnphGG59ax2ABOC2Z7_qOm-Nu5QSeVJpfgQD'
              'pPtQU0s5thOBQ9IlSBU7iqDMX0dzwf6c8fMHhdhpvtwA7Woew9aJFoLBnTZNfL0'
              '37_mEzug4t1651U_8wi3zusuIuH-WjykZAnNfTnF2bLmdTMs9uek5gz5CXt1Wyc'
              'SQHgjXvKN-CXNI6w84Kfd_nskmbQHc4cst8nWghlDS78DQ5x2Cou7agPUW5Z94P'
              'FGIQAcqPWgyOygzfvGoGdL1u2rOstSTCazMQ_WCyiyFKA8qP6g',
        );
}

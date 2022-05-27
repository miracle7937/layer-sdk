/// The Data Processing Agreement (DPA) Library.
///
/// Contains widgets to facilitate the use of the DPA on applications.
///
/// The [DPAFlow] is the main widget. Using it in conjunction with a
/// [DPAProcessCubit] will add the complete DPA flow to your app, even allowing
/// for customization of certain parts of it.
///
/// The [DPAVariablesList] creates each widget based on a [DPAVariable] and
/// allows for the customization of those.
///
/// Beyond that, we have default widgets for the buttons, headers and
/// process steps, all of them also customizable.
///
/// {@category DPA}
library dpa;

export 'widgets/buttons/dpa_back_button.dart';
export 'widgets/buttons/dpa_cancel_button.dart';
export 'widgets/buttons/dpa_continue_button.dart';
export 'widgets/dpa_flow.dart';
export 'widgets/dpa_variables_list.dart';
export 'widgets/dropdowns/dpa_dropdown.dart';
export 'widgets/headers/dpa_header.dart';
export 'widgets/headers/dpa_popup_header.dart';
export 'widgets/images/dpa_step_image.dart';
export 'widgets/steps/dpa_line_step.dart';
export 'widgets/steps/dpa_numbered_steps.dart';
export 'widgets/switches/dpa_switch.dart';
export 'widgets/texts/dpa_task_description.dart';
export 'widgets/texts/dpa_task_name.dart';
export 'widgets/texts/dpa_text.dart';
export 'widgets/upload/dpa_file_upload.dart';

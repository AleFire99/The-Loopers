/*
 * FlexibleJoint_Template_Test1_data.c
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "FlexibleJoint_Template_Test1".
 *
 * Model version              : 1.67
 * Simulink Coder version : 9.2 (R2019b) 18-Jul-2019
 * C source code generated on : Fri Mar  3 13:19:50 2023
 *
 * Target selection: quarc_win64.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "FlexibleJoint_Template_Test1.h"
#include "FlexibleJoint_Template_Test1_private.h"

/* Block parameters (default storage) */
P_FlexibleJoint_Template_Test_T FlexibleJoint_Template_Test1_P = {
  /* Mask Parameter: Encoders_clock
   * Referenced by: '<Root>/Encoders'
   */
  0,

  /* Mask Parameter: Encoders_channels
   * Referenced by: '<Root>/Encoders'
   */
  { 0U, 1U },

  /* Mask Parameter: Voltage_channels
   * Referenced by: '<Root>/Voltage'
   */
  0U,

  /* Mask Parameter: Encoders_samples_in_buffer
   * Referenced by: '<Root>/Encoders'
   */
  500U,

  /* Expression: set_other_outputs_at_terminate
   * Referenced by: '<Root>/HIL Initialize'
   */
  0.0,

  /* Expression: set_other_outputs_at_switch_out
   * Referenced by: '<Root>/HIL Initialize'
   */
  0.0,

  /* Expression: final_analog_outputs
   * Referenced by: '<Root>/HIL Initialize'
   */
  0.0,

  /* Expression: final_pwm_outputs
   * Referenced by: '<Root>/HIL Initialize'
   */
  0.0,

  /* Expression: 6
   * Referenced by: '<Root>/Pulse Generator'
   */
  6.0,

  /* Computed Parameter: PulseGenerator_Period
   * Referenced by: '<Root>/Pulse Generator'
   */
  5000.0,

  /* Computed Parameter: PulseGenerator_Duty
   * Referenced by: '<Root>/Pulse Generator'
   */
  2500.0,

  /* Expression: 0
   * Referenced by: '<Root>/Pulse Generator'
   */
  0.0,

  /* Expression: -3
   * Referenced by: '<Root>/Constant'
   */
  -3.0,

  /* Computed Parameter: ToHostFile_Decimation
   * Referenced by: '<Root>/To Host File'
   */
  1U,

  /* Computed Parameter: ToHostFile_BitRate
   * Referenced by: '<Root>/To Host File'
   */
  2000000U,

  /* Computed Parameter: HILInitialize_Active
   * Referenced by: '<Root>/HIL Initialize'
   */
  0,

  /* Computed Parameter: HILInitialize_AOTerminate
   * Referenced by: '<Root>/HIL Initialize'
   */
  1,

  /* Computed Parameter: HILInitialize_AOExit
   * Referenced by: '<Root>/HIL Initialize'
   */
  0,

  /* Computed Parameter: HILInitialize_DOTerminate
   * Referenced by: '<Root>/HIL Initialize'
   */
  1,

  /* Computed Parameter: HILInitialize_DOExit
   * Referenced by: '<Root>/HIL Initialize'
   */
  0,

  /* Computed Parameter: HILInitialize_POTerminate
   * Referenced by: '<Root>/HIL Initialize'
   */
  1,

  /* Computed Parameter: HILInitialize_POExit
   * Referenced by: '<Root>/HIL Initialize'
   */
  0,

  /* Computed Parameter: HILInitialize_DOFinal
   * Referenced by: '<Root>/HIL Initialize'
   */
  1,

  /* Computed Parameter: Encoders_Active
   * Referenced by: '<Root>/Encoders'
   */
  1,

  /* Computed Parameter: Voltage_Active
   * Referenced by: '<Root>/Voltage'
   */
  0,

  /* Expression: file_name_argument
   * Referenced by: '<Root>/To Host File'
   */
  { 100U, 97U, 116U, 97U, 95U, 48U, 51U, 45U, 77U, 97U, 114U, 45U, 50U, 48U, 50U,
    51U, 95U, 49U, 51U, 45U, 49U, 57U, 45U, 52U, 55U, 46U, 109U, 97U, 116U, 0U },

  /* Expression: variable_name_argument
   * Referenced by: '<Root>/To Host File'
   */
  { 100U, 97U, 116U, 97U, 95U, 48U, 51U, 95U, 77U, 97U, 114U, 95U, 50U, 48U, 50U,
    51U, 95U, 49U, 51U, 95U, 49U, 57U, 95U, 52U, 55U, 0U },

  /* Computed Parameter: ToHostFile_FileFormat
   * Referenced by: '<Root>/To Host File'
   */
  2U
};

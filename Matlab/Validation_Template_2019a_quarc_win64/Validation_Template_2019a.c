/*
 * Validation_Template_2019a.c
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Validation_Template_2019a".
 *
 * Model version              : 1.4
 * Simulink Coder version : 9.2 (R2019b) 18-Jul-2019
 * C source code generated on : Mon Mar  6 17:37:48 2023
 *
 * Target selection: quarc_win64.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "Validation_Template_2019a.h"
#include "Validation_Template_2019a_private.h"
#include "Validation_Template_2019a_dt.h"

/* Block signals (default storage) */
B_Validation_Template_2019a_T Validation_Template_2019a_B;

/* Block states (default storage) */
DW_Validation_Template_2019a_T Validation_Template_2019a_DW;

/* Real-time model */
RT_MODEL_Validation_Template__T Validation_Template_2019a_M_;
RT_MODEL_Validation_Template__T *const Validation_Template_2019a_M =
  &Validation_Template_2019a_M_;

/* Model step function */
void Validation_Template_2019a_step(void)
{
  real_T rtb_Clock1;

  /* S-Function (hil_read_encoder_timebase_block): '<Root>/Encoders' */

  /* S-Function Block: Validation_Template_2019a/Encoders (hil_read_encoder_timebase_block) */
  {
    t_error result;
    result = hil_task_read_encoder(Validation_Template_2019a_DW.Encoders_Task, 1,
      &Validation_Template_2019a_DW.Encoders_Buffer[0]);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
    } else {
      Validation_Template_2019a_B.Encoders_o1 =
        Validation_Template_2019a_DW.Encoders_Buffer[0];
      Validation_Template_2019a_B.Encoders_o2 =
        Validation_Template_2019a_DW.Encoders_Buffer[1];
    }
  }

  /* Clock: '<S1>/Clock1' */
  rtb_Clock1 = Validation_Template_2019a_M->Timing.t[0];

  /* Gain: '<S1>/Gain' incorporates:
   *  Constant: '<S1>/deltaFreq'
   *  Constant: '<S1>/targetTime'
   *  Product: '<S1>/Product'
   */
  Validation_Template_2019a_B.Gain = (Validation_Template_2019a_P.ChirpSignal_f2
    - Validation_Template_2019a_P.ChirpSignal_f1) * 6.2831853071795862 /
    Validation_Template_2019a_P.ChirpSignal_T
    * Validation_Template_2019a_P.Gain_Gain;

  /* Trigonometry: '<S1>/Output' incorporates:
   *  Constant: '<S1>/initialFreq'
   *  Product: '<S1>/Product1'
   *  Product: '<S1>/Product2'
   *  Sum: '<S1>/Sum'
   */
  Validation_Template_2019a_B.Output = sin((rtb_Clock1 *
    Validation_Template_2019a_B.Gain + 6.2831853071795862 *
    Validation_Template_2019a_P.ChirpSignal_f1) * rtb_Clock1);

  /* S-Function (hil_write_analog_block): '<Root>/Voltage' */

  /* S-Function Block: Validation_Template_2019a/Voltage (hil_write_analog_block) */
  {
    t_error result;
    result = hil_write_analog(Validation_Template_2019a_DW.HILInitialize_Card,
      &Validation_Template_2019a_P.Voltage_channels, 1,
      &Validation_Template_2019a_B.Output);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
    }
  }

  /* External mode */
  rtExtModeUploadCheckTrigger(2);

  {                                    /* Sample time: [0.0s, 0.0s] */
    rtExtModeUpload(0, (real_T)Validation_Template_2019a_M->Timing.t[0]);
  }

  {                                    /* Sample time: [0.002s, 0.0s] */
    rtExtModeUpload(1, (real_T)(((Validation_Template_2019a_M->Timing.clockTick1
      +Validation_Template_2019a_M->Timing.clockTickH1* 4294967296.0)) * 0.002));
  }

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.0s, 0.0s] */
    if ((rtmGetTFinal(Validation_Template_2019a_M)!=-1) &&
        !((rtmGetTFinal(Validation_Template_2019a_M)-
           Validation_Template_2019a_M->Timing.t[0]) >
          Validation_Template_2019a_M->Timing.t[0] * (DBL_EPSILON))) {
      rtmSetErrorStatus(Validation_Template_2019a_M, "Simulation finished");
    }

    if (rtmGetStopRequested(Validation_Template_2019a_M)) {
      rtmSetErrorStatus(Validation_Template_2019a_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++Validation_Template_2019a_M->Timing.clockTick0)) {
    ++Validation_Template_2019a_M->Timing.clockTickH0;
  }

  Validation_Template_2019a_M->Timing.t[0] =
    Validation_Template_2019a_M->Timing.clockTick0 *
    Validation_Template_2019a_M->Timing.stepSize0 +
    Validation_Template_2019a_M->Timing.clockTickH0 *
    Validation_Template_2019a_M->Timing.stepSize0 * 4294967296.0;

  {
    /* Update absolute timer for sample time: [0.002s, 0.0s] */
    /* The "clockTick1" counts the number of times the code of this task has
     * been executed. The resolution of this integer timer is 0.002, which is the step size
     * of the task. Size of "clockTick1" ensures timer will not overflow during the
     * application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick1 and the high bits
     * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
     */
    Validation_Template_2019a_M->Timing.clockTick1++;
    if (!Validation_Template_2019a_M->Timing.clockTick1) {
      Validation_Template_2019a_M->Timing.clockTickH1++;
    }
  }
}

/* Model initialize function */
void Validation_Template_2019a_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)Validation_Template_2019a_M, 0,
                sizeof(RT_MODEL_Validation_Template__T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&Validation_Template_2019a_M->solverInfo,
                          &Validation_Template_2019a_M->Timing.simTimeStep);
    rtsiSetTPtr(&Validation_Template_2019a_M->solverInfo, &rtmGetTPtr
                (Validation_Template_2019a_M));
    rtsiSetStepSizePtr(&Validation_Template_2019a_M->solverInfo,
                       &Validation_Template_2019a_M->Timing.stepSize0);
    rtsiSetErrorStatusPtr(&Validation_Template_2019a_M->solverInfo,
                          (&rtmGetErrorStatus(Validation_Template_2019a_M)));
    rtsiSetRTModelPtr(&Validation_Template_2019a_M->solverInfo,
                      Validation_Template_2019a_M);
  }

  rtsiSetSimTimeStep(&Validation_Template_2019a_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetSolverName(&Validation_Template_2019a_M->solverInfo,"FixedStepDiscrete");
  rtmSetTPtr(Validation_Template_2019a_M,
             &Validation_Template_2019a_M->Timing.tArray[0]);
  rtmSetTFinal(Validation_Template_2019a_M, 100.0);
  Validation_Template_2019a_M->Timing.stepSize0 = 0.002;

  /* External mode info */
  Validation_Template_2019a_M->Sizes.checksums[0] = (20147455U);
  Validation_Template_2019a_M->Sizes.checksums[1] = (1489281046U);
  Validation_Template_2019a_M->Sizes.checksums[2] = (2597350218U);
  Validation_Template_2019a_M->Sizes.checksums[3] = (4100105836U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    Validation_Template_2019a_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(Validation_Template_2019a_M->extModeInfo,
      &Validation_Template_2019a_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(Validation_Template_2019a_M->extModeInfo,
                        Validation_Template_2019a_M->Sizes.checksums);
    rteiSetTPtr(Validation_Template_2019a_M->extModeInfo, rtmGetTPtr
                (Validation_Template_2019a_M));
  }

  /* block I/O */
  {
    Validation_Template_2019a_B.Encoders_o1 = 0.0;
    Validation_Template_2019a_B.Encoders_o2 = 0.0;
    Validation_Template_2019a_B.Gain = 0.0;
    Validation_Template_2019a_B.Output = 0.0;
  }

  /* states (dwork) */
  (void) memset((void *)&Validation_Template_2019a_DW, 0,
                sizeof(DW_Validation_Template_2019a_T));
  Validation_Template_2019a_DW.HILInitialize_AOVoltages[0] = 0.0;
  Validation_Template_2019a_DW.HILInitialize_AOVoltages[1] = 0.0;

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    Validation_Template_2019a_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 17;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.BTransTable = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.PTransTable = &rtPTransTable;
  }

  /* Start for S-Function (hil_initialize_block): '<Root>/HIL Initialize' */

  /* S-Function Block: Validation_Template_2019a/HIL Initialize (hil_initialize_block) */
  {
    static const t_uint analog_input_channels[2U] = {
      0
      , 1
    };

    static const t_double analog_input_minimums[2U] = {
      -10.0
      , -10.0
    };

    static const t_double analog_input_maximums[2U] = {
      10.0
      , 10.0
    };

    static const t_uint analog_output_channels[2U] = {
      0
      , 1
    };

    static const t_double analog_output_minimums[2U] = {
      -10.0
      , -10.0
    };

    static const t_double analog_output_maximums[2U] = {
      10.0
      , 10.0
    };

    static const t_double initial_analog_outputs[2U] = {
      0.0
      , 0.0
    };

    static const t_uint encoder_input_channels[2U] = {
      0
      , 1
    };

    static const t_encoder_quadrature_mode encoder_quadrature[2U] = {
      ENCODER_QUADRATURE_4X
      , ENCODER_QUADRATURE_4X
    };

    static const t_int32 initial_encoder_counts[2U] = {
      0
      , 0
    };

    t_int result;
    t_boolean is_switching;
    result = hil_open("q2_usb", "0",
                      &Validation_Template_2019a_DW.HILInitialize_Card);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
      return;
    }

    is_switching = false;
    result = hil_set_card_specific_options
      (Validation_Template_2019a_DW.HILInitialize_Card,
       "d0=digital;d1=digital;led=auto;update_rate=normal;decimation=1", 63);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
      return;
    }

    result = hil_watchdog_clear(Validation_Template_2019a_DW.HILInitialize_Card);
    if (result < 0 && result != -QERR_HIL_WATCHDOG_CLEAR) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
      return;
    }

    if (!is_switching) {
      result = hil_set_analog_input_ranges
        (Validation_Template_2019a_DW.HILInitialize_Card, analog_input_channels,
         2U,
         analog_input_minimums, analog_input_maximums);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
        return;
      }
    }

    if (!is_switching) {
      result = hil_set_analog_output_ranges
        (Validation_Template_2019a_DW.HILInitialize_Card, analog_output_channels,
         2U,
         analog_output_minimums, analog_output_maximums);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
        return;
      }
    }

    if (!is_switching) {
      result = hil_write_analog(Validation_Template_2019a_DW.HILInitialize_Card,
        analog_output_channels, 2U, initial_analog_outputs);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
        return;
      }
    }

    if (!is_switching) {
      result = hil_set_encoder_quadrature_mode
        (Validation_Template_2019a_DW.HILInitialize_Card, encoder_input_channels,
         2U, (t_encoder_quadrature_mode *) encoder_quadrature);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
        return;
      }
    }

    if (!is_switching) {
      result = hil_set_encoder_counts
        (Validation_Template_2019a_DW.HILInitialize_Card, encoder_input_channels,
         2U, initial_encoder_counts);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
        return;
      }
    }
  }

  /* Start for S-Function (hil_read_encoder_timebase_block): '<Root>/Encoders' */

  /* S-Function Block: Validation_Template_2019a/Encoders (hil_read_encoder_timebase_block) */
  {
    t_error result;
    result = hil_task_create_encoder_reader
      (Validation_Template_2019a_DW.HILInitialize_Card,
       Validation_Template_2019a_P.Encoders_samples_in_buffer,
       Validation_Template_2019a_P.Encoders_channels, 2,
       &Validation_Template_2019a_DW.Encoders_Task);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
    }
  }
}

/* Model terminate function */
void Validation_Template_2019a_terminate(void)
{
  /* Terminate for S-Function (hil_initialize_block): '<Root>/HIL Initialize' */

  /* S-Function Block: Validation_Template_2019a/HIL Initialize (hil_initialize_block) */
  {
    t_boolean is_switching;
    t_int result;
    t_uint32 num_final_analog_outputs = 0;
    static const t_uint analog_output_channels[2U] = {
      0
      , 1
    };

    hil_task_stop_all(Validation_Template_2019a_DW.HILInitialize_Card);
    hil_monitor_stop_all(Validation_Template_2019a_DW.HILInitialize_Card);
    is_switching = false;
    if ((Validation_Template_2019a_P.HILInitialize_AOTerminate && !is_switching)
        || (Validation_Template_2019a_P.HILInitialize_AOExit && is_switching)) {
      Validation_Template_2019a_DW.HILInitialize_AOVoltages[0] =
        Validation_Template_2019a_P.HILInitialize_AOFinal;
      Validation_Template_2019a_DW.HILInitialize_AOVoltages[1] =
        Validation_Template_2019a_P.HILInitialize_AOFinal;
      num_final_analog_outputs = 2U;
    }

    if (num_final_analog_outputs > 0) {
      result = hil_write_analog(Validation_Template_2019a_DW.HILInitialize_Card,
        analog_output_channels, num_final_analog_outputs,
        &Validation_Template_2019a_DW.HILInitialize_AOVoltages[0]);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(Validation_Template_2019a_M, _rt_error_message);
      }
    }

    hil_task_delete_all(Validation_Template_2019a_DW.HILInitialize_Card);
    hil_monitor_delete_all(Validation_Template_2019a_DW.HILInitialize_Card);
    hil_close(Validation_Template_2019a_DW.HILInitialize_Card);
    Validation_Template_2019a_DW.HILInitialize_Card = NULL;
  }
}

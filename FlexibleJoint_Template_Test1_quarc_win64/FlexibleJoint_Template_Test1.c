/*
 * FlexibleJoint_Template_Test1.c
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
#include "FlexibleJoint_Template_Test1_dt.h"

/* Block signals (default storage) */
B_FlexibleJoint_Template_Test_T FlexibleJoint_Template_Test1_B;

/* Block states (default storage) */
DW_FlexibleJoint_Template_Tes_T FlexibleJoint_Template_Test1_DW;

/* Real-time model */
RT_MODEL_FlexibleJoint_Templa_T FlexibleJoint_Template_Test1_M_;
RT_MODEL_FlexibleJoint_Templa_T *const FlexibleJoint_Template_Test1_M =
  &FlexibleJoint_Template_Test1_M_;

/* Model step function */
void FlexibleJoint_Template_Test1_step(void)
{
  /* local block i/o variables */
  real_T rtb_Encoders_o2;
  real_T rtb_PulseGenerator;

  /* S-Function (hil_read_encoder_timebase_block): '<Root>/Encoders' */

  /* S-Function Block: FlexibleJoint_Template_Test1/Encoders (hil_read_encoder_timebase_block) */
  {
    t_error result;
    result = hil_task_read_encoder(FlexibleJoint_Template_Test1_DW.Encoders_Task,
      1, &FlexibleJoint_Template_Test1_DW.Encoders_Buffer[0]);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
    } else {
      FlexibleJoint_Template_Test1_B.Encoders_o1 =
        FlexibleJoint_Template_Test1_DW.Encoders_Buffer[0];
      rtb_Encoders_o2 = FlexibleJoint_Template_Test1_DW.Encoders_Buffer[1];
    }
  }

  /* DiscretePulseGenerator: '<Root>/Pulse Generator' */
  rtb_PulseGenerator = (FlexibleJoint_Template_Test1_DW.clockTickCounter <
                        FlexibleJoint_Template_Test1_P.PulseGenerator_Duty) &&
    (FlexibleJoint_Template_Test1_DW.clockTickCounter >= 0) ?
    FlexibleJoint_Template_Test1_P.PulseGenerator_Amp : 0.0;
  if (FlexibleJoint_Template_Test1_DW.clockTickCounter >=
      FlexibleJoint_Template_Test1_P.PulseGenerator_Period - 1.0) {
    FlexibleJoint_Template_Test1_DW.clockTickCounter = 0;
  } else {
    FlexibleJoint_Template_Test1_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Pulse Generator' */

  /* Sum: '<Root>/Add' incorporates:
   *  Constant: '<Root>/Constant'
   */
  FlexibleJoint_Template_Test1_B.Add = rtb_PulseGenerator +
    FlexibleJoint_Template_Test1_P.Constant_Value;

  /* S-Function (hil_write_analog_block): '<Root>/Voltage' */

  /* S-Function Block: FlexibleJoint_Template_Test1/Voltage (hil_write_analog_block) */
  {
    t_error result;
    result = hil_write_analog(FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
      &FlexibleJoint_Template_Test1_P.Voltage_channels, 1,
      &FlexibleJoint_Template_Test1_B.Add);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
    }
  }

  /* External mode */
  rtExtModeUploadCheckTrigger(1);

  {                                    /* Sample time: [0.002s, 0.0s] */
    rtExtModeUpload(0, (real_T)FlexibleJoint_Template_Test1_M->Timing.taskTime0);
  }

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.002s, 0.0s] */
    if ((rtmGetTFinal(FlexibleJoint_Template_Test1_M)!=-1) &&
        !((rtmGetTFinal(FlexibleJoint_Template_Test1_M)-
           FlexibleJoint_Template_Test1_M->Timing.taskTime0) >
          FlexibleJoint_Template_Test1_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, "Simulation finished");
    }

    if (rtmGetStopRequested(FlexibleJoint_Template_Test1_M)) {
      rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, "Simulation finished");
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
  if (!(++FlexibleJoint_Template_Test1_M->Timing.clockTick0)) {
    ++FlexibleJoint_Template_Test1_M->Timing.clockTickH0;
  }

  FlexibleJoint_Template_Test1_M->Timing.taskTime0 =
    FlexibleJoint_Template_Test1_M->Timing.clockTick0 *
    FlexibleJoint_Template_Test1_M->Timing.stepSize0 +
    FlexibleJoint_Template_Test1_M->Timing.clockTickH0 *
    FlexibleJoint_Template_Test1_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void FlexibleJoint_Template_Test1_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)FlexibleJoint_Template_Test1_M, 0,
                sizeof(RT_MODEL_FlexibleJoint_Templa_T));
  rtmSetTFinal(FlexibleJoint_Template_Test1_M, 20.0);
  FlexibleJoint_Template_Test1_M->Timing.stepSize0 = 0.002;

  /* External mode info */
  FlexibleJoint_Template_Test1_M->Sizes.checksums[0] = (3074674454U);
  FlexibleJoint_Template_Test1_M->Sizes.checksums[1] = (1266433518U);
  FlexibleJoint_Template_Test1_M->Sizes.checksums[2] = (1680063765U);
  FlexibleJoint_Template_Test1_M->Sizes.checksums[3] = (3758937409U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    FlexibleJoint_Template_Test1_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(FlexibleJoint_Template_Test1_M->extModeInfo,
      &FlexibleJoint_Template_Test1_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(FlexibleJoint_Template_Test1_M->extModeInfo,
                        FlexibleJoint_Template_Test1_M->Sizes.checksums);
    rteiSetTPtr(FlexibleJoint_Template_Test1_M->extModeInfo, rtmGetTPtr
                (FlexibleJoint_Template_Test1_M));
  }

  /* block I/O */
  {
    FlexibleJoint_Template_Test1_B.Encoders_o1 = 0.0;
    FlexibleJoint_Template_Test1_B.Add = 0.0;
  }

  /* states (dwork) */
  (void) memset((void *)&FlexibleJoint_Template_Test1_DW, 0,
                sizeof(DW_FlexibleJoint_Template_Tes_T));
  FlexibleJoint_Template_Test1_DW.HILInitialize_AOVoltages[0] = 0.0;
  FlexibleJoint_Template_Test1_DW.HILInitialize_AOVoltages[1] = 0.0;

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    FlexibleJoint_Template_Test1_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 17;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.BTransTable = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.PTransTable = &rtPTransTable;
  }

  /* Start for S-Function (hil_initialize_block): '<Root>/HIL Initialize' */

  /* S-Function Block: FlexibleJoint_Template_Test1/HIL Initialize (hil_initialize_block) */
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
                      &FlexibleJoint_Template_Test1_DW.HILInitialize_Card);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
      return;
    }

    is_switching = false;
    result = hil_set_card_specific_options
      (FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
       "d0=digital;d1=digital;led=auto;update_rate=normal;decimation=1", 63);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
      return;
    }

    result = hil_watchdog_clear
      (FlexibleJoint_Template_Test1_DW.HILInitialize_Card);
    if (result < 0 && result != -QERR_HIL_WATCHDOG_CLEAR) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
      return;
    }

    if (!is_switching) {
      result = hil_set_analog_input_ranges
        (FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
         analog_input_channels, 2U,
         analog_input_minimums, analog_input_maximums);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
        return;
      }
    }

    if (!is_switching) {
      result = hil_set_analog_output_ranges
        (FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
         analog_output_channels, 2U,
         analog_output_minimums, analog_output_maximums);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
        return;
      }
    }

    if (!is_switching) {
      result = hil_write_analog
        (FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
         analog_output_channels, 2U, initial_analog_outputs);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
        return;
      }
    }

    if (!is_switching) {
      result = hil_set_encoder_quadrature_mode
        (FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
         encoder_input_channels, 2U, (t_encoder_quadrature_mode *)
         encoder_quadrature);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
        return;
      }
    }

    if (!is_switching) {
      result = hil_set_encoder_counts
        (FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
         encoder_input_channels, 2U, initial_encoder_counts);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
        return;
      }
    }
  }

  /* Start for S-Function (hil_read_encoder_timebase_block): '<Root>/Encoders' */

  /* S-Function Block: FlexibleJoint_Template_Test1/Encoders (hil_read_encoder_timebase_block) */
  {
    t_error result;
    result = hil_task_create_encoder_reader
      (FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
       FlexibleJoint_Template_Test1_P.Encoders_samples_in_buffer,
       FlexibleJoint_Template_Test1_P.Encoders_channels, 2,
       &FlexibleJoint_Template_Test1_DW.Encoders_Task);
    if (result < 0) {
      msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
        (_rt_error_message));
      rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
    }
  }

  /* Start for DiscretePulseGenerator: '<Root>/Pulse Generator' */
  FlexibleJoint_Template_Test1_DW.clockTickCounter = 0;
}

/* Model terminate function */
void FlexibleJoint_Template_Test1_terminate(void)
{
  /* Terminate for S-Function (hil_initialize_block): '<Root>/HIL Initialize' */

  /* S-Function Block: FlexibleJoint_Template_Test1/HIL Initialize (hil_initialize_block) */
  {
    t_boolean is_switching;
    t_int result;
    t_uint32 num_final_analog_outputs = 0;
    static const t_uint analog_output_channels[2U] = {
      0
      , 1
    };

    hil_task_stop_all(FlexibleJoint_Template_Test1_DW.HILInitialize_Card);
    hil_monitor_stop_all(FlexibleJoint_Template_Test1_DW.HILInitialize_Card);
    is_switching = false;
    if ((FlexibleJoint_Template_Test1_P.HILInitialize_AOTerminate &&
         !is_switching) || (FlexibleJoint_Template_Test1_P.HILInitialize_AOExit &&
         is_switching)) {
      FlexibleJoint_Template_Test1_DW.HILInitialize_AOVoltages[0] =
        FlexibleJoint_Template_Test1_P.HILInitialize_AOFinal;
      FlexibleJoint_Template_Test1_DW.HILInitialize_AOVoltages[1] =
        FlexibleJoint_Template_Test1_P.HILInitialize_AOFinal;
      num_final_analog_outputs = 2U;
    }

    if (num_final_analog_outputs > 0) {
      result = hil_write_analog
        (FlexibleJoint_Template_Test1_DW.HILInitialize_Card,
         analog_output_channels, num_final_analog_outputs,
         &FlexibleJoint_Template_Test1_DW.HILInitialize_AOVoltages[0]);
      if (result < 0) {
        msg_get_error_messageA(NULL, result, _rt_error_message, sizeof
          (_rt_error_message));
        rtmSetErrorStatus(FlexibleJoint_Template_Test1_M, _rt_error_message);
      }
    }

    hil_task_delete_all(FlexibleJoint_Template_Test1_DW.HILInitialize_Card);
    hil_monitor_delete_all(FlexibleJoint_Template_Test1_DW.HILInitialize_Card);
    hil_close(FlexibleJoint_Template_Test1_DW.HILInitialize_Card);
    FlexibleJoint_Template_Test1_DW.HILInitialize_Card = NULL;
  }
}

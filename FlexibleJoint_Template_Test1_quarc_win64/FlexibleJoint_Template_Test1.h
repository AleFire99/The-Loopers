/*
 * FlexibleJoint_Template_Test1.h
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

#ifndef RTW_HEADER_FlexibleJoint_Template_Test1_h_
#define RTW_HEADER_FlexibleJoint_Template_Test1_h_
#include <float.h>
#include <string.h>
#ifndef FlexibleJoint_Template_Test1_COMMON_INCLUDES_
# define FlexibleJoint_Template_Test1_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_extmode.h"
#include "sysran_types.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "dt_info.h"
#include "ext_work.h"
#include "hil.h"
#include "quanser_messages.h"
#include "quanser_extern.h"
#endif                       /* FlexibleJoint_Template_Test1_COMMON_INCLUDES_ */

#include "FlexibleJoint_Template_Test1_types.h"

/* Shared type includes */
#include "multiword_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWExtModeInfo
# define rtmGetRTWExtModeInfo(rtm)     ((rtm)->extModeInfo)
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetTPtr
# define rtmGetTPtr(rtm)               (&(rtm)->Timing.taskTime0)
#endif

/* Block signals (default storage) */
typedef struct {
  real_T Encoders_o1;                  /* '<Root>/Encoders' */
  real_T Add;                          /* '<Root>/Add' */
} B_FlexibleJoint_Template_Test_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  real_T HILInitialize_AOVoltages[2];  /* '<Root>/HIL Initialize' */
  t_uint64 ToHostFile_PointsWritten;   /* '<Root>/To Host File' */
  t_task Encoders_Task;                /* '<Root>/Encoders' */
  t_card HILInitialize_Card;           /* '<Root>/HIL Initialize' */
  struct {
    void *LoggedData;
  } Scope1_PWORK;                      /* '<Root>/Scope1' */

  void *ToHostFile_PWORK[2];           /* '<Root>/To Host File' */
  void *Voltage_PWORK;                 /* '<Root>/Voltage' */
  int32_T Encoders_Buffer[2];          /* '<Root>/Encoders' */
  int32_T clockTickCounter;            /* '<Root>/Pulse Generator' */
  uint32_T ToHostFile_SamplesCount;    /* '<Root>/To Host File' */
  uint32_T ToHostFile_ArrayNameLength; /* '<Root>/To Host File' */
} DW_FlexibleJoint_Template_Tes_T;

/* Parameters (default storage) */
struct P_FlexibleJoint_Template_Test_T_ {
  int32_T Encoders_clock;              /* Mask Parameter: Encoders_clock
                                        * Referenced by: '<Root>/Encoders'
                                        */
  uint32_T Encoders_channels[2];       /* Mask Parameter: Encoders_channels
                                        * Referenced by: '<Root>/Encoders'
                                        */
  uint32_T Voltage_channels;           /* Mask Parameter: Voltage_channels
                                        * Referenced by: '<Root>/Voltage'
                                        */
  uint32_T Encoders_samples_in_buffer;
                                   /* Mask Parameter: Encoders_samples_in_buffer
                                    * Referenced by: '<Root>/Encoders'
                                    */
  real_T HILInitialize_OOTerminate;/* Expression: set_other_outputs_at_terminate
                                    * Referenced by: '<Root>/HIL Initialize'
                                    */
  real_T HILInitialize_OOExit;    /* Expression: set_other_outputs_at_switch_out
                                   * Referenced by: '<Root>/HIL Initialize'
                                   */
  real_T HILInitialize_AOFinal;        /* Expression: final_analog_outputs
                                        * Referenced by: '<Root>/HIL Initialize'
                                        */
  real_T HILInitialize_POFinal;        /* Expression: final_pwm_outputs
                                        * Referenced by: '<Root>/HIL Initialize'
                                        */
  real_T PulseGenerator_Amp;           /* Expression: 6
                                        * Referenced by: '<Root>/Pulse Generator'
                                        */
  real_T PulseGenerator_Period;     /* Computed Parameter: PulseGenerator_Period
                                     * Referenced by: '<Root>/Pulse Generator'
                                     */
  real_T PulseGenerator_Duty;         /* Computed Parameter: PulseGenerator_Duty
                                       * Referenced by: '<Root>/Pulse Generator'
                                       */
  real_T PulseGenerator_PhaseDelay;    /* Expression: 0
                                        * Referenced by: '<Root>/Pulse Generator'
                                        */
  real_T Constant_Value;               /* Expression: -3
                                        * Referenced by: '<Root>/Constant'
                                        */
  uint32_T ToHostFile_Decimation;   /* Computed Parameter: ToHostFile_Decimation
                                     * Referenced by: '<Root>/To Host File'
                                     */
  uint32_T ToHostFile_BitRate;         /* Computed Parameter: ToHostFile_BitRate
                                        * Referenced by: '<Root>/To Host File'
                                        */
  boolean_T HILInitialize_Active;    /* Computed Parameter: HILInitialize_Active
                                      * Referenced by: '<Root>/HIL Initialize'
                                      */
  boolean_T HILInitialize_AOTerminate;
                                /* Computed Parameter: HILInitialize_AOTerminate
                                 * Referenced by: '<Root>/HIL Initialize'
                                 */
  boolean_T HILInitialize_AOExit;    /* Computed Parameter: HILInitialize_AOExit
                                      * Referenced by: '<Root>/HIL Initialize'
                                      */
  boolean_T HILInitialize_DOTerminate;
                                /* Computed Parameter: HILInitialize_DOTerminate
                                 * Referenced by: '<Root>/HIL Initialize'
                                 */
  boolean_T HILInitialize_DOExit;    /* Computed Parameter: HILInitialize_DOExit
                                      * Referenced by: '<Root>/HIL Initialize'
                                      */
  boolean_T HILInitialize_POTerminate;
                                /* Computed Parameter: HILInitialize_POTerminate
                                 * Referenced by: '<Root>/HIL Initialize'
                                 */
  boolean_T HILInitialize_POExit;    /* Computed Parameter: HILInitialize_POExit
                                      * Referenced by: '<Root>/HIL Initialize'
                                      */
  boolean_T HILInitialize_DOFinal;  /* Computed Parameter: HILInitialize_DOFinal
                                     * Referenced by: '<Root>/HIL Initialize'
                                     */
  boolean_T Encoders_Active;           /* Computed Parameter: Encoders_Active
                                        * Referenced by: '<Root>/Encoders'
                                        */
  boolean_T Voltage_Active;            /* Computed Parameter: Voltage_Active
                                        * Referenced by: '<Root>/Voltage'
                                        */
  uint8_T ToHostFile_file_name[30];    /* Expression: file_name_argument
                                        * Referenced by: '<Root>/To Host File'
                                        */
  uint8_T ToHostFile_VarName[26];      /* Expression: variable_name_argument
                                        * Referenced by: '<Root>/To Host File'
                                        */
  uint8_T ToHostFile_FileFormat;    /* Computed Parameter: ToHostFile_FileFormat
                                     * Referenced by: '<Root>/To Host File'
                                     */
};

/* Real-time Model Data Structure */
struct tag_RTM_FlexibleJoint_Templat_T {
  const char_T *errorStatus;
  RTWExtModeInfo *extModeInfo;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    uint32_T checksums[4];
  } Sizes;

  /*
   * SpecialInfo:
   * The following substructure contains special information
   * related to other components that are dependent on RTW.
   */
  struct {
    const void *mappingInfo;
  } SpecialInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block parameters (default storage) */
extern P_FlexibleJoint_Template_Test_T FlexibleJoint_Template_Test1_P;

/* Block signals (default storage) */
extern B_FlexibleJoint_Template_Test_T FlexibleJoint_Template_Test1_B;

/* Block states (default storage) */
extern DW_FlexibleJoint_Template_Tes_T FlexibleJoint_Template_Test1_DW;

/* Model entry point functions */
extern void FlexibleJoint_Template_Test1_initialize(void);
extern void FlexibleJoint_Template_Test1_step(void);
extern void FlexibleJoint_Template_Test1_terminate(void);

/* Real-time Model object */
extern RT_MODEL_FlexibleJoint_Templa_T *const FlexibleJoint_Template_Test1_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'FlexibleJoint_Template_Test1'
 */
#endif                          /* RTW_HEADER_FlexibleJoint_Template_Test1_h_ */

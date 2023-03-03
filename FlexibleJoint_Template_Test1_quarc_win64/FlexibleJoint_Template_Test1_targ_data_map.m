  function targMap = targDataMap(),

  ;%***********************
  ;% Create Parameter Map *
  ;%***********************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 6;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc paramMap
    ;%
    paramMap.nSections           = nTotSects;
    paramMap.sectIdxOffset       = sectIdxOffset;
      paramMap.sections(nTotSects) = dumSection; %prealloc
    paramMap.nTotData            = -1;
    
    ;%
    ;% Auto data (FlexibleJoint_Template_Test1_P)
    ;%
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_P.Encoders_clock
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(1) = section;
      clear section
      
      section.nData     = 3;
      section.data(3)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_P.Encoders_channels
	  section.data(1).logicalSrcIdx = 1;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_P.Voltage_channels
	  section.data(2).logicalSrcIdx = 2;
	  section.data(2).dtTransOffset = 2;
	
	  ;% FlexibleJoint_Template_Test1_P.Encoders_samples_in_buffer
	  section.data(3).logicalSrcIdx = 3;
	  section.data(3).dtTransOffset = 3;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(2) = section;
      clear section
      
      section.nData     = 9;
      section.data(9)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_OOTerminate
	  section.data(1).logicalSrcIdx = 4;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_OOExit
	  section.data(2).logicalSrcIdx = 5;
	  section.data(2).dtTransOffset = 1;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_AOFinal
	  section.data(3).logicalSrcIdx = 6;
	  section.data(3).dtTransOffset = 2;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_POFinal
	  section.data(4).logicalSrcIdx = 7;
	  section.data(4).dtTransOffset = 3;
	
	  ;% FlexibleJoint_Template_Test1_P.PulseGenerator_Amp
	  section.data(5).logicalSrcIdx = 8;
	  section.data(5).dtTransOffset = 4;
	
	  ;% FlexibleJoint_Template_Test1_P.PulseGenerator_Period
	  section.data(6).logicalSrcIdx = 9;
	  section.data(6).dtTransOffset = 5;
	
	  ;% FlexibleJoint_Template_Test1_P.PulseGenerator_Duty
	  section.data(7).logicalSrcIdx = 10;
	  section.data(7).dtTransOffset = 6;
	
	  ;% FlexibleJoint_Template_Test1_P.PulseGenerator_PhaseDelay
	  section.data(8).logicalSrcIdx = 11;
	  section.data(8).dtTransOffset = 7;
	
	  ;% FlexibleJoint_Template_Test1_P.Constant_Value
	  section.data(9).logicalSrcIdx = 12;
	  section.data(9).dtTransOffset = 8;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(3) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_P.ToHostFile_Decimation
	  section.data(1).logicalSrcIdx = 13;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_P.ToHostFile_BitRate
	  section.data(2).logicalSrcIdx = 14;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(4) = section;
      clear section
      
      section.nData     = 10;
      section.data(10)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_Active
	  section.data(1).logicalSrcIdx = 15;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_AOTerminate
	  section.data(2).logicalSrcIdx = 16;
	  section.data(2).dtTransOffset = 1;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_AOExit
	  section.data(3).logicalSrcIdx = 17;
	  section.data(3).dtTransOffset = 2;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_DOTerminate
	  section.data(4).logicalSrcIdx = 18;
	  section.data(4).dtTransOffset = 3;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_DOExit
	  section.data(5).logicalSrcIdx = 19;
	  section.data(5).dtTransOffset = 4;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_POTerminate
	  section.data(6).logicalSrcIdx = 20;
	  section.data(6).dtTransOffset = 5;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_POExit
	  section.data(7).logicalSrcIdx = 21;
	  section.data(7).dtTransOffset = 6;
	
	  ;% FlexibleJoint_Template_Test1_P.HILInitialize_DOFinal
	  section.data(8).logicalSrcIdx = 22;
	  section.data(8).dtTransOffset = 7;
	
	  ;% FlexibleJoint_Template_Test1_P.Encoders_Active
	  section.data(9).logicalSrcIdx = 23;
	  section.data(9).dtTransOffset = 8;
	
	  ;% FlexibleJoint_Template_Test1_P.Voltage_Active
	  section.data(10).logicalSrcIdx = 24;
	  section.data(10).dtTransOffset = 9;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(5) = section;
      clear section
      
      section.nData     = 3;
      section.data(3)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_P.ToHostFile_file_name
	  section.data(1).logicalSrcIdx = 25;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_P.ToHostFile_VarName
	  section.data(2).logicalSrcIdx = 26;
	  section.data(2).dtTransOffset = 30;
	
	  ;% FlexibleJoint_Template_Test1_P.ToHostFile_FileFormat
	  section.data(3).logicalSrcIdx = 27;
	  section.data(3).dtTransOffset = 56;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(6) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (parameter)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    paramMap.nTotData = nTotData;
    


  ;%**************************
  ;% Create Block Output Map *
  ;%**************************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 1;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc sigMap
    ;%
    sigMap.nSections           = nTotSects;
    sigMap.sectIdxOffset       = sectIdxOffset;
      sigMap.sections(nTotSects) = dumSection; %prealloc
    sigMap.nTotData            = -1;
    
    ;%
    ;% Auto data (FlexibleJoint_Template_Test1_B)
    ;%
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_B.Encoders_o1
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_B.Add
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(1) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (signal)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    sigMap.nTotData = nTotData;
    


  ;%*******************
  ;% Create DWork Map *
  ;%*******************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 7;
    sectIdxOffset = 1;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc dworkMap
    ;%
    dworkMap.nSections           = nTotSects;
    dworkMap.sectIdxOffset       = sectIdxOffset;
      dworkMap.sections(nTotSects) = dumSection; %prealloc
    dworkMap.nTotData            = -1;
    
    ;%
    ;% Auto data (FlexibleJoint_Template_Test1_DW)
    ;%
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_DW.HILInitialize_AOVoltages
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(1) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_DW.ToHostFile_PointsWritten
	  section.data(1).logicalSrcIdx = 1;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(2) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_DW.Encoders_Task
	  section.data(1).logicalSrcIdx = 2;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(3) = section;
      clear section
      
      section.nData     = 1;
      section.data(1)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_DW.HILInitialize_Card
	  section.data(1).logicalSrcIdx = 3;
	  section.data(1).dtTransOffset = 0;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(4) = section;
      clear section
      
      section.nData     = 3;
      section.data(3)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_DW.Scope1_PWORK.LoggedData
	  section.data(1).logicalSrcIdx = 4;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_DW.ToHostFile_PWORK
	  section.data(2).logicalSrcIdx = 5;
	  section.data(2).dtTransOffset = 1;
	
	  ;% FlexibleJoint_Template_Test1_DW.Voltage_PWORK
	  section.data(3).logicalSrcIdx = 6;
	  section.data(3).dtTransOffset = 3;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(5) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_DW.Encoders_Buffer
	  section.data(1).logicalSrcIdx = 7;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_DW.clockTickCounter
	  section.data(2).logicalSrcIdx = 8;
	  section.data(2).dtTransOffset = 2;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(6) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% FlexibleJoint_Template_Test1_DW.ToHostFile_SamplesCount
	  section.data(1).logicalSrcIdx = 9;
	  section.data(1).dtTransOffset = 0;
	
	  ;% FlexibleJoint_Template_Test1_DW.ToHostFile_ArrayNameLength
	  section.data(2).logicalSrcIdx = 10;
	  section.data(2).dtTransOffset = 1;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(7) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (dwork)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    dworkMap.nTotData = nTotData;
    


  ;%
  ;% Add individual maps to base struct.
  ;%

  targMap.paramMap  = paramMap;    
  targMap.signalMap = sigMap;
  targMap.dworkMap  = dworkMap;
  
  ;%
  ;% Add checksums to base struct.
  ;%


  targMap.checksum0 = 3074674454;
  targMap.checksum1 = 1266433518;
  targMap.checksum2 = 1680063765;
  targMap.checksum3 = 3758937409;


GET DATA 
  /TYPE=XLS 
  /FILE='CtrlConstrictionNoise.xls' 
  /SHEET=name 'Sheet1' 
  /CELLRANGE=full 
  /READNAMES=on 
  /ASSUMEDSTRWIDTH=32767. 
EXECUTE. 
DATASET NAME DataSet16 WINDOW=FRONT.

*select cases.
SELECT IF (longestnonvalidbaseline < 250 & longestnonvalidpupil < 900 & insideAOI > 0.1 & aoi_viol? > -1 & Trialnumber > 1). 
EXECUTE.  
*save selected.
SAVE OUTFILE='D:\lasayr\Pupil-SA\E-prime & Matlab data analyzed II\Anonymization\CtrlNoise_constriction_accept.sav' 
  /COMPRESSED. 

*aggregate long form data.
AUTORECODE VARIABLES=Filename 
  /INTO IDsubj 
  /PRINT. 
STRING  Arousal (A1). 
COMPUTE Arousal=CHAR.SUBSTR(StimClass,1). 
EXECUTE.
STRING  Valence (A1). 
COMPUTE Valence=CHAR.SUBSTR(StimClass,2). 
EXECUTE.

*aggregate long form data.
DATASET DECLARE Constr_aggr_CtrlNoise. 
AGGREGATE 
  /OUTFILE='Constr_aggr_CtrlNoise' 
  /BREAK=IDsubj Arousal Valence 
  /Constr_mean=MEAN(pupilValue) 
  /N_trials=N. 
DATASET ACTIVATE Constr_aggr_CtrlNoise. 
 
SAVE OUTFILE='CtrlNoise_constriction_aggr.sav'
   /COMPRESSED.

*resstructure cases to vars.
SORT CASES BY IDsubj Arousal Valence. 
CASESTOVARS 
  /ID=IDsubj 
  /INDEX=Arousal Valence 
  /GROUPBY=VARIABLE.
 
NUMERIC minTrials (F2.0).
COMPUTE minTrials=min( N_trials.M.N, N_trials.M.P, N_trials.S.N, N_trials.S.P).
EXECUTE.

SAVE OUTFILE='CtrlNoise_constr_repeated.sav'
   /COMPRESSED.




%{
# Session table
-> d.Mouse
session_date: date   # session date
session_num: smallint # session number in the day
-----
-> d.Project
-> d.Rig
num_trials: smallint # number of trials
performance: float # proportion correct overall
stimulus_type: enum("Detection","Discrimination")
choice_type: enum("2AFC","2AUC")
data: longblob #Cached data file

%}

classdef Session < dj.Manual
end
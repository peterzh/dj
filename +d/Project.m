%{
# Project table
project_id: varchar(128)   # project id
---
description: varchar(1024)   #Project description
%}

classdef Project < dj.Lookup
    properties
        contents = {'2AFC_Detection','Behavioural experiment, 2AFC detection';
            '2AFC_Discrimination', 'Behavioural experiment, 2AFC detection';
            '2AUC_Detection','Behavioural experiment, 2AUC detection';
            '2AUC_Discrimination','Behavioural experiment, 2AUC discrimination';
            'galvoPulse_unilateral','Pulsed galvo inactivation';
            'galvo_bilateral','Bilateral inactivation on Galvo rigs';
            'galvo_unilateral','Unilateral inactivation on Galvo rigs';
            'sparse_bilateral','Old bilateral inactivation experiment';
            'sparse_unilateral','Old unilateral inactivation experiment';
            'training','Training protocol'};
    end
end
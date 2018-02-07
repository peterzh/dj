%{
# Trial timings
-> d.Trial
-----
stimulus_onset: float
go_cue: float
response_made: float
start_move: float
%}

classdef TrialTimings < dj.Part
    properties(SetAccess=protected)
        master = d.Trial
    end
    methods
        function makeTuples(self, key)
            djo = struct('mouse_name',[],'session_date',[],'session_num',[],'trial_num',[],...
                        'stimulus_onset',[],'go_cue',[],'response_made',[],'start_move',[]);
            for tr = 1:length(key)
                djo(tr).mouse_name = key(tr).mouse_name;
                djo(tr).session_date = key(tr).session_date;
                djo(tr).session_num = key(tr).session_num;
                djo(tr).trial_num = tr;
                
                djo(tr).stimulus_onset = key(tr).data_row.time_stimulusOn;
                djo(tr).go_cue = key(tr).data_row.time_goCue;
                djo(tr).response_made = key(tr).data_row.time_choiceMade;
                djo(tr).start_move = key(tr).data_row.time_startMove;
                if isnan(key(tr).data_row.time_startMove)
                    djo(tr).start_move = -1;
                end

            end
            self.insert(djo);

        end
    end
    
end
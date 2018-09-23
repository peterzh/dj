%{
# Trial wheel data (wheel relative to stimulus onset)
-> d.Trial
-----
wheel_pos: longblob #wheel position
wheel_times: longblob #wheel times
%}

classdef TrialWheel < dj.Part
    properties(SetAccess=protected)
        master = d.Trial
    end
    methods
        function makeTuples(self, key)
            
            djo = struct('mouse_name',[],'session_date',[],'session_num',[],'trial_num',[],...
                'wheel_pos',[],'wheel_times',[]);
            for tr = 1:length(key)
                djo(tr).mouse_name = key(tr).mouse_name;
                djo(tr).session_date = key(tr).session_date;
                djo(tr).session_num = key(tr).session_num;
                djo(tr).trial_num = tr;
                
                djo(tr).wheel_pos = key(tr).data_row.wheel_stimulusOn;
                djo(tr).wheel_times = key(tr).data_row.wheel_stimulusOn_timesteps;

            end
            self.insert(djo);
        end
    end
    
end
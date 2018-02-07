%{
# Trial responses
-> d.Trial
-----
response: smallint        # choice made
feedback_type: smallint # feedback
reaction_time: float                #reaction time
%}

classdef TrialResponse < dj.Part
        properties(SetAccess=protected)
        master = d.Trial
    end
	methods
		function makeTuples(self, key)
            
            djo = struct('mouse_name',[],'session_date',[],'session_num',[],'trial_num',[],...
                'response',[],'feedback_type',[],'reaction_time',[]);
            for tr = 1:length(key)
                djo(tr).mouse_name = key(tr).mouse_name;
                djo(tr).session_date = key(tr).session_date;
                djo(tr).session_num = key(tr).session_num;
                djo(tr).trial_num = tr;
                
                djo(tr).response = key(tr).data_row.response;
                djo(tr).feedback_type = key(tr).data_row.feedbackType;
                djo(tr).reaction_time = key(tr).data_row.RT;
                
                if isnan(key(tr).data_row.RT)
                    djo(tr).reaction_time = -1;
                end
                
            end
            self.insert(djo);
		end
	end

end
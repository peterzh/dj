%{
# Trial stimulus
-> d.Trial
-----
contrast_left: float                #Contrast on the left
contrast_right: float               #Contrast on the right
repeat_num: smallint
%}

classdef TrialStim < dj.Part
    properties(SetAccess=protected)
        master = d.Trial
    end
	methods
		function makeTuples(self, key)
            djo = struct('mouse_name',[],'session_date',[],'session_num',[],'trial_num',[],...
                        'contrast_left',[],'contrast_right',[],'repeat_num',[]);
            for tr = 1:length(key)
                djo(tr).mouse_name = key(tr).mouse_name;
                djo(tr).session_date = key(tr).session_date;
                djo(tr).session_num = key(tr).session_num;
                djo(tr).trial_num = tr;
                
                djo(tr).contrast_left = key(tr).data_row.stimulus(1);
                djo(tr).contrast_right = key(tr).data_row.stimulus(2);
                djo(tr).repeat_num = key(tr).data_row.repeatNum;

            end
            self.insert(djo);

		end
	end

end
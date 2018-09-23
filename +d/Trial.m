%{
# Trial table
-> d.Session
trial_num: smallint                 #trial number
---
data_row: longblob #data row
%}

classdef Trial < dj.Imported
    methods(Access=protected)
        function makeTuples(self,key)
%             
            D = fetch1(d.Session & key,'data');
            
            fprintf('Trial data..');
            djo = struct('mouse_name',[],'session_date',[],'session_num',[],'trial_num',[],'data_row',[]);
            for tr = 1:length(D.response)
                djo(tr).mouse_name = key.mouse_name;
                djo(tr).session_date = key.session_date;
                djo(tr).session_num = key.session_num;
                djo(tr).trial_num = tr;
                djo(tr).data_row = getrow(D,tr);
            end
            self.insert(djo);
            
            fprintf('Trial stimulus info..');
            makeTuples(d.TrialStim,djo);
            fprintf('Trial choice info..');
            makeTuples(d.TrialResponse,djo);
            fprintf('Trial timings info..');
            makeTuples(d.TrialTimings,djo);
            fprintf('Trial wheel info..');
            makeTuples(d.TrialWheel,djo);
                
            if isfield(D,'laserCoord') && any(D.laserType>0)
                makeTuples(d.TrialLaser,djo);
            end
            
            
%             
        end
        
    end
end

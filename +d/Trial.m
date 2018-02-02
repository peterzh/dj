%{
# Trial table
-> d.Session
trial_num: smallint                 #trial number
---
contrast_left: float                #Contrast on the left
contrast_right: float               #Contrast on the right
response: enum("Left","Right","NoGo")        # choice made
feedback_type: enum("Incorrect","Correct") # feedback 
reaction_time: float                #reaction time
repeat_num: smallint        
data_row: longblob #data row
%}

classdef Trial < dj.Computed
    methods(Access=protected)
        function makeTuples(self,key)
            
            D = fetch1(d.Session & key,'data');
            
            %Go through each trial, populating the Trial table with each
            %entry
            responses = {"Left","Right","NoGo"};
            feedbacks = {"Incorrect","Correct"};
            
            djo = struct('mouse_name',[],'session_date',[],...
                         'session_num',[],'trial_num',[],...
                         'contrast_left',[],'contrast_right',[],...
                         'response',[],'feedback_type',[],...
                         'repeat_num',[],'reaction_time',[]);
             
                     
            for tr = 1:length(D.response)
                djo(tr).mouse_name = key.mouse_name;
                djo(tr).session_date = key.session_date;
                djo(tr).session_num = key.session_num;
                
                djo(tr).trial_num = tr;
                djo(tr).contrast_left = D.stimulus(tr,1);
                djo(tr).contrast_right = D.stimulus(tr,2);
                djo(tr).response = responses{D.response(tr)};
                djo(tr).feedback_type = feedbacks{(D.feedbackType(tr)==1)+1};
                djo(tr).repeat_num = D.repeatNum(tr);
                if isnan(D.RT(tr))
                    djo(tr).reaction_time = -1;
                else
                    djo(tr).reaction_time = D.RT(tr);
                end
                djo(tr).data_row = getrow(D,tr);
               
            end
            self.insert(djo);
%             key  % let's look at the key content
        end
    end
end
%{
# Trial table
-> d.Session
trial_num: smallint                 #trial number
---
contrast_left: float                #Contrast on the left
contrast_right: float               #Contrast on the right
response: enum("L","R","NG")        # choice made
feedback_type: enum("Incorrect","Correct") # feedback 
reaction_time: float                #reaction time
repeat_num: smallint                
%}

classdef Trial < dj.Imported
    methods(Access=protected)
        function makeTuples(self,key)
            
            D = fetch1(d.Session & key,'data');
            
            %Go through each trial, populating the Trial table with each
            %entry
            responses = {"L","R","NG"};
            feedbacks = {"Incorrect","Correct"};
            for tr = 1:length(D.response)
                key.trial_num = tr;
                key.contrast_left = D.stimulus(tr,1);
                key.contrast_right = D.stimulus(tr,2);
                key.response = responses{D.response(tr)};
                key.feedback_type = feedbacks{(D.feedbackType(tr)==1)+1};
                key.repeat_num = D.repeatNum(tr);
                if isnan(D.RT(tr))
                    key.reaction_time = -1;
                else
                    key.reaction_time = D.RT(tr);
                end
                self.insert(key);
            end
%             key  % let's look at the key content
        end
    end
end
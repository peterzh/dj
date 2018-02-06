%{
# Trial table
-> d.Session
trial_num: smallint                 #trial number
---
contrast_left: float                #Contrast on the left
contrast_right: float               #Contrast on the right
response: smallint        # choice made
feedback_type: smallint # feedback
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
                djo(tr).response = D.response(tr); %responses{D.response(tr)};
                djo(tr).feedback_type = D.feedbackType(tr); %feedbacks{(D.feedbackType(tr)==1)+1};
                djo(tr).repeat_num = D.repeatNum(tr);
                if isnan(D.RT(tr))
                    djo(tr).reaction_time = -1;
                else
                    djo(tr).reaction_time = D.RT(tr);
                end
                djo(tr).data_row = getrow(D,tr);
            end
            self.insert(djo);
            
            
            if isfield(D,'laserCoord') && any(D.laserType)
                laserTypes = {"Unilateral","Bilateral"};
                djo2 = struct('mouse_name',[],'session_date',[],...
                    'session_num',[],'trial_num',[],...
                    'laser_ml',[],'laser_ap',[],...
                    'laser_type',[],'laser_power',[],...
                    'laser_duration',[],'laser_onset_time',[],...
                    'hemisphere',[],'region',[]);
                
                
                i=1;
                for tr = 1:length(D.response)
                    
                    if D.laserType(tr)>0
                        djo2(i).mouse_name = key.mouse_name;
                        djo2(i).session_date = key.session_date;
                        djo2(i).session_num = key.session_num;
                        djo2(i).trial_num = tr;
                        djo2(i).laser_ml = D.laserCoord(tr,1);
                        djo2(i).laser_ap = D.laserCoord(tr,2);
                        djo2(i).laser_type = laserTypes{D.laserType(tr)};
                        djo2(i).laser_power = D.laserPower(tr);
                        djo2(i).laser_duration = D.laserDuration(tr);
                        djo2(i).laser_onset_time = D.laserOnset(tr);
                        
                        if djo2(i).laser_ml>0
                            djo2(i).hemisphere = 'Right';
                        else
                            djo2(i).hemisphere = 'Left';
                        end
                        
                        if D.laserType == 2
                            djo2(i).hemisphere = 'Both';
                        end
                        
                        region = D.laserRegion(tr);
                        if contains(region,'VIS')
                            djo2(i).region = 'VIS';
                        elseif contains(region,'M2')
                            djo2(i).region = 'M2';
                        elseif contains(region,'S1')
                            djo2(i).region = 'S1';
                        elseif contains(region,'Other')
                            djo2(i).region = 'Other';
                        elseif contains(region,'FrontOutside')
                            djo2(i).region = 'FrontOutside';
                        elseif contains(region,'BackOutside')
                            djo2(i).region = 'BackOutside';
                        end
                        i=i+1;
                    end
                end
                
                insert(d.LaserTrial,djo2);
            end
        end
        
    end
end

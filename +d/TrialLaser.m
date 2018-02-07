%{
# Laser trial 
-> d.Trial
-----
-> d.BrainRegion
laser_ml: float # Laser ML
laser_ap: float #Laser AP
laser_type: enum("Off","Unilateral","Bilateral") #laser type
laser_power: float #laser power
laser_duration: float #laser duration
laser_onset_time: float #laser onset time relative to stim onset

%}

classdef TrialLaser < dj.Part
    properties(SetAccess=protected)
        master = d.Trial
    end
    methods
        
        function makeTuples(self, key)
            laserTypes = {"Unilateral","Bilateral"};

            djo = struct('mouse_name',[],'session_date',[],'session_num',[],'trial_num',[],...
                        'laser_ml',[],'laser_ap',[],'laser_type',[],...
                        'laser_power',[],'laser_duration',[],'laser_onset_time',[],...
                    'hemisphere',[],'region',[]);
            
                %Remove trials with no laser   
            key( arrayfun(@(k) k.data_row.laserType==0, key) ) = [];
                
                for tr = 1:length(key)
                    djo(tr).mouse_name = key(tr).mouse_name;
                    djo(tr).session_date = key(tr).session_date;
                    djo(tr).session_num = key(tr).session_num;
                    djo(tr).trial_num = key(tr).trial_num;
                    
                    
                    djo(tr).laser_ml = key(tr).data_row.laserCoord(1);
                    djo(tr).laser_ap = key(tr).data_row.laserCoord(2);
                    djo(tr).laser_type = laserTypes{key(tr).data_row.laserType};
                    djo(tr).laser_power = key(tr).data_row.laserPower;
                    djo(tr).laser_duration = key(tr).data_row.laserDuration;
                    djo(tr).laser_onset_time = key(tr).data_row.laserOnset;
                    
                    if djo(tr).laser_ml>0
                        djo(tr).hemisphere = 'Right';
                    else
                        djo(tr).hemisphere = 'Left';
                    end
                    
                    if key(tr).data_row.laserType == 2
                        djo(tr).hemisphere = 'Both';
                    end
                    
                    region = key(tr).data_row.laserRegion;
                    if contains(region,'VIS')
                        djo(tr).region = 'VIS';
                    elseif contains(region,'M2')
                        djo(tr).region = 'M2';
                    elseif contains(region,'S1')
                        djo(tr).region = 'S1';
                    elseif contains(region,'Other')
                        djo(tr).region = 'Other';
                    elseif contains(region,'FrontOutside')
                        djo(tr).region = 'FrontOutside';
                    elseif contains(region,'BackOutside')
                        djo(tr).region = 'BackOutside';
                    end
 
                end
            self.insert(djo);
        end
    end
    

end
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

classdef LaserTrial < dj.Computed

	methods(Access=protected)

        function makeTuples(self, key)
            %!!! compute missing fields for key here
            D = fetch1(d.Trial & key,'data_row');
            if isfield(D,'laserRegion') && D.laserType>0
                laserTypes = {"Unilateral","Bilateral"};
                
                key.laser_ml = D.laserCoord(1);
                key.laser_ap = D.laserCoord(2);
                key.laser_type = laserTypes{D.laserType};
                key.laser_power = D.laserPower;
                key.laser_duration = D.laserDuration;
                key.laser_onset_time = D.laserOnset;
                
                if key.laser_ml>0
                    key.hemisphere = 'Right';
                else
                    key.hemisphere = 'Left';
                end
                
                if D.laserType == 2
                    key.hemisphere = 'Both';
                end
                
                region = D.laserRegion;
                if contains(region,'VIS')
                    key.region = 'VIS';
                elseif contains(region,'M2')
                    key.region = 'M2';
                elseif contains(region,'S1')
                    key.region = 'S1';
                elseif contains(region,'Other')
                    key.region = 'Other';
                elseif contains(region,'FrontOutside')
                    key.region = 'FrontOutside';
                elseif contains(region,'BackOutside')
                    key.region = 'BackOutside';
                end
                self.insert(key);
                
            end
        end
	end

end
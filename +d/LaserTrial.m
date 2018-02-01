%{
# Laser trial 
-> d.Trial
-----
laser_ml: float # Laser ML
laser_ap: float #Laser AP
laser_type: enum("Off","Unilateral","Bilateral") #laser type
laser_power: float #laser power
laser_duration: float #laser duration
laser_onset_time: float #laser onset time relative to stim onset

%}

classdef LaserTrial < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
			 self.insert(key)
		end
	end

end
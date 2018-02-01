%{
# single neuron recording
-> tutorial.Session
---
activity:  longblob    # electric activity of the neuron
%}

classdef Neuron < dj.Imported
    
    methods(Access=protected)
        function makeTuples(self,key)
            %use key struct to determine the data file path
            data_file = sprintf('C:\\Users\\Peter\\Desktop\\data\\data_%d_%s.mat',key.mouse_id,key.session_date);
            
            % load the data
            data = load(data_file);
            
            % add the loaded data as the "activity" column
            key.activity = data.data;
            
            % insert the key into self
            self.insert(key)
            
            sprintf('Populated a neuron for %d experiment on %s',key.mouse_id,key.session_date);

        end
    end
    
end
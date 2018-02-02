%{
# Session table
-> d.Mouse
session_date: date   # session date
session_num: smallint # session number in the day
-----
num_trials: smallint # number of trials
performance: float # proportion correct overall
stimulus_type: enum("Detection","Discrimination")
choice_type: enum("2AFC","2AUC")
data: longblob #Cached data file
project_id: varchar(128) # Project ID
rig: varchar(128) #Experimental rig
%}

classdef Session < dj.Imported
    methods(Access=protected)

		function makeTuples(self, key)
            baseDirs = {'\\zserver.cortexlab.net\Data2\Subjects';
                '\\zserver.cortexlab.net\Data\expInfo';
                '\\zserver.cortexlab.net\Data\Subjects';
                '\\zubjects.cortexlab.net\Subjects'};
            
            expRefs = {};
            for i = 1:4
                subjDir = fullfile(baseDirs{i},key.mouse_name);
                blockFiles = dirPlus(subjDir,'filefilter','\_Block.mat$','struct',true);
                if ~isempty(blockFiles)
                    eRefs = cellfun(@(bf) strrep(bf, '_Block.mat', ''), {blockFiles.name}, 'uni' ,0)';
                    expRefs = [expRefs; eRefs];
                end
            end
            expRefs = unique(expRefs);
            
            for sess = 1:length(expRefs)
                %Load data, to categorise into project
                [~, date, seq] = dat.parseExpRef(expRefs{sess});

                try
                    [D,meta] = loadData(expRefs{sess});
                    key.session_date = datestr(date,29);
                    key.session_num = seq;
                    key.num_trials = length(D.response);
                    key.performance = mean(D.feedbackType==1);
                    key.stimulus_type = char( categorical( any(min(D.stimulus,[],2)>0) , [0,1], {'Detection','Discrimination'}) );
                    key.choice_type = char( categorical(max(D.response),2:3,{'2AFC','2AUC'}) );
                    key.data = D;
                    
                    %Identify project, load all info I need (parameter files, etc)
                    key.rig = meta.rig;
                    if any(contains(key.rig,{'zredone','zredtwo','zredthree','zgreyfour'}))
                        key.project_id = 'training';
                    end
                    
                    %Add to DJ
                    if key.num_trials > 50
                        self.insert(key);
                    end
                catch me
                    disp(me);
                end
                
            end
            
            
        end
    end
end
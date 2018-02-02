%{
# Session table
-> d.Mouse
session_date: date   # session date
session_num: smallint # session number in the day
-----
-> d.Project
-> d.Rig
num_trials: smallint # number of trials
performance: float # proportion correct overall
stimulus_type: enum("Detection","Discrimination")
choice_type: enum("2AFC","2AUC")
data: longblob #Cached data file

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
                    
                    try
                        D.laserRegion = cellstr(D.laserRegion);
                        D.prev_laserRegion = cellstr(D.prev_laserRegion);
                    catch
                    end
                    
                    key.session_date = datestr(date,29);
                    key.session_num = seq;
                    key.num_trials = length(D.response);
                    key.performance = mean(D.feedbackType==1);
                    key.stimulus_type = char( categorical( any(min(D.stimulus,[],2)>0) , [0,1], {'Detection','Discrimination'}) );
                    key.choice_type = char( categorical(max(D.response),2:3,{'2AFC','2AUC'}) );
                    key.data = D;
                    
                    %Add to DJ
                    if key.num_trials > 10
                        key.rig = meta.rig;
                        key.project_id = self.identifyProject(key);
                        
                        try
                            self.insert(key);
                        catch
                            keyboard;
                        end
                    end
                catch me
                    disp(me);
                end
                
            end
            
            
        end
        
        function proj_id = identifyProject(~,key)
           
            if any(contains(key.rig,{'zredone','zredtwo','zredthree','zgreyfour','zym3'}))
                proj_id = 'training';
                return;
            end
            
            if isfield(key.data,'laserType')
                
%                 %Number of coordinates
%                 numCoords = size( unique(key.data.laserCoord(key.data.laserType~=0,:),'rows'), 1);
                
                if any(contains(key.rig,{'zym1','zym2'})) %Blue rigs

                    %pulse or long-duration?
                    if max(key.data.laserDuration) == 1.5
                        prefix = 'galvo_';
                    elseif max(key.data.laserDuration) == 0.025
                        prefix = 'galvoPulse_';
                    else
                        keyboard;
                    end
                    
                elseif strcmp(key.rig,'zgood') %Nick's rig
                    prefix = 'sparse_';
                end

                %Unilateral or bilateral?
                if max(key.data.laserType)==1
                    proj_id = [prefix 'unilateral'];
                elseif max(key.data.laserType)==2
                    proj_id = [prefix 'bilateral'];
                else
                    proj_id = [key.choice_type '_' key.stimulus_type];
                end
            else
                proj_id = [key.choice_type '_' key.stimulus_type];
            end
            
        end
    end
end
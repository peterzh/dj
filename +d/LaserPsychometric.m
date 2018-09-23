%{
# Compute psychometric curves of laser effects in each brain region
-> d.Mouse
-> d.BrainRegion
-----
figure_path="" : varchar(1024)
%}

classdef LaserPsychometric < dj.Computed
    
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            %Get all laser and non-laser data
            sessions = d.Session & sprintf('mouse_name="%s"',key.mouse_name);
            sessions = proj(sessions,'(project_id like "galvo%") -> xx') & 'xx=1';
            
            trials = d.Trial & sessions;
            
            nLtrials = (trials - d.TrialLaser) & (d.TrialStim & 'repeat_num=1');
            lasTrials = trials & (d.TrialLaser & sprintf('hemisphere="%s" AND region="%s"', key.hemisphere, key.region));
            
            if isempty(fetch(lasTrials))
                return;
            end
            
            
            laser_power = fetchn( lasTrials * d.TrialLaser, 'laser_power');

            warning('only getting max power laser trials');
            lasTrials = lasTrials & (d.TrialLaser & ['laser_power=' num2str(max(laser_power))]);
            
            
            [contrast_left, contrast_right, repeat_num] = fetchn( nLtrials * d.TrialStim, 'contrast_left', 'contrast_right','repeat_num');
            [response] = fetchn( nLtrials * d.TrialResponse, 'response');
            %Create data struct
            D = struct;
            D.stimulus = [contrast_left contrast_right];
            D.response = response;
            D.repeatNum = repeat_num;
            %If 2AUC, fit C50-subset
            g = GLM(D).setModel('C50-subset').fit;
            
            %Print fit
            fig1 = g.plotFit;
            
            
            
            [contrast_left, contrast_right, repeat_num] = fetchn( lasTrials * d.TrialStim, 'contrast_left', 'contrast_right','repeat_num');
            [response] = fetchn( lasTrials * d.TrialResponse, 'response');
            %Create data struct
            D = struct;
            D.stimulus = [contrast_left contrast_right];
            D.response = response;
            D.repeatNum = repeat_num;
            %If 2AUC, fit C50-subset
            g = GLM(D).setModel('C50-subset').fit;
            fig2 = g.plotFit;
            
            axs1 = get(fig1,'children');
            axs2 = get(fig2,'children');
            
            for ax = 1:length(axs1)
                nLstuff = get(axs1(ax),'children');
                set(nLstuff,'color',[0 0 0]);
                
                
                Lstuff = get(axs2(ax),'children');
                set(Lstuff,'color',[1 0 0]);
                copyobj(Lstuff, axs1(ax))
            end
            
            close(fig2)
            set(fig1,'name',sprintf('subj="%s" AND hemisphere="%s" AND region="%s"', key.mouse_name, key.hemisphere, key.region))
            
            
            % 			 self.insert(key)
        end
    end
    
end
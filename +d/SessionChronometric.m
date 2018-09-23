%{
# Chronometric information for each session
-> d.Session
-----
figure_path="" : varchar(1024)
%}

classdef SessionChronometric < dj.Computed
    
    methods(Access=protected)
        
        function makeTuples(self, key)
            %Load all trials associated with this session
            trials = (d.Trial & key) * d.TrialStim * d.TrialTimings * d.TrialResponse;
            
            %Get only trials on zero pedestal, and plot RT histograms
            trials = trials & 'contrast_left=0 OR contrast_right=0';
            [contrast_left, contrast_right, response, RT] = fetchn(trials,'contrast_left','contrast_right','response','reaction_time');
            
            cDiff = contrast_right - contrast_left;
            %             cVal = unique(cDiff);
            
            fig = figure('color','w','position',[372 553 1005 420]);
            ha = tight_subplot(1,2,0.01,[0.15 0.1],[0.08 0.01]);
            set(ha,'XTickLabelMode','auto','YTickLabelMode','auto');
            a=distributionPlot(ha(1),RT(response==1),'groups',cDiff(response==1),'histOpt',0,'widthDiv',[2 1],'histOri','left','color','b','showMM',4,'globalNorm',2);
            set(a{2},'Color',[0.5 0.5 1]); set(a{2}(1),'Marker','.');
            
            a=distributionPlot(ha(1),RT(response==2),'groups',cDiff(response==2),'histOpt',0,'widthDiv',[2 2],'histOri','right','color','r','showMM',4,'globalNorm',2);
            set(a{2},'Color',[1 0.5 0.5]); set(a{2}(1),'Marker','.');
            
            xlabel(ha(1),'CR-CL');
            ylabel(ha(1),'Reaction time');
            ylim(ha(1),[0 min([1.5 max(RT(response<3))]) ]);
            
            title(ha(1),sprintf('%s_%d_%s',key.session_date,key.session_num,key.mouse_name),'interpreter','none');
            set(get(fig,'children'),'fontsize',15);
            
            %Now plot wheel traces
            trials = (d.Trial & key) * d.TrialResponse * d.TrialWheel;
            [response, wheel_times, wheel_pos] = fetchn(trials,'response', 'wheel_times', 'wheel_pos');
            wheel_times = wheel_times{1};
            wheel_pos = cat(1,wheel_pos{:});
            
            cols = [0 0 1 0.2; 1 0 0 0.2; 0 0 0 0.2];
            hold(ha(2),'on');
            for r = 1:3
                if any(response==r)
                    hx=plot(ha(2),wheel_times, wheel_pos(response == r,:));
                    set(hx,'Color',cols(r,:));
                end
            end
            
            for r = 1:2
                if any(response==r)
                    plot(ha(2),wheel_times, nanmean(wheel_pos(response == r,:),1), 'w-', 'linewidth',5);
                    hx=plot(ha(2),wheel_times, nanmean(wheel_pos(response == r,:),1), '-', 'linewidth',3);
                    set(hx,'Color',cols(r,1:3));
                end
            end
            
            xlim(ha(2), [wheel_times(1) wheel_times(end)]);
            ylabel(ha(2),'Wheel encoder count');
            xlabel(ha(2),'Time from stimulus onset');
            ylim(ha(2),[-1 1]*quantile(abs(wheel_pos(:,end)),0.95));
            
            sessDir = fullfile('C:\Users\Peter\Desktop\AutomatedFigures',sprintf('%s_%d_%s',key.session_date,key.session_num,key.mouse_name));

            if ~exist(sessDir,'dir'); mkdir(sessDir); end;
            figure_path = fullfile(sessDir,...
                sprintf('%s_%d_%s_chronos.png',key.session_date,key.session_num,key.mouse_name));
            set(fig,'PaperPositionMode','auto')
            print(fig, figure_path,'-dpng','-r0');
            close(fig);
            key.figure_path = figure_path;
            
            self.insert(key)
        end
    end
    
end
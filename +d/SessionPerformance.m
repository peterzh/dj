%{
# my newest table
-> d.Session
-----
figure_path="" : varchar(1024)
%}

classdef SessionPerformance < dj.Computed
    
    methods(Access=protected)
        
        function makeTuples(self, key)            
            %Load all trials associated with this session
            trials = (d.Trial & key) * d.TrialStim * d.TrialTimings * d.TrialResponse;
            
            fig = figure('color','w','position',[239 405 1211 340]);
            ha = tight_subplot(2,1,0.03,[0.18 0.1],[0.05 0.01]);
            hold(ha(1),'on');
            hold(ha(2),'on');
            set(ha(1),'xcolor','none','YTickLabelMode','auto');
            set(ha(2),'XTickLabelMode','auto','YTickLabelMode','auto');
            
            %Get data
            [responseTimes, feedback, response] = fetchn(trials,'response_made','feedback_type','response');
            responseTimes = responseTimes - responseTimes(1);
            feedback = feedback==1;

            %Plot overall performance
            plot(ha(1),responseTimes, feedback, 'k.');
            plot(ha(1),responseTimes, smoothdata(feedback,'movmean',60,'SamplePoints',responseTimes), 'k-','linewidth',1);
            plot(ha(1),responseTimes, smoothdata(feedback,'movmean',500,'SamplePoints',responseTimes), 'k:','linewidth',1);
            ylim(ha(1),[0 1]);
            ylabel(ha(1),'pCorrect');

            
            %Overall Left-Right bias   
            if any(response==1) && any(response==2)
                plot(ha(2),responseTimes(response==2), 1, 'r.');
                plot(ha(2),responseTimes(response==1), -1, 'b.');
                ylabel(ha(2),'pR - pL');
                
                
                pL = smoothdata(response==1,'movmean',500,'SamplePoints',responseTimes);
                pR = smoothdata(response==2,'movmean',500,'SamplePoints',responseTimes);
                dP = pR-pL; dP(dP<0) = NaN;
                plot(ha(2),responseTimes, dP, 'r-','linewidth',1);
                dP = pR-pL; dP(dP>0) = NaN;
                plot(ha(2),responseTimes, dP, 'b-','linewidth',1);
                
                ylim(ha(2),[-1 1]);
                l = line(ha(2),[min(responseTimes) max(responseTimes)], [0 0]);
                l.Color = [1 1 1]*0.8;
                
                
                %Plot behavioural bias, adjusted by stimulus bias
                [contrast_left, contrast_right] = fetchn(trials,'contrast_left','contrast_right');
                pCL = smoothdata(contrast_left>contrast_right,'movmean',500,'SamplePoints',responseTimes);
                pCR = smoothdata(contrast_left<contrast_right,'movmean',500,'SamplePoints',responseTimes);
                
            end
            xlabel(ha(2),'Response time (sec)');
            set(ha,'xlim', [min(responseTimes) max(responseTimes)]);
            title(ha(1),sprintf('%s_%d_%s      n=%d trials      %d%% correct',key.session_date,key.session_num,key.mouse_name,length(responseTimes),round(100*mean(feedback))),'interpreter','none');
            set(get(fig,'children'),'fontsize',15);
            
            
            sessDir = fullfile('C:\Users\Peter\Desktop\AutomatedFigures',sprintf('%s_%d_%s',key.session_date,key.session_num,key.mouse_name));
            if ~exist(sessDir,'dir'); mkdir(sessDir); end;
            figure_path = fullfile(sessDir,...
                sprintf('%s_%d_%s_overTime.png',key.session_date,key.session_num,key.mouse_name));
            print(fig, figure_path,'-dpng');
            close(fig);
            key.figure_path = figure_path;
            
            self.insert(key)
        end
    end
    
end
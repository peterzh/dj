%{
# GLM fit computation
-> d.Session
-> d.GLM
---
model_params : longblob # model object
crossval_loglik : float # model crossvalidated log likelihood relative to guess
%}

classdef GLMFit < dj.Computed
    methods(Access=protected)
        function makeTuples(self,key)
            
            %Skip this process for training sessions
            if strcmp(fetch1(d.Session & key,'project_id'), 'training')
                return
            end
            
            %First check whether the model is possible, i.e. 2AFC behaviour
            %should use binomial model, while 2AUC should use multinomial
            model_type = fetch1(d.GLM & key,'model_type');
            choice_type = fetch1(d.Session & key,'choice_type');
            
            if strcmp(model_type,'Binomial') && ~strcmp(choice_type,'2AFC')
                return
            elseif strcmp(model_type,'Multinomial') && ~strcmp(choice_type,'2AUC')
                return
            end
            
           model_name = fetch1(d.GLM & key,'model_name');
           
           %Get all non-laser trials associated with this session, with
           %repeatNum==1
           trials = (d.Trial - d.TrialLaser) & key & (d.TrialStim & 'repeat_num=1');

           [contrast_left, contrast_right, repeat_num] = fetchn( trials * d.TrialStim, 'contrast_left', 'contrast_right','repeat_num');
           [response] = fetchn( trials * d.TrialResponse, 'response');
           
           %Create data struct
           D = struct;
           D.stimulus = [contrast_left contrast_right];
           D.response = response;
           D.repeatNum = repeat_num;
           
           if length(D.response)<30
               warning('Skipping because too-few trials');
               return;
           end

           %If 2AUC, fit C50-subset
           g = GLM(D).setModel(model_name).fit;
           
           key.model_params = g.parameterFits;
           
           g = g.fitCV(10);
           ph = g.p_hat(:,1).*(g.data.response==1) + g.p_hat(:,2).*(g.data.response==2) + g.p_hat(:,3).*(g.data.response==3);
           key.crossval_loglik = mean(log2(ph)) - g.guess_bpt;
           
           if isnan(key.crossval_loglik) || isinf(key.crossval_loglik)
               ph(ph<0.000001)=[];
               ph(isnan(ph))=[];
               key.crossval_loglik = mean(log2(ph)) - g.guess_bpt;

           end
           
           %Write parameters
           self.insert(key);
        end
    end
end
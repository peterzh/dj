%{
  # statistics about the activity
  -> tutorial.Neuron
  ---
  mean: float    # mean activity
  stdev: float   # standard deviation of activity
  max: float     # maximum activity
%}

classdef ActivityStatistics < dj.Computed

    methods(Access=protected)
        function makeTuples(self,key)

            activity = fetch1(tutorial.Neuron & key,'activity');    % fetch activity as Matlab array

            % compute various statistics on activity
            key.mean = mean(activity); % compute mean
            key.stdev = std(activity); % compute standard deviation
            key.max = max(activity);    % compute max
            self.insert(key);
            sprintf('Computed statistics for for %d experiment on %s',key.mouse_id,key.session_date);

        end
    end
end
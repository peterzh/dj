%{
  # spikes
  -> tutorial.Neuron
  -> tutorial.SpikeDetectionParam
  ---
  spikes: longblob     # detected spikes
  count: int           # total number of detected spikes
%}

classdef Spikes < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            activity = fetch1(tutorial.Neuron & key, 'activity');
            threshold = fetch1(tutorial.SpikeDetectionParam & key, 'threshold');
            
            above_thrs = activity > threshold;   % find activity above threshold
            rising = diff(above_thrs) > 0; % find rising edge of crossing threshold
            spikes = [0 rising];    % prepend 0 to account for shortening due to np.diff
            count = sum(spikes);   % compute total spike counts
            
            % save results and insert
            key.spikes = spikes;
            key.count = count;
            self.insert(key);
            
            sprintf('Detected %d spikes for mouse_id %d session_date %s using threshold=%2.2f',...
                count, key.mouse_id, key.session_date, threshold)
        end
    end
end
%{
# Spike detection thresholds
sdp_id: int      # unique id for spike detection parameter set
---
threshold: float   # threshold for spike detection
%}

classdef SpikeDetectionParam < dj.Lookup
end
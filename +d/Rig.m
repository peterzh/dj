%{
# Rig table
rig: varchar(128)   # rig name
---
%}

classdef Rig < dj.Lookup
    properties
        contents = {'zgood';
                    'zredone';'zredtwo';'zredthree';'zgreyfour';
                    'zym1';'zym2';'zym3';
                    'zrig1';'zrig2';'zrig3'};
    end
end
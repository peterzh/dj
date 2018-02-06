%{
# Brain region table
region: varchar(128)   # region name
hemisphere: enum("Left","Right","Both")
---
%}

classdef BrainRegion < dj.Lookup
    properties
        contents = {'VIS', 'Left';
            'VIS', 'Right';
            'VIS', 'Both';
            'M2', 'Left';
            'M2', 'Right';
            'M2', 'Both';
            'S1', 'Left';
            'S1', 'Right';
            'S1', 'Both';
            'FrontOutside', 'Left';
            'FrontOutside', 'Right';
            'FrontOutside', 'Both';
            'BackOutside', 'Left';
            'BackOutside', 'Right';
            'BackOutside', 'Both';
            'Other', 'Left';
            'Other', 'Right';
            'Other', 'Both'};
    end
end
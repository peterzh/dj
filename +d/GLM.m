%{
# Generalized Linear model definitions
model_name : varchar(50) # model name
-----
model_type : enum('Binomial','Multinomial')
# add additional attributes
%}

classdef GLM < dj.Lookup
    properties
        contents = {'AFC','Binomial';
                    'C^N-subset-2AFC','Binomial';
                    'C50-subset-2AFC','Binomial';
                    'C-subset','Multinomial';
                    'C^N-subset','Multinomial';
                    'C50-subset','Multinomial'};
    end
end
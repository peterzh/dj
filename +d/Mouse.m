%{
# Mouse table
mouse_name: varchar(10)  # unique mouse name
---
dob: date                       # mouse date of birth YYYY-MM-DD
sex: enum('M', 'F')             # sex of mouse - Male, Female
genetic_line: varchar(20)                       # Genetic line
%}

classdef Mouse < dj.Lookup
    properties
        contents = {
        'Beadle',   '2017-07-28',   'M',    'Ai32cg.Pv';
        'Bovet',    '2017-07-28',   'M',    'Ai32cg.Pv';
        'Keynes',   '2017-06-18',   'F',    'Ai32cg.Pv';
        'Heinz',    '2017-06-18',   'F',    'Ai32cg.Pv';
        'Nyx',      '2016-11-01',   'F',    'Ai32.Pv';
        'Gaia',     '2016-11-01',   'F',    'Ai32.Pv';
        'Vin',      '2016-07-09',   'F',    'Ai32.Pv';
        'Whipple',  '2015-06-02',   'F',    'Ai32.Pv';
        'Morgan',   '2015-06-02',   'F',   'Ai32.Pv';
        'Spemann',  '2015-07-13',   'M',    'Ai32.Pv';
        'Murphy',   '2015-07-13',   'M',   'Ai32.Pv';
        'Chomsky',  '2016-04-01',   'F',    'Ai32.Pv';
        };
    end
end


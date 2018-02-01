%{
# Mouse table
mouse_name: varchar(10)  # unique mouse name
---
%}

classdef Mouse < dj.Manual
end

% Other attributes might need later
% dob: date                       # mouse date of birth YYYY-MM-DD
% sex: enum('M', 'F')             # sex of mouse - Male, Female
% genetic_line: varchar(20)                       # Genetic line
%{
# mouse
mouse_id: int                  # unique mouse ID
---
dob: date                      # mouse date of birth
sex: enum('M', 'F', 'U')       # sex of mouse - Male, Female, or Unknown/Unclassified
%}

classdef Mouse < dj.Manual
end
%{
# Project table
project_id: varchar(128)   # project id
---
description: varchar(1024)   #Project description
%}

classdef Project < dj.Lookup
end
%{
# Fit
-> d.GLMFit
-----
%}

classdef GLMFigure < dj.Computed

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
            model = fetch(d.GLMFit & key,'*');
            keyboard;
% 			 self.insert(key)
		end
	end

end
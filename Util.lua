string.startswith = function(self, str) 
    return self:find('^' .. str) ~= nil
end

string.commavalue = function(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
		break
		end
	end
	return formatted
end

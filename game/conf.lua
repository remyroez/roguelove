-- on love
if love.filesystem then
	-- loverocks
	require 'rocks' ()
	
	-- src
	love.filesystem.setRequirePath("src/?.lua;src/?/init.lua;" .. love.filesystem.getRequirePath())

	-- lib
	love.filesystem.setRequirePath("lib/?;lib/?.lua;lib/?/init.lua;" .. love.filesystem.getRequirePath())
end

function love.conf(t)
	t.identity = "roguelove"
	t.version = "0.10.2"

	--t.window = nil
	t.window.title = "roguelove"

	t.dependencies = {
		--"middleclass",
		"lovetoys",
		"ljsonschema",
		"semver"
	}
end

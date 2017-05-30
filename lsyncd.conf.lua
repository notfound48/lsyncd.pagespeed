settings {

   logfile          = "/var/log/lsyncd.log",
   statusFile       = "/var/log/lsyncd.status",
   nodaemon         = false,
   maxDelays        = 900,
   maxProcesses     = 6,

}

local formats = { jpg = true, png = true }

convert = {

	delay = 0,

	maxProcesses = 99,

	action = function(inlet)
		local event = inlet.getEvent()

		if event.isdir then
			-- ignores events on dirs
			inlet.discardEvent(event)
			return
		end

		-- extract extension and basefilename
		local p    = event.pathname
		local ext  = string.match(p, ".*%.([^.]+)$")
		local base = string.match(p, "(.*)%.[^.]+$")
		if not formats[ext] then
			-- an unknown extenion
			log("Normal", "not doing something")
			inlet.discardEvent(event)
			return
		end

		-- autoconvert on create and modify
		if event.etype == "Create" or event.etype == "Modify" then

			-- builds one bash command
			local cmd = ""
			inlet.addExclude(p)

			if string.lower(ext) == "png" then

				cmd = '/usr/bin/optipng -strip all -o4 '..event.source..p..' || /bin/true'

			elseif string.lower(ext) == "jpg" then

				cmd = '/usr/bin/jpegoptim --strip-all --preserve-perms --all-progressive -pm85 '..event.source..p..' || /bin/true'

			end

			log("Normal", "Processing "..p)
			
			spawnShell(event, cmd)
			return
		end

		-- ignores other events.
		inlet.discardEvent(event)
	end,

	-----
	-- Removes excludes when convertions are finished
	--
	collect = function(event, exitcode)
		local p     = event.pathname
		local ext   = string.match(p, ".*%.([^.]+)$")
		local base  = string.match(p, "(.*)%.[^.]+$")
		local inlet = event.inlet

		if event.etype == "Create" or
		   event.etype == "Modify" or 
		   event.etype == "Delete" 
		then
			inlet.rmExclude(p)
		end
	end,

}

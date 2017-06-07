/*-------------------------------------------------------------------------------------------------------------------------
	Kill a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Preslay"
PLUGIN.Description = "Kills a player at the start of next round."
PLUGIN.Author = "Boopington"
PLUGIN.ChatCommand = "preslay"
PLUGIN.Usage = "[players] [0/1] [optional hide]"
PLUGIN.Privileges = { "preslay" }

local slaytable = {}
hook.Add("TTTBeginRound", "preslay", function()
	for k,v in pairs(slaytable) do
		if v:IsValid() then
			v:Kill()
			v:SetFrags( v:Frags() + 1 )
			evolve:Notify(evolve.colors.blue, v:Nick(), evolve.colors.white, " was slain.")
			//table.remove(slaytable, k)
		end
	end
	slaytable = {}
end)

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "preslay" ) ) then
		if #args < 1 then
			evolve:Notify( ply, evolve.colors.red, "Not enough arguments" )
			return
		end
		local players = evolve:FindPlayer( args[1], ply )
		
		if ( #players == 1 ) and (!args[2] or args[2] == "1") then
			if table.HasValue(slaytable, players[1]) then
				evolve:Notify( ply, evolve.colors.red, players[1]:Nick(), " is already marked."  )
			else 
				table.insert(slaytable, players[1])
				if args[3] and args[3] != "0" then
					evolve:Notify( ply, evolve.colors.red, players[1]:Nick(), evolve.colors.white, " will be slain next round." )
				else
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " marked ", evolve.colors.red, players[1]:Nick(), evolve.colors.white, " to be slain next round." )
				end
			end
		elseif ( #players == 1 ) and args[2] == "0" then
			if table.HasValue(slaytable, players[1]) then
				if args[3] and args[3] != "0" then
					evolve:Notify( ply, evolve.colors.red, players[1]:Nick(), evolve.colors.white, " will no longer be slain at round start." )
				else
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " removed the preslay from ", evolve.colors.red, players[1]:Nick(), evolve.colors.white, "." )
				end
				table.RemoveByValue(slaytable, players[1])
			else 
				evolve:Notify( ply, evolve.colors.red, players[1]:Nick(), " was not marked."  )
			end
		elseif  ( #players > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( players, true ), evolve.colors.white, "?" )
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "preslay", unpack( players ) )
	else
		return "preslay", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )
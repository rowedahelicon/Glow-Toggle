#include <sourcemod>
#include <tf2_stocks>
#include <sdktools>

new Handle:g_toggleFlag;
new Handle:g_toggleCart;
new Handle:g_togglePlayer;

public Plugin:myinfo =
{
name = "Glow Toggle",
author = "Rowedahelicon",
description = "Enables the adjustment of glows on various TF objects",
version = "1.0",
url = "http://www.rowedahelicon.com"
}

public OnPluginStart()
{	
	g_toggleFlag = CreateConVar("glow_toggle_flag", "1", "Adjusts glow toggle for the CTF Flag");
	g_toggleCart = CreateConVar("glow_toggle_cart", "1", "Adjusts glow toggle for the Payload Cart");
	g_togglePlayer = CreateConVar("glow)toggle_player", "1", "Adjusts glow toggle for Players");
	HookEvent("teamplay_flag_event", Event_Flag);
	HookEvent("round_start", Event_RoundStart); 
}

public Event_RoundStart(Handle:hEvent, const String:szEventName[], bool:bDontBroadcast)
{
	//Cart entity
	
	new cart_toggle;
	cart_toggle = GetConVarInt(g_toggleCart);
	
	if(cart_toggle == 1){
		new iCartEnity = -1;
		while ((iCartEnity = FindEntityByClassname(iCartEnity, "team_train_watcher")) != -1)
		{
			SetEntProp(iCartEnity, Prop_Data, "m_hGlowEnt", 0);
		}
	}
return Plugin_Handled;
}

public Event_Flag(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (GetEventInt(event, "eventtype") == TF_FLAGEVENT_PICKEDUP)
    {
	
		new player_toggle;
		player_toggle = GetConVarInt(g_togglePlayer);
		if(player_toggle >= 1){
			new client = GetEventInt(event, "player");
			SetEntProp(client, Prop_Send, "m_bGlowEnabled", 0);
		}

		new flag_toggle;
		flag_toggle = GetConVarInt(g_toggleFlag);
		
		if(flag_toggle >= 1){
			new iFlagEnity = -1;
			while ((iFlagEnity = FindEntityByClassname(iFlagEnity, "item_teamflag")) != -1)
			{
				DispatchKeyValue(iFlagEnity, "OnPickup", "!self,TurnOff,,0,-1");
				AcceptEntityInput(iFlagEnity,"TurnOff");
			}
		}
	
	}
return Plugin_Handled;
}

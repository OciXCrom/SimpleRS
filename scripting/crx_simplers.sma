#include <amxmodx>
#include <colorchat>
#include <cstrike>
#include <fun>

#define PLUGIN_VERSION "1.0"

new g_Message
new const g_Colors[][] = { "!g", "^x04", "!t", "^x03", "!n", "^x01" }

public plugin_init()
{
	register_plugin("Simple Resetscore", PLUGIN_VERSION, "OciXCrom")
	register_cvar("CRXSimpleRS", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	register_clcmd("say /rs", "cmd_reset")
	register_clcmd("say_team /rs", "cmd_reset")
	g_Message = register_cvar("rs_message", "!g[!tSimple Resetscore!g] !t<name> !nhas just reset his score!")
}

public cmd_reset(id)
{
	new szMessage[256], iTeam = get_user_team(id), iType
	get_pcvar_string(g_Message, szMessage, charsmax(szMessage))
	
	for(new i = 0; i < sizeof(g_Colors) - 1; i += 2)
		replace_all(szMessage, charsmax(szMessage), g_Colors[i], g_Colors[i + 1])
	
	if(contain(szMessage, "<name>") != -1)
	{
		new szName[32]
		get_user_name(id, szName, charsmax(szName))
		replace(szMessage, charsmax(szMessage), "<name>", szName)
		iType = 1
	}
		
	set_user_frags(id, 0)
	cs_set_user_deaths(id, 0)
	ColorChat(iType ? id : 0, iTeam == 1 ? RED : iTeam == 2 ? BLUE : GREY, "%s", szMessage)
	return PLUGIN_HANDLED
}
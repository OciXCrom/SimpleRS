#include <amxmodx>
#include <cromchat>
#include <formatin>
#include <reapi>

#define PLUGIN_VERSION "2.0-Re"
#define PH_NAME "<name>"

new g_pMessage
new const g_iScoreInfo = 85
new const g_szCommands[][] = { "/rs", "/resetscore" }

public plugin_init()
{
	register_plugin("Simple Resetscore", PLUGIN_VERSION, "OciXCrom")
	register_cvar("CRXSimpleRS", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED)
	g_pMessage = register_cvar("simplers_message", "&x04[&x03Simple Resetscore&x04] &x03<name> &x01has just reset his score!")
	
	for(new i; i < sizeof(g_szCommands); i++)
	{
		register_clcmd(formatin("say %s", g_szCommands[i]), "Cmd_ResetScore")
		register_clcmd(formatin("say_team %s", g_szCommands[i]), "Cmd_ResetScore")
	}
}

public Cmd_ResetScore(id)
{
	new szMessage[256], iType
	get_pcvar_string(g_pMessage, szMessage, charsmax(szMessage))
	
	if(contain(szMessage, PH_NAME) != -1)
	{
		new szName[32]
		get_user_name(id, szName, charsmax(szName))
		replace(szMessage, charsmax(szMessage), PH_NAME, szName)
		iType = 1
	}
		
	set_entvar(id, var_frags, 0.0)
	set_member(id, m_iDeaths, 0)
	
	message_begin(MSG_ALL, g_iScoreInfo)
	write_byte(id) 
	write_short(0)
	write_short(0)
	write_short(0)
	write_short(0)
	message_end()
	
	CC_SendMatched(iType ? id : 0, id, szMessage)
	return PLUGIN_HANDLED
}
<cfscript>
struct function parseUserAgent(string useragent=cgi.HTTP_USER_AGENT, string filepath="", boolean refresh=false) output=false hint="Parses data (browser, device, os, bot, etc) using user-agent data from OPAWG https://github.com/opawg/user-agents" {
	if (not server.keyExists("UDF_parseUserAgent_data") or arguments.refresh or not isArray(server.UDF_parseUserAgent_data)){
		try {
			server["UDF_parseUserAgent_data"] = deserializeJson(fileRead(arguments.filePath));
		} catch (any error){
			throw(message="Error reading JSON data for parseUserAgent function");
		}
	}
	local.response = [
		"app": ""
		,"device": ""
		,"os": ""
		,"bot": javacast("boolean", false)
	];
	for (local.agent in server.opawg_useragents){
		for (local.test in local.agent.user_agents){
			if (reFind(local.test, arguments.useragent) gt 0) {
				local.result = local.agent;
				break;
			}
		}
		if (local.keyExists("result")) {
			structAppend(local.response, local.result, true);
			break;
		}
	}
	return local.response;
}
</cfscript>

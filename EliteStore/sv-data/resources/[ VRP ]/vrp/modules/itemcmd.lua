RegisterCommand("item",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)

	if user_id and vRP.hasPermission(user_id,"manager.permissao") then
		local item = tostring(args[1])
		local amount = parseInt(args[2])

		if item and item ~= "nil" and amount > 0 then
			
			if vRP.itemBodyList(item) then
				vRP.giveInventoryItem(user_id,item,amount,true)

				TriggerClientEvent("Notify",source,"sucesso","Você recebeu "..amount.."x "..vRP.itemNameList(item)..".")
			else
				TriggerClientEvent("Notify",source,"negado","Esse item não existe.")
			end

		else
			TriggerClientEvent("Notify",source,"negado","Use: /item ITEM QUANTIDADE")
		end
	end
end)

RegisterCommand("dv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)

	if user_id and vRP.hasPermission(user_id,"manager.permissao") then
		TriggerClientEvent("trydeleteveh",source)
	end
end)
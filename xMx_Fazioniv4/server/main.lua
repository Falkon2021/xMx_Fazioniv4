ESX = exports.es_extended:getSharedObject()

--{//} MARCO MODIFY {\\}--
RegisterNetEvent("xMx_fazioni:shoplocale", function(item, prezzo, lavoro, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_society:getSociety', lavoro, function (society)
		if society ~= nil then 
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
				if account.money >= prezzo then 
					xPlayer.addInventoryItem(item, count)
					account.removeMoney(prezzo)
					print("[^5XMX_FAZIONI^7-^1SHOPLOCALE^7] Il Giocatore ".. GetPlayerName(source) .." ha comprato x".. count .." di ".. item .." pagando dal saldo della societa' ".. lavoro .." costo ".. prezzo)
				else
					xPlayer.showNotification("La società non ha abbastanza soldi per pagarlo")
					print("[^5XMX_FAZIONI^7-^1SHOPLOCALE^7] La societa' ".. lavoro .." non ha abbastanza soldi per pagare x".. count .." di ".. item)
				end
			end)
		else 
			print("[^5XMX_FAZIONI^7-^1SHOPLOCALE^7] La societa' non esiste")
		end
	end)
end)

RegisterServerEvent('xMx_fazioni:whsmny')
AddEventHandler('xMx_fazioni:whsmny', function(society, amount, perc)
	local xPlayer = ESX.GetPlayerFromId(source)
    society = tostring(society)
	amount = ESX.Math.Round(tonumber(amount))
    perc = ESX.Math.Round(tonumber(perc))
	if xPlayer and society and amount and perc then
        local account = xPlayer.getAccount('black_money')
        local tassa = (amount/100)*perc
		if xPlayer.job.name == society then
			if account.money >= amount then
                local totale = (amount - tassa)
				xPlayer.removeAccountMoney('black_money', amount)
                xPlayer.addMoney(totale)
                xPlayer.showNotification('Hai pulito '..totale..'$ soldi sporchi')
			else
				xPlayer.showNotification('Non hai abbastanza soldi sporchi', 'error')
			end
		end
	end
end)

for k, v in pairs(Fazioni) do
	AddEventHandler('onServerResourceStart', function(resourceName)
		if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
			Wait(0)
			exports.ox_inventory:RegisterStash(k, v.Nome_server_deposito, v.slot, v.peso)
		end
	end)
end

for k, v in pairs(Fazioni) do
	if v.Registrajob then
		AddEventHandler('onServerResourceStart', function(r)
			if r == 'xMx' or r == 'xMx_Fazioniv4' then
				for k,v in pairs(Fazioni) do 
					-- jobs
					local job = MySQL.Sync.fetchAll('SELECT * FROM jobs WHERE name = @name', {['@name'] = k})
					if job[1] == nil then
						if v.label then
							MySQL.insert('INSERT INTO jobs (name, label, whitelisted) VALUES (?, ?, ?)', {k, v.label, 1})
							print("^2[xMx_Fazioniv4]  ^0Job "..v.label.. " Registrato")
						else
							print("^8[xMx_Fazioniv4]  ^0Label non trovato nel job: "..k)
						end
					end
					-- jobs OFF
					local offjob = MySQL.Sync.fetchAll('SELECT * FROM jobs WHERE name = @name', {['@name'] = 'off'..k})
					if offjob[1] == nil then
						MySQL.insert('INSERT INTO jobs (name, label, whitelisted) VALUES (?, ?, ?)', {'off'..k, 'Fuori Servizio', 1})
					end
					-- job_grades
					local job_grades = MySQL.Sync.fetchAll('SELECT * FROM job_grades WHERE job_name = @nome', {['@nome'] = k})
					if job_grades[1] == nil then
						if v.gradi then
							for a,b in pairs(v.gradi) do
								MySQL.insert('INSERT INTO job_grades (job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', {k, b.grade, b.name, b.label, b.salary})
							end
						else
							print("^8[xMx_Fazioniv4]  ^0Gradi non trovati nel job: "..k)
						end
					end
					-- job_grades OFF
					local job_gradesoff = MySQL.Sync.fetchAll('SELECT * FROM job_grades WHERE job_name = @nome', {['@nome'] = 'off'..k})
					if job_gradesoff[1] == nil then
						if v.gradi then
							for c,d in pairs(v.gradi) do
								MySQL.insert('INSERT INTO job_grades (job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', {'off'..k, d.grade, d.name, d.label, 0})
							end
						else
							print("^8[xMx_Fazioniv4]  ^0Gradi non trovati nel job: "..k)
						end
					end
					-- addon_account
					local addon_account = MySQL.Sync.fetchAll('SELECT * FROM addon_account WHERE name = @nome', {['@nome'] = 'society_'..k})
					if addon_account[1] == nil then
						if v.label then
							MySQL.insert('INSERT INTO addon_account (name, label, shared) VALUES (?, ?, ?)', {'society_'..k, v.label, 1})
						else
							print("^8[xMx_Fazioniv4]  ^Label non trovato nel job: "..k)
						end
					end
					-- addon_account_data
					local addon_account_data = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @nome', {['@nome'] = 'society_'..k})
					if addon_account_data[1] == nil then
						MySQL.insert('INSERT INTO addon_account_data (account_name, money, owner) VALUES (?, ?, ?)', {'society_'..k, 50000, nil})
					end
				end 
			end
		end)
	end
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res \~= nil and res \~= ''
end

local BASE_URL = shared.VapeCustomBase
	or 'https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/main'

local function getCommit()
	if isfile('newvape/profiles/commit.txt') then
		local c = readfile('newvape/profiles/commit.txt')
		if c and #c > 0 then return c end
	end
	return 'main'
end

local function downloadFile(path, func)
	if isfile(path) then
		return (func or readfile)(path)
	end

	if shared.VapeDeveloper then
		error('VapeDeveloper: missing local file ' .. tostring(path))
	end

	local rel = select(1, path:gsub('newvape/', ''))
	local url = BASE_URL
	if url:find('7GrandDadPGN/VapeCompiled') and not url:find('/main') then
		url = 'https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/' .. getCommit()
	end

	local suc, res = pcall(function()
		return game:HttpGet(url .. '/' .. rel, true)
	end)
	if not suc or res == '404: Not Found' then
		error(res or ('failed download ' .. path))
	end

	
	writefile(path, res)
	return (func or readfile)(path)
end

for _, folder in {
	'newvape', 'newvape/games', 'newvape/profiles',
	'newvape/assets', 'newvape/libraries', 'newvape/guis',
} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not isfile('newvape/profiles/commit.txt') then
	writefile('newvape/profiles/commit.txt', 'main')
end
if not isfile('newvape/profiles/asset.txt') then
	writefile('newvape/profiles/asset.txt', '1')
end



return loadstring(downloadFile('newvape/main.lua'), 'main')()

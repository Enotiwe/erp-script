--Update: ������� ��������/������
-- ���������� � �������
script_name('�Auto-Doklad�') 		                    -- ��������� ��� �������
script_version(2.93) 						            -- ��������� ������ ������� / FINAL
script_author('Henrich_Rogge', 'Marshall_Milford', 'Andy_Fawkess') 	-- ��������� ��� ������

-- ����������
require 'lib.moonloader'
require 'lib.sampfuncs'
local dlstatus = require('moonloader').download_status


-- ��������
local nicks = { -- [''] = '',
-- 12+
  ['Yupi_Mean'] = '����', -- ���������.
  ['Andrew_Evonzer'] = '��������', -- ���������.
  ['Grace_Osborn'] = '�����', -- ���������.
  ['Emma_Cooper'] = '����', -- ������������.
  ['Wurn_Linkol'] = '��������', -- ������������.
  ['Kirill_Magomedov'] = '����', -- �����.

-- ���. ������.
  ['Satoshi_Sapporo'] = '����', --�������.
  ['Foxit_Makayonok'] = '���', -- ��������.
  -- ���. ���������.
  ['Alex_Frank'] = '�����', -- ���. ���������.
  ['Martin_Twix'] = '�������', -- ����������.
  ['Charles_Spaze'] = '�����', -- ����������.
  ['Maurice_Spaze'] = '������', -- ����������.
  ['Nika_Black'] = '������', -- ����������.
  
-- �����.
  ['Cherry_Maybach'] = '�����',
  ['Sofa_Meow'] = '����',
  ['Max_Meow'] = '���',
  ['Ayanxkoji_Omalley'] = '����',
  ['Ashley_Spaze'] = '�����',
  ['Shannon_Spaze'] = '�����',
  ['Cameron_Wayne'] = '����',
  ['Lautaro_Spaze'] = '������', 
  ['Chloe_Spaze'] = '������',
  ['Carlos_Yeti'] = '������',
  ['Jeremy_Spaze'] = '�����',
  ['Alex_Beasley'] = '�����',
  ['Amanda_Ray'] = '������',
  ['Jacob_Washington'] = '����',
  ['Sky_Sillence'] = '�����',
  ['Hawii_Tearz'] = '����',
  
-- �������.
  ['Siegmund_Berg'] = '����',
  ['Aiden_Florestino'] = '�������',
  ['Anthony_Diez'] = '�������',
  ['Sergey_Fibo'] = '�����',
  ['Kwenyt_Hokage'] = '��������',
  ['Walter_Moonlight'] = '���',
  ['Kenjiro_Matsukawa'] = '���',
  -- [''] = '',
  -- [''] = '',
  -- [''] = '',
  -- [''] = '',
  -- [''] = '',
  
  
-- ������
  ['Andy_Fawkess'] = '����',
  ['Ayanxkoji_Omalley'] = '����'
}

function main()
  
  -- ��������� �������� �� sampfuncs � SAMP ���� �� ��������� - ������������ � ������
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
  -- ��������� �������� �� SA-MP
	while not isSampAvailable() do wait(100) end
  -- �������� �� �������� �������
  stext('������ ������� ��������!')
  
  -- ������������ �������
  sampRegisterChatCommand('dok', cmd_dok)
  -- ��������� ����� �� ����� �� ������
	while not sampIsLocalPlayerSpawned() do wait(0) end
	-- �������� �� ������������.
  updateScript()
  -- ����������� ���� ��� ���������� ������ �������
  while true do
    wait(0)
  end
end



function cmd_dok(args)
  local info = {}
  if isCharInAnyCar(PLAYER_PED) then
    if #args ~= 0 then
      local mycar = storeCarCharIsInNoSave(PLAYER_PED)
      for i = 0, 999 do
        if sampIsPlayerConnected(i) then
          local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
          if doesCharExist(ichar) then
            if isCharInAnyCar(ichar) then
              local icar = storeCarCharIsInNoSave(ichar)
              if mycar == icar then
                local nicktoid = sampGetPlayerNickname(i)
                if nicks[nicktoid] ~= nil then
                  local call = nicks[nicktoid]
                  table.insert(info, call)
                else
                  local nick = string.gsub(sampGetPlayerNickname(i), "(%u+)%l+_(%w+)", "%1.%2")
                  table.insert(info, nick)
                end
              end
            end
          end
        end
      end
      if #info > 0 then
        sampProcessChatInput(string.format('/r 10-%s, %s.', args, table.concat(info,', ')))
      else
        sampProcessChatInput(string.format('/r 10-%s, solo.', args))
      end
    else
      atext('{808080}���������� | {FFFFFF}�������: /dok ���-���.')
      return
    end
  else
    atext('{808080}������ | {FFFFFF}�� �� ������ � ����������.')
    return
  end
end

-- �Auto-Report� text
function stext(text)
  sampAddChatMessage((' %s {FFFFFF}%s'):format(script.this.name, text), 0xABAFDE)
end

-- � text
function atext(text)
	sampAddChatMessage((' � {FFFFFF}%s'):format(text), 0xABAFDE)
end

-- ����-����������
function updateScript()
	local filepath = os.getenv('TEMP') .. '\\online-update.json'
	downloadUrlToFile('https://raw.githubusercontent.com/Enotiwe/erp-script/main/online-update.json', filepath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			local file = io.open(filepath, 'r')
			if file then
				local info = decodeJson(file:read('*a'))
				updatelink = info.updateurl
				if info and info.latest then
					if tonumber(thisScript().version) < tonumber(info.latest) then
						lua_thread.create(function()
							print('�������� ���������� ����������. ������ �������������� ����� ���� ������.')
							wait(300)
							downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
								if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then print('���������� ������� ������� � �����������.')
								elseif status1 == 64 then print('���������� ������� ������� � �����������.')
								end
							end)
						end)
					else print('���������� ������� �� ����������.') end
				end
			else print('�������� ���������� ������ ���������. �������� ������ ������.') end
		elseif status == 64 then print('�������� ���������� ������ ���������. �������� ������ ������.') end
	end)
end
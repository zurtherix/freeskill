--[[getfenv().maximumDistance = 500
getfenv().showHealth = true
getfenv().showDistance = true
getfenv().boxEspColor = Color3.fromRGB(255, 255, 255)
getfenv().boxEspTransparency = 0.7
getfenv().offsetY = 0 -- best change step = 0.1 (more = gui will be higher) (can be negative)--]]

if getfenv().executed then
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = "FREESKILL";
		Text = "Already executed.";
		Icon = "";
		Duration = 3;
	})
	return
end

getfenv().executed = true

local players = game:GetService("Players")
local player = players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")
local camera = game:GetService("Workspace").CurrentCamera
local runService = game:GetService("RunService")

function onLoad(character)
	local name = ""
	local name2 = ""

	for i, v in pairs(playerGui:GetChildren()) do
		name = v.Name
		for i, v in pairs(playerGui:FindFirstChild(name):GetChildren()) do
			name2 = v.Name
			if name ~= "" and name2 ~= "" then
				break
			else
				continue
			end
		end
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = name
	screenGui.Parent = playerGui
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = math.huge

	local frame = Instance.new("Frame")
	frame.Name = name2
	frame.Parent = screenGui
	frame.Size = UDim2.new(1,0,1,0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.BackgroundTransparency = 1

	local targets = {}
	
	local connection
	connection = runService.RenderStepped:Connect(function()
		local success, errorMessage = pcall(function()
			for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
				if v == character then
					continue
				end
				local checked = true
				for _, vv in pairs(targets) do
					if vv["char"] == v then
						checked = false
					end
				end
				if v:FindFirstChildWhichIsA("Humanoid") and checked then
					if v:IsA("Model") then
						local currentTable = {["name"] = v.Name, ["char"] = v}
						table.insert(targets, currentTable)
					end
				end
			end
			for i, v in pairs(targets) do
				if not v["label"] then
					local char = v["char"]
					local hrp = char:WaitForChild("HumanoidRootPart")
					
					local newLabel = Instance.new("TextLabel")
					newLabel.Name = name2
					newLabel.Parent = frame
					newLabel.AnchorPoint = Vector2.new(0.5, 1)
					newLabel.BackgroundTransparency = 1
					newLabel.Text = v["name"]
					newLabel.Size = UDim2.new(1,0,1,0)
					newLabel.TextScaled = true

					newLabel.Font = Enum.Font.Code
					newLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					newLabel.TextStrokeTransparency = 0

					local newLabel2 = Instance.new("TextLabel")
					newLabel2.Parent = newLabel
					newLabel2.Name = name2
					newLabel2.AnchorPoint = Vector2.new(0.5, 0)
					newLabel2.Size = UDim2.new(0.6,0,0.6,0)
					newLabel2.BackgroundTransparency = 1
					newLabel2.Position = UDim2.new(0.5,0,-0.8 - getfenv().offsetY,0)
					newLabel2.TextScaled = true

					newLabel2.Font = Enum.Font.RobotoMono
					newLabel2.TextColor3 = Color3.fromRGB(177, 177, 177)
					newLabel2.TextTransparency = 0
					newLabel2.TextStrokeTransparency = 0

					local newLabel3 = Instance.new("TextLabel")
					newLabel3.Parent = newLabel
					newLabel3.Name = name
					newLabel3.AnchorPoint = Vector2.new(0.5, 0)
					newLabel3.Size = UDim2.new(0.6,0,0.6,0)
					newLabel3.BackgroundTransparency = 1
					newLabel3.Position = UDim2.new(0.5,0,-0.4 - getfenv().offsetY,0)
					newLabel3.TextScaled = true

					newLabel3.Font = Enum.Font.RobotoMono
					newLabel3.TextTransparency = 0
					newLabel3.TextStrokeTransparency = 0
					
					local newBox = Instance.new("BoxHandleAdornment")
					newBox.Name = name2
					newBox.Parent = newLabel
					newBox.Color3 = getfenv().boxEspColor
					newBox.Transparency = getfenv().boxEspTransparency
					newBox.Adornee = hrp
					newBox.Size = hrp.Size
					newBox.ZIndex = 0
					newBox.Visible = true
					newBox.AlwaysOnTop = true

					v["label"] = newLabel
				else
					if not v["char"]:IsDescendantOf(game:GetService("Workspace")) then
						if v["label"] then
							v["label"]:Destroy()
						end
						table.remove(targets, i)
					else
						local char = v["char"]
						local hum = char:WaitForChild("Humanoid")
						local tool = ""
						local hrp = char:WaitForChild("HumanoidRootPart")
						local vector, onScreen = camera:WorldToViewportPoint(char:WaitForChild("Head").Position)

						local distance = (character:WaitForChild("HumanoidRootPart").Position - hrp.Position).Magnitude

						for i, v in pairs(char:GetChildren()) do
							if v:IsA("Tool") then
								tool = v.Name
								break
							end
						end

						if tool ~= "" then
							v["label"].Text = v["name"] .. " | " .. tool
						else
							v["label"].Text = v["name"]
						end

						local color1 = Color3.fromRGB(227, 70, 49)
						local color2 = Color3.fromRGB(71, 177, 71)
						local newColor = color1:lerp(color2, hum.Health/hum.MaxHealth)

						v["label"][name].TextColor3 = newColor
						v["label"][name].Text = math.floor(hum.Health + 0.5)
						v["label"][name2].Text = math.floor(distance + 0.5)
						v["label"].Position = UDim2.fromOffset(vector.X, vector.Y)
						
						if 1/vector.Z < 0.04 then
							v["label"].Size = UDim2.new(0.04,0,0.04,0)
						else
							v["label"].Size = UDim2.new(1/vector.Z,0,1/vector.Z,0)
						end
						
						if getfenv().showHealth then
							v["label"][name].Visible = true
						else
							v["label"][name].Visible = false
						end
						
						if getfenv().showDistance then
							v["label"][name2].Visible = true
						else
							v["label"][name2].Visible = false
						end
						
						if onScreen and distance <= getfenv().maximumDistance then
							v["label"].Visible = true
						else
							v["label"].Visible = false
						end
					end
				end
			end
		end)
		if not success then
			print(errorMessage)
			connection:Disconnect()
			screenGui:Destroy()
			game:GetService("StarterGui"):SetCore("SendNotification",{
				Title = "FREESKILL";
				Text = "Hmm... Something went wrong. Re-execute, if you want to continue.";
				Icon = "";
				Duration = 10;
			})
			getfenv().executed = false
		end
	end)
end

player.CharacterAdded:Connect(function(character)
	onLoad(character)
end)

if player.Character or player.CharacterAdded:Wait() then
	onLoad(player.Character)
end

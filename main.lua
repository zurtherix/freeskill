--[[getgenv().maximumDistance = 500
getgenv().showHealth = true
getgenv().showDistance = true
getgenv().offsetY = 0 -- best change step = 0.1 (more = gui will be higher) (can be negative)
getgenv().autoExecuteOnFailNLoad = true
getgenv().smoothness = true--]]

if getgenv().executed then
	getgenv().executed = false
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = "FREESKILL";
		Text = "Re-executed.";
		Icon = "";
		Duration = 3;
	})
	task.wait(0.5)
	getgenv().executed = true
else
	getgenv().executed = true
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = "FREESKILL";
		Text = "Executed.";
		Icon = "";
		Duration = 3;
	})
end

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
	
	local connection2
	connection2 = runService.Heartbeat:Connect(function()
		for i, v in pairs(players:GetPlayers()) do
			local passed = true
			for __, vv in pairs(targets) do
				if vv["name"] == v.Name then
					passed = false
					break
				end
			end
			if v.Character and passed and v ~= player then
				local hrp = v.Character:FindFirstChild("HumanoidRootPart")
				local hum = v.Character:FindFirstChildWhichIsA("Humanoid")
				if not hrp or not hum then
					continue
				end

				local currentTable = {["name"] = v.Name, ["char"] = v.Character}
				table.insert(targets, currentTable)
			end
		end
	end)
	
	local connection
	coroutine.wrap(function()
		if getgenv().smoothness then
			connection = runService.RenderStepped:Connect(function()
				local success, errorMessage = pcall(function()
					for i, v in pairs(targets) do
						if not v["label"] then
							local char = v["char"]
							local hrp = char:FindFirstChild("HumanoidRootPart")

							if not hrp then
								return
							end

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
							newLabel2.Position = UDim2.new(0.5,0,-0.8 - getgenv().offsetY,0)
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
							newLabel3.Position = UDim2.new(0.5,0,-0.4 - getgenv().offsetY,0)
							newLabel3.TextScaled = true

							newLabel3.Font = Enum.Font.RobotoMono
							newLabel3.TextTransparency = 0
							newLabel3.TextStrokeTransparency = 0

							v["label"] = newLabel
						end
						if v["label"] then
							if not v["char"] or not v["char"]:IsDescendantOf(game:GetService("Workspace")) then
								if v["label"] then
									v["label"]:Destroy()
								end
								table.remove(targets, i)
							elseif v["char"] and v["char"]:IsDescendantOf(game:GetService("Workspace")) then
								local char = v["char"]
								local hum = char:FindFirstChildWhichIsA("Humanoid")

								if not hum then
									continue
								end

								local tool = ""
								local hrp = char:FindFirstChild("HumanoidRootPart")

								if not hrp then
									continue
								end

								local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

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

								if getgenv().showHealth then
									v["label"][name].Visible = true
								else
									v["label"][name].Visible = false
								end

								if getgenv().showDistance then
									v["label"][name2].Visible = true
								else
									v["label"][name2].Visible = false
								end

								if onScreen and distance <= getgenv().maximumDistance then
									v["label"].Visible = true
								else
									v["label"].Visible = false
								end
							end
						end
					end
				end)
				if not success or not getgenv().executed then
					screenGui:Destroy()
					game:GetService("StarterGui"):SetCore("SendNotification",{
						Title = "FREESKILL";
						Text = "Hmm... Something went wrong.";
						Icon = "";
						Duration = 10;
					})
					getgenv().executed = false
					connection:Disconnect()
					connection2:Disconnect()
					return false
				end
			end)
		else
			while true do
				task.wait(0.05)
				local success, errorMessage = pcall(function()
					for i, v in pairs(targets) do
						if not v["label"] then
							local char = v["char"]
							local hrp = char:FindFirstChild("HumanoidRootPart")

							if not hrp then
								return
							end

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
							newLabel2.Position = UDim2.new(0.5,0,-0.8 - getgenv().offsetY,0)
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
							newLabel3.Position = UDim2.new(0.5,0,-0.4 - getgenv().offsetY,0)
							newLabel3.TextScaled = true

							newLabel3.Font = Enum.Font.RobotoMono
							newLabel3.TextTransparency = 0
							newLabel3.TextStrokeTransparency = 0

							v["label"] = newLabel
						end
						if v["label"] then
							if not v["char"] or not v["char"]:IsDescendantOf(game:GetService("Workspace")) then
								if v["label"] then
									v["label"]:Destroy()
								end
								table.remove(targets, i)
							elseif v["char"] and v["char"]:IsDescendantOf(game:GetService("Workspace")) then
								local char = v["char"]
								local hum = char:FindFirstChildWhichIsA("Humanoid")

								if not hum then
									continue
								end

								local tool = ""
								local hrp = char:FindFirstChild("HumanoidRootPart")

								if not hrp then
									continue
								end

								local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

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

								if getgenv().showHealth then
									v["label"][name].Visible = true
								else
									v["label"][name].Visible = false
								end

								if getgenv().showDistance then
									v["label"][name2].Visible = true
								else
									v["label"][name2].Visible = false
								end

								if onScreen and distance <= getgenv().maximumDistance then
									v["label"].Visible = true
								else
									v["label"].Visible = false
								end
							end
						end
					end
				end)
				if not success or not getgenv().executed then
					screenGui:Destroy()
					game:GetService("StarterGui"):SetCore("SendNotification",{
						Title = "FREESKILL";
						Text = "Hmm... Something went wrong.";
						Icon = "";
						Duration = 10;
					})
					getgenv().executed = false
					connection2:Disconnect()
					return false
				end	
			end
		end
	end)()
end

if player.Character or player.CharacterAdded:Wait() then
	onLoad(player.Character)
end

player.CharacterAdded:Connect(function(addedChar)
	if getgenv().autoExecuteOnFailNLoad then
		onLoad(addedChar)
	end
end)

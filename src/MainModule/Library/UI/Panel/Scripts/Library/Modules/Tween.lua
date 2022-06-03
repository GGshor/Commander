local module = {}

function module.new(Object: Instance, TweenInfo: TweenInfo, Goal)
	local modules = module.Latte.Modules
	local tweenObject = modules.Services.TweenService:Create(Object, TweenInfo, Goal)
	tweenObject.Completed:Connect(function()
		tweenObject:Destroy()
		tweenObject = nil
	end)

	tweenObject:Play()
	return tweenObject
end

return module
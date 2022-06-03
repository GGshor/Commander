local module = {}

local reaction = function(Button: GuiObject, State: string)
	module.Latte.Modules.Animator.Button.Flat[State](Button)
end

module.new = function(Name: string, Text: string?, Parent: Instance, Callback, Arguments: any?)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.Title.Text = Text or Name
	Comp.Hover.BackgroundColor3 = module.Latte.Modules.Stylesheet.ThemeColor
	Comp.Title.TextColor3 = module.Latte.Modules.Stylesheet.ThemeColor
	Comp.Title.Font = module.Latte.Modules.Stylesheet.Fonts.Semibold
	Comp.Hover.UICorner.CornerRadius = module.Latte.Modules.Stylesheet.CornerData.FlatButton

	module.Latte.Modules.Trigger.new(Comp, reaction, 3, false):Connect(function()
		Callback(Arguments)
	end)

	Comp.Parent = Parent
	return Comp
end

return module

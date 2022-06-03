local module = {}

module.new = function(Name: string, Parent: Instance)
	local Comp = script.Comp:Clone()
	Comp.Name = Name
	Comp.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	Comp.ScrollBarImageColor3 = module.Latte.Modules.Stylesheet.Window.ScrollBarColor
	Comp.CanvasSize = UDim2.new(0, 0, 0, 0)
	Comp.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Comp.Parent = Parent

	return Comp
end

return module

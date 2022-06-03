local module = {}
module.Window = {}
module.Menu = {}
module.Button = {
	["Round"] = {},
	["Menu"] = {},
	["Package"] = {},
	["Flat"] = {},
	["Outlined"] = {}
}
module.EasingData = {}

function module.Window.animateIn(Object: GuiObject, UIScale: UIScale, Duration: number|nil)
	Duration = Duration or module.Latte.Modules.Stylesheet.Duration.Short
	UIScale.Scale = 0.95
	Object.Visible = true
	module.Latte.Modules.Fader.FadeIn(Object, Duration/2)
	module.Latte.Modules.Tween.new(UIScale, module.Latte.Modules.TweenInfo[module.EasingData.Window](Duration), {Scale = 1})
end

function module.Window.animateOut(Object: GuiObject, UIScale: UIScale, Duration: number|nil)
	Duration = Duration or module.Latte.Modules.Stylesheet.Duration.Short
	module.Latte.Modules.Fader.FadeOut(Object, Duration/2)
	module.Latte.Modules.Tween.new(UIScale, module.Latte.Modules.TweenInfo[module.EasingData.WindowOut](Duration), {Scale = 0.95}).Completed:Connect(function()
		Object.Visible = false
	end)
end

function module.Menu.animateIn(Object: GuiObject, Duration: number|nil)
	Duration = Duration or module.Latte.Modules.Stylesheet.Duration.Short
	module.Latte.Modules.Fader.FadeIn(Object, Duration/2)
	module.Latte.Modules.Tween.new(Object, module.Latte.Modules.TweenInfo[module.EasingData.Menu](Duration), {Position = UDim2.new(0, 0, 0, 0)})
end

function module.Menu.animateOut(Object: GuiObject, Duration: number|nil)
	Duration = Duration or module.Latte.Modules.Stylesheet.Duration.Short
	module.Latte.Modules.Fader.FadeOut(Object, Duration/2)
	module.Latte.Modules.Tween.new(Object, module.Latte.Modules.TweenInfo[module.EasingData.MenuOut](Duration), {Position = UDim2.new(-0.35, -2, 0, 0)})
end

function module.Button.Round.Hover(Object: GuiObject)
	local short = module.Latte.Modules.Stylesheet.Duration.Short
	local scalingTweenInfo = module.Latte.Modules.TweenInfo[module.EasingData.Round](short)
	local fadingTweenInfo = module.Latte.Modules.TweenInfo[module.EasingData.Fading](short)
	module.Latte.Modules.Tween.new(Object.Hover, fadingTweenInfo, {BackgroundTransparency = 0.9})
	module.Latte.Modules.Tween.new(Object.Hover.UIScale, scalingTweenInfo, {Scale = 1})
end

function module.Button.Round.Hold(Object: GuiObject)
	local short = module.Latte.Modules.Stylesheet.Duration.Short
	local fadingTweenInfo = module.Latte.Modules.TweenInfo[module.EasingData.Fading](short)
	module.Latte.Modules.Tween.new(Object.Hover, fadingTweenInfo, {BackgroundTransparency = 0.85})
end

function module.Button.Round.Over(Object: GuiObject)
	local short = module.Latte.Modules.Stylesheet.Duration.Short
	local scalingTweenInfo = module.Latte.Modules.TweenInfo[module.EasingData.RoundOut](short)
	local fadingTweenInfo = module.Latte.Modules.TweenInfo[module.EasingData.Fading](short)
	module.Latte.Modules.Tween.new(Object.Hover, fadingTweenInfo, {BackgroundTransparency = 1})
	module.Latte.Modules.Tween.new(Object.Hover.UIScale, scalingTweenInfo, {Scale = 0})
end

function module.Button.Menu.Hover(Object: GuiObject)
	local veryShort = module.Latte.Modules.Stylesheet.Duration.VeryShort
	local fadingTweenInfo = module.Latte.Modules.TweenInfo[module.EasingData.Fading](veryShort)
	module.Latte.Modules.Tween.new(Object, fadingTweenInfo, {BackgroundTransparency = 0.95})
end

function module.Button.Menu.Hold(Object: GuiObject)
	local veryShort = module.Latte.Modules.Stylesheet.Duration.VeryShort
	local fadingTweenInfo = module.Latte.Modules.TweenInfo[module.EasingData.Fading](veryShort)
	module.Latte.Modules.Tween.new(Object, fadingTweenInfo, {BackgroundTransparency = 0.8})
end

function module.Button.Menu.Over(Object: GuiObject)
	local veryShort = module.Latte.Modules.Stylesheet.Duration.VeryShort
	local fadingTweenInfo = module.Latte.Modules.TweenInfo[module.EasingData.Fading](veryShort)
	module.Latte.Modules.Tween.new(Object, fadingTweenInfo, {BackgroundTransparency = 1})
end

function module.Button.Flat.Hover(Object: GuiObject)
	module.Button.Menu.Hover(Object.Hover)
end

function module.Button.Flat.Hold(Object: GuiObject)
	module.Button.Menu.Hold(Object.Hover)
end

function module.Button.Flat.Over(Object: GuiObject)
	module.Button.Menu.Over(Object.Hover)
end

function module.Button.Outlined.Hover(Object: GuiObject)
	module.Button.Menu.Hover(Object.Background)
end

function module.Button.Outlined.Hold(Object: GuiObject)
	module.Button.Menu.Hold(Object.Background)
end

function module.Button.Outlined.Over(Object: GuiObject)
	module.Button.Menu.Over(Object.Background)
end

function module.Button.Package.Hover(Object: GuiObject)
	Object.Container.BackgroundTransparency = 0
	Object.Container.Accent.Visible = false
	Object.Shadow.Visible = true
end

function module.Button.Package.Hold(Object: GuiObject)
end

function module.Button.Package.Over(Object: GuiObject)
	Object.Container.BackgroundTransparency = 1
	Object.Container.Accent.Visible = true
	Object.Shadow.Visible = false
end

return module
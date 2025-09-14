-- sowwy i pasted ts im gonna make my own drawin lib next upd

local c=game:GetService("CoreGui")local cam=workspace.CurrentCamera
local g=Instance.new("ScreenGui")g.Name="Drawing | Glacier"g.IgnoreGuiInset=true
g.DisplayOrder=0x7fffffff;g.Parent=c
local i=0
local f={[0]=Font.fromEnum(Enum.Font.Roboto),[1]=Font.fromEnum(Enum.Font.Legacy),[2]=Font.fromEnum(Enum.Font.SourceSans),[3]=Font.fromEnum(Enum.Font.RobotoMono)}
local function p(n)return f[n]end
local function q(t)return math.clamp(1-t,0,1)end
local b=setmetatable({
	Visible=true,ZIndex=0,Transparency=1,Color=Color3.new(),
	Remove=function(s)setmetatable(s,nil)end,
	Destroy=function(s)setmetatable(s,nil)end,
	SetProperty=function(s,k,v) if s[k]~=nil then s[k]=v else warn("Attempted to set invalid property: "..tostring(k)) end end,
	GetProperty=function(s,k) if s[k]~=nil then return s[k] else warn("Attempted to get invalid property: "..tostring(k)) return nil end end,
	SetParent=function(s,p) s.Parent=p end
},{__add=function(a,b) local r={} for k,v in pairs(a)do r[k]=v end for k,v in pairs(b)do r[k]=v end return r end})
local D={}D.Fonts={["UI"]=0,["System"]=1,["Plex"]=2,["Monospace"]=3}
function D.new(t)i+=1
	if t=="Line"then return D.createLine() elseif t=="Text"then return D.createText() elseif t=="Circle"then return D.createCircle() elseif t=="Square"then return D.createSquare() elseif t=="Image"then return D.createImage() elseif t=="Quad"then return D.createQuad() elseif t=="Triangle"then return D.createTriangle() elseif t=="Frame"then return D.createFrame() elseif t=="ScreenGui"then return D.createScreenGui() elseif t=="TextButton"then return D.createTextButton() elseif t=="TextLabel"then return D.createTextLabel() elseif t=="TextBox"then return D.createTextBox() else error("Invalid drawing type: "..t) end end

function D.createLine()
	local o=({From=Vector2.zero,To=Vector2.zero,Thickness=1}+b)
	local F=Instance.new("Frame")F.Name=i;F.AnchorPoint=Vector2.new(0.5,0.5);F.BorderSizePixel=0;F.Parent=g
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="From" or k=="To" then
				local dir=(k=="From" and o.To or v)-(k=="From" and v or o.From)
				local cen=(o.To+o.From)/2
				local dist=dir.Magnitude
				local th=math.deg(math.atan2(dir.Y,dir.X))
				F.Position=UDim2.fromOffset(cen.X,cen.Y);F.Rotation=th;F.Size=UDim2.fromOffset(dist,o.Thickness)
			elseif k=="Thickness" then F.Size=UDim2.fromOffset((o.To-o.From).Magnitude,v)
			elseif k=="Visible" then F.Visible=v
			elseif k=="ZIndex" then F.ZIndex=v
			elseif k=="Transparency" then F.BackgroundTransparency=q(v)
			elseif k=="Color" then F.BackgroundColor3=v
			elseif k=="Parent" then F.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() F:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createText()
	local o=({Text="",Font=D.Fonts.UI,Size=0,Position=Vector2.zero,Center=false,Outline=false,OutlineColor=Color3.new()}+b)
	local L,stroke=Instance.new("TextLabel"),Instance.new("UIStroke")
	L.Name=i;L.AnchorPoint=Vector2.new(0.5,0.5);L.BorderSizePixel=0;L.BackgroundTransparency=1
	local function u()
		local tb=L.TextBounds
		local off=tb/2
		L.Size=UDim2.fromOffset(tb.X,tb.Y)
		L.Position=UDim2.fromOffset(o.Position.X+(not o.Center and off.X or 0),o.Position.Y+off.Y)
	end
	L:GetPropertyChangedSignal("TextBounds"):Connect(u)
	stroke.Thickness=1;stroke.Enabled=o.Outline;stroke.Color=o.Color
	L.Parent,stroke.Parent=g,L
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="Text" then L.Text=v
			elseif k=="Font" then L.FontFace=p(math.clamp(v,0,3))
			elseif k=="Size" then L.TextSize=v
			elseif k=="Position" then u()
			elseif k=="Center" then L.Position=UDim2.fromOffset((v and cam.ViewportSize/2 or o.Position).X,o.Position.Y)
			elseif k=="Outline" then stroke.Enabled=v
			elseif k=="OutlineColor" then stroke.Color=v
			elseif k=="Visible" then L.Visible=v
			elseif k=="ZIndex" then L.ZIndex=v
			elseif k=="Transparency" then local t=q(v);L.TextTransparency=t;stroke.Transparency=t
			elseif k=="Color" then L.TextColor3=v
			elseif k=="Parent" then L.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() L:Destroy();o:Remove() end
			elseif k=="TextBounds" then return L.TextBounds end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createCircle()
	local o=({Radius=150,Position=Vector2.zero,Thickness=0.7,Filled=false}+b)
	local F,corner,stroke=Instance.new("Frame"),Instance.new("UICorner"),Instance.new("UIStroke")
	F.Name=i;F.AnchorPoint=Vector2.new(0.5,0.5);F.BorderSizePixel=0
	corner.CornerRadius=UDim.new(1,0);F.Size=UDim2.fromOffset(o.Radius,o.Radius)
	stroke.Thickness=o.Thickness;stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	F.Parent,corner.Parent,stroke.Parent=g,F,F
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="Radius" then local r=v*2;F.Size=UDim2.fromOffset(r,r)
			elseif k=="Position" then F.Position=UDim2.fromOffset(v.X,v.Y)
			elseif k=="Thickness" then stroke.Thickness=math.clamp(v,0.6,0x7fffffff)
			elseif k=="Filled" then F.BackgroundTransparency=v and q(o.Transparency) or 1;stroke.Enabled=not v
			elseif k=="Visible" then F.Visible=v
			elseif k=="ZIndex" then F.ZIndex=v
			elseif k=="Transparency" then local t=q(v);F.BackgroundTransparency=o.Filled and t or 1;stroke.Transparency=t
			elseif k=="Color" then F.BackgroundColor3=v;stroke.Color=v
			elseif k=="Parent" then F.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() F:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createSquare()
	local o=({Size=Vector2.zero,Position=Vector2.zero,Thickness=0.7,Filled=false}+b)
	local F,stroke=Instance.new("Frame"),Instance.new("UIStroke")
	F.Name=i;F.BorderSizePixel=0;F.Parent,stroke.Parent=g,F
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="Size" then F.Size=UDim2.fromOffset(v.X,v.Y)
			elseif k=="Position" then F.Position=UDim2.fromOffset(v.X,v.Y)
			elseif k=="Thickness" then stroke.Thickness=math.clamp(v,0.6,0x7fffffff)
			elseif k=="Filled" then F.BackgroundTransparency=v and q(o.Transparency) or 1;stroke.Enabled=not v
			elseif k=="Visible" then F.Visible=v
			elseif k=="ZIndex" then F.ZIndex=v
			elseif k=="Transparency" then local t=q(v);F.BackgroundTransparency=o.Filled and t or 1;stroke.Transparency=t
			elseif k=="Color" then F.BackgroundColor3=v;stroke.Color=v
			elseif k=="Parent" then F.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() F:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createImage()
	local o=({Data="",DataURL="rbxassetid://0",Size=Vector2.zero,Position=Vector2.zero}+b)
	local I=Instance.new("ImageLabel")I.Name=i;I.BorderSizePixel=0;I.ScaleType=Enum.ScaleType.Stretch;I.BackgroundTransparency=1;I.Parent=g
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="Data" then
			elseif k=="DataURL" then I.Image=v
			elseif k=="Size" then I.Size=UDim2.fromOffset(v.X,v.Y)
			elseif k=="Position" then I.Position=UDim2.fromOffset(v.X,v.Y)
			elseif k=="Visible" then I.Visible=v
			elseif k=="ZIndex" then I.ZIndex=v
			elseif k=="Transparency" then I.ImageTransparency=q(v)
			elseif k=="Color" then I.ImageColor3=v
			elseif k=="Parent" then I.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() I:Destroy();o:Remove() end
			elseif k=="Data" then return nil end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createQuad()
	local o=({PointA=Vector2.zero,PointB=Vector2.zero,PointC=Vector2.zero,PointD=Vector2.zero,Thickness=1,Filled=false}+b)
	local L={A=D.createLine(),B=D.createLine(),C=D.createLine(),D=D.createLine()}
	local F=Instance.new("Frame")F.Name=tostring(i).." _Fill";F.BorderSizePixel=0;F.BackgroundTransparency=o.Transparency;F.BackgroundColor3=o.Color;F.ZIndex=o.ZIndex;F.Visible=o.Visible and o.Filled;F.Parent=g
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="PointA" then L.A.From=v;L.B.To=v
			elseif k=="PointB" then L.B.From=v;L.C.To=v
			elseif k=="PointC" then L.C.From=v;L.D.To=v
			elseif k=="PointD" then L.D.From=v;L.A.To=v
			elseif k=="Thickness" or k=="Visible" or k=="Color" or k=="ZIndex" then
				for _,ln in pairs(L)do ln[k]=v end
				if k=="Visible" then F.Visible=v and o.Filled elseif k=="Color" then F.BackgroundColor3=v elseif k=="ZIndex" then F.ZIndex=v end
			elseif k=="Filled" then for _,ln in pairs(L)do ln.Transparency=v and 1 or o.Transparency end;F.Visible=v
			elseif k=="Parent" then F.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() for _,ln in pairs(L)do ln:Remove() end;F:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createTriangle()
	local o=({PointA=Vector2.zero,PointB=Vector2.zero,PointC=Vector2.zero,Thickness=1,Filled=false}+b)
	local L={A=D.createLine(),B=D.createLine(),C=D.createLine()}
	local F=Instance.new("Frame")F.Name=tostring(i).." _Fill";F.BorderSizePixel=0;F.BackgroundTransparency=o.Transparency;F.BackgroundColor3=o.Color;F.ZIndex=o.ZIndex;F.Visible=o.Visible and o.Filled;F.Parent=g
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="PointA" then L.A.From=v;L.B.To=v
			elseif k=="PointB" then L.B.From=v;L.C.To=v
			elseif k=="PointC" then L.C.From=v;L.A.To=v
			elseif k=="Thickness" or k=="Visible" or k=="Color" or k=="ZIndex" then
				for _,ln in pairs(L)do ln[k]=v end
				if k=="Visible" then F.Visible=v and o.Filled elseif k=="Color" then F.BackgroundColor3=v elseif k=="ZIndex" then F.ZIndex=v end
			elseif k=="Filled" then for _,ln in pairs(L)do ln.Transparency=v and 1 or o.Transparency end;F.Visible=v
			elseif k=="Parent" then F.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() for _,ln in pairs(L)do ln:Remove() end;F:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createFrame()
	local o=({Size=UDim2.new(0,100,0,100),Position=UDim2.new(0,0,0,0),Color=Color3.new(1,1,1),Transparency=0,Visible=true,ZIndex=1}+b)
	local F=Instance.new("Frame")F.Name=i;F.Size=o.Size;F.Position=o.Position;F.BackgroundColor3=o.Color;F.BackgroundTransparency=q(o.Transparency);F.Visible=o.Visible;F.ZIndex=o.ZIndex;F.BorderSizePixel=0;F.Parent=g
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="Size" then F.Size=v
			elseif k=="Position" then F.Position=v
			elseif k=="Color" then F.BackgroundColor3=v
			elseif k=="Transparency" then F.BackgroundTransparency=q(v)
			elseif k=="Visible" then F.Visible=v
			elseif k=="ZIndex" then F.ZIndex=v
			elseif k=="Parent" then F.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() F:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createScreenGui()
	local o=({IgnoreGuiInset=true,DisplayOrder=0,ResetOnSpawn=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Enabled=true}+b)
	local S=Instance.new("ScreenGui")S.Name=i;S.IgnoreGuiInset=o.IgnoreGuiInset;S.DisplayOrder=o.DisplayOrder;S.ResetOnSpawn=o.ResetOnSpawn;S.ZIndexBehavior=o.ZIndexBehavior;S.Enabled=o.Enabled;S.Parent=c
	return setmetatable({Parent=c},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="IgnoreGuiInset" then S.IgnoreGuiInset=v
			elseif k=="DisplayOrder" then S.DisplayOrder=v
			elseif k=="ResetOnSpawn" then S.ResetOnSpawn=v
			elseif k=="ZIndexBehavior" then S.ZIndexBehavior=v
			elseif k=="Enabled" then S.Enabled=v
			elseif k=="Parent" then S.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() S:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createTextButton()
	local o=({Text="Button",Font=D.Fonts.UI,Size=20,Position=UDim2.new(0,0,0,0),Color=Color3.new(1,1,1),BackgroundColor=Color3.new(0.2,0.2,0.2),Transparency=0,Visible=true,ZIndex=1,MouseButton1Click=nil}+b)
	local B=Instance.new("TextButton")B.Name=i;B.Text=o.Text;B.FontFace=p(o.Font);B.TextSize=o.Size;B.Position=o.Position;B.TextColor3=o.Color;B.BackgroundColor3=o.BackgroundColor;B.BackgroundTransparency=q(o.Transparency);B.Visible=o.Visible;B.ZIndex=o.ZIndex;B.Parent=g
	local evs={}
	return setmetatable({Parent=g,Connect=function(_,en,cb) if en=="MouseButton1Click" then if evs[en] then evs[en]:Disconnect() end evs[en]=B.MouseButton1Click:Connect(cb) else warn("Invalid event: "..tostring(en)) end end},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="Text" then B.Text=v
			elseif k=="Font" then B.FontFace=p(math.clamp(v,0,3))
			elseif k=="Size" then B.TextSize=v
			elseif k=="Position" then B.Position=v
			elseif k=="Color" then B.TextColor3=v
			elseif k=="BackgroundColor" then B.BackgroundColor3=v
			elseif k=="Transparency" then B.BackgroundTransparency=q(v)
			elseif k=="Visible" then B.Visible=v
			elseif k=="ZIndex" then B.ZIndex=v
			elseif k=="Parent" then B.Parent=v
			elseif k=="MouseButton1Click" then if typeof(v)=="function" then if evs["MouseButton1Click"] then evs["MouseButton1Click"]:Disconnect() end evs["MouseButton1Click"]=B.MouseButton1Click:Connect(v) else warn("Invalid value for MouseButton1Click: expected function, got "..typeof(v)) end end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() B:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createTextLabel()
	local o=({Text="Label",Font=D.Fonts.UI,Size=20,Position=UDim2.new(0,0,0,0),Color=Color3.new(1,1,1),BackgroundColor=Color3.new(0.2,0.2,0.2),Transparency=0,Visible=true,ZIndex=1}+b)
	local L=Instance.new("TextLabel")L.Name=i;L.Text=o.Text;L.FontFace=p(o.Font);L.TextSize=o.Size;L.Position=o.Position;L.TextColor3=o.Color;L.BackgroundColor3=o.BackgroundColor;L.BackgroundTransparency=q(o.Transparency);L.Visible=o.Visible;L.ZIndex=o.ZIndex;L.Parent=g
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="Text" then L.Text=v
			elseif k=="Font" then L.FontFace=p(math.clamp(v,0,3))
			elseif k=="Size" then L.TextSize=v
			elseif k=="Position" then L.Position=v
			elseif k=="Color" then L.TextColor3=v
			elseif k=="BackgroundColor" then L.BackgroundColor3=v
			elseif k=="Transparency" then L.BackgroundTransparency=q(v)
			elseif k=="Visible" then L.Visible=v
			elseif k=="ZIndex" then L.ZIndex=v
			elseif k=="Parent" then L.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() L:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

function D.createTextBox()
	local o=({Text="",Font=D.Fonts.UI,Size=20,Position=UDim2.new(0,0,0,0),Color=Color3.new(1,1,1),BackgroundColor=Color3.new(0.2,0.2,0.2),Transparency=0,Visible=true,ZIndex=1}+b)
	local T=Instance.new("TextBox")T.Name=i;T.Text=o.Text;T.FontFace=p(o.Font);T.TextSize=o.Size;T.Position=o.Position;T.TextColor3=o.Color;T.BackgroundColor3=o.BackgroundColor;T.BackgroundTransparency=q(o.Transparency);T.Visible=o.Visible;T.ZIndex=o.ZIndex;T.Parent=g
	return setmetatable({Parent=g},{
		__newindex=function(_,k,v)
			if o[k]==nil then warn("Invalid property: "..tostring(k));return end
			if k=="Text" then T.Text=v
			elseif k=="Font" then T.FontFace=p(math.clamp(v,0,3))
			elseif k=="Size" then T.TextSize=v
			elseif k=="Position" then T.Position=v
			elseif k=="Color" then T.TextColor3=v
			elseif k=="BackgroundColor" then T.BackgroundColor3=v
			elseif k=="Transparency" then T.BackgroundTransparency=q(v)
			elseif k=="Visible" then T.Visible=v
			elseif k=="ZIndex" then T.ZIndex=v
			elseif k=="Parent" then T.Parent=v end
			o[k]=v
		end,
		__index=function(_,k)
			if k=="Remove" or k=="Destroy" then return function() T:Destroy();o:Remove() end end
			return o[k]
		end,
		__tostring=function() return "Drawing" end
	})
end

local funcs={}
function funcs.isrenderobj(o)local s,ok=pcall(function()return o.Parent==g end) if not s then return false end return ok end
function funcs.getrenderproperty(o,k)local s,v=pcall(function()return o[k]end) if not s then return end if v~=nil then return v end end
function funcs.setrenderproperty(o,k,v) assert(funcs.getrenderproperty(o,k),"' "..tostring(k).."' is not a valid property of "..tostring(o)..", "..tostring(typeof(o))) o[k]=v end
function funcs.cleardrawcache() for _,d in pairs(g:GetDescendants())do if d.Remove then pcall(function() d:Remove() end) else pcall(function() d:Destroy() end) end end end

return {Drawing=D,functions=funcs}

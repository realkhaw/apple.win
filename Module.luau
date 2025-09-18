local a:{[string]:any}=(getgenv and getgenv())or getfenv()

type Functions=(...any)->...any
type InstanceOrNil=Instance?
type Players=typeof(game:GetService"Players")
type RobloxService=typeof(game:GetService"Players")
type CollectionService=typeof(game:GetService"CollectionService")
type LocalPlayer=Player
type RBXScriptSignal=RBXScriptSignal
type SignalConnection=typeof(({}::any).new())

type CloneService={
clone:(func:Functions)->Functions,
reference:(inst:Instance)->Instance,
RF:(self:CloneService,fnName:string)->Functions,
RS:(self:CloneService,service:InstanceOrNil)->InstanceOrNil,
init:(self:CloneService)->()
}

type RobloxServiceModule={
GetService:(self:RobloxServiceModule,service:string)->RobloxService
}

type IntellisenseModule={
base:string,
fetch:(self:IntellisenseModule,path:string)->any
}

type ConnectionsModule={
CollectionService:CollectionService,
create:(Events:RBXScriptSignal,Action:Functions)->(),
InstanceAdded:(self:ConnectionsModule,Tag:string)->{Instance}
}

type ConnectionClass={
Connected:boolean,
Function:Functions?,
Signal:any?,
Disconnect:(self:ConnectionClass)->(),
Fire:(self:ConnectionClass,...any)->(),
new:()->ConnectionClass
}

type SignalClass={
Connections:{ConnectionClass},
Connect:(self:SignalClass,Function:Functions)->ConnectionClass,
Once:(self:SignalClass,Function:Functions)->(),
Wait:(self:SignalClass)->any?,
Fire:(self:SignalClass,...any)->(),
new:()->SignalClass
}

type PlayerModule={
Players:Players,
LocalPlayer:LocalPlayer,
Distance:(self:PlayerModule,value:any)->number,
GetHealth:(self:PlayerModule,Character:Model)->number,
Alive:(self:PlayerModule,Character:Model)->boolean
}

type Movement={
Formater:(self:Movement,type:string,value:any)->(Vector3|CFrame),
Teleport:(self:Movement,Targets:BasePart,Position:any)->(),
new:(BasePart:BasePart,Time:number,style:Enum.EasingStyle,Action:{[string]:any})->(Tween)
}

local b:{[string]:any}={}do

b.CloneService=(function():CloneService
local c:CloneService={
clone=a.clonefunction and a.clonefunction(a.clonefunction)or function(c)return c end,
reference=a.clonefunction and a.clonefunction(a.cloneref)or function(c)return c end
}

function c.RF(d,e:string):Functions
local f=rawget(a,e)
return if f and typeof(f)=="function"then d.clone(f)else function(...)return...end
end

function c.RS(d,e:InstanceOrNil):InstanceOrNil
return if e then d.reference(e)else warn"nil arguments"
end

function c.init(d):()
for e,f in pairs(a)do
if typeof(f)=="function"then
rawset(a,e,d:RF(e))
end
end
end

c:init()
return c
end)()

b.RobloxService=(function():RobloxServiceModule
local c:RobloxServiceModule={}

function c.GetService(d,e:string):RobloxService
return b.CloneService:RS(game:GetService(e))
end

return c
end)()

b.Intellisense=(function():IntellisenseModule
local c:IntellisenseModule={base="https://raw.githubusercontent.com/realkhaw/apple.win/refs/heads/main/"}

function c.fetch(d,e:string):any
return loadstring(game:HttpGet(d.base..e:gsub("@self","")))()
end

return c
end)()

b.Connections=(function():ConnectionsModule
local c:ConnectionsModule={CollectionService=b.RobloxService:GetService"CollectionService"}
local d:CollectionService=c.CollectionService

function c.create(e:RBXScriptSignal,f:Functions):()
table.insert(c,e:Connect(f))
end

function c.InstanceAdded(e,f:string):{Instance}
local g:{Instance}=d:GetTagged(f)

e.create(d:GetInstanceAddedSignal(f),function(h:Instance)
table.insert(g,h)
end)

return g
end

return c
end)()

b.Signal=(function():SignalClass
local c:SignalClass={}
local d:ConnectionClass={}

d.__index=d do
function d.Disconnect(e):()
if not e.Connected then return end
local f:number?=table.find(e.Signal,e)
if f then table.remove(e.Signal,f)end
e.Function=nil
e.Connected=false
end

function d.Fire(e,...:any):()
if not e.Function then return end
task.spawn(e.Function,...)
end

function d.new():ConnectionClass
return setmetatable({Connected=true},d)
end
end

c.__index=c do
function c.Connect(e,f:Functions):ConnectionClass
local g=d.new()
g.Function=f
g.Signal=e
table.insert(e.Connections,g)
return g
end

function c.Once(e,f:Functions):()
local g
g=e:Connect(function(...)
f(...)
g:Disconnect()
end)
return g
end

function c.Wait(e):any?
local f=coroutine.running()
local g
g=e:Connect(function(...)
g:Disconnect()
task.spawn(f,...)
end)
return coroutine.yield()
end

function c.Fire(e,...:any):()
for f,g in ipairs(e.Connections)do
if g.Connected then
g:Fire(...)
end
end
end

function c.new():SignalClass
return setmetatable({Connections={}},c)
end
end

return c
end)()

b.Player=(function():PlayerModule
local c:PlayerModule={Players=b.RobloxService:GetService"Players"}
local d:Players=c.Players
local e:LocalPlayer=d.LocalPlayer
c.LocalPlayer=e

function c.Distance(f,g:any):number
if not g then return end

local h:Vector3?=if typeof(g)=="Vector3"then g else nil
local i:Vector3?=if g:IsA"Model"then g:GetPivot().Position else nil
local j:Vector3?=if g:IsA"BasePart"then g.Position else nil

return e:DistanceFromCharacter(h or i or j or g)
end

function c.GetHealth(f,g:Model):number
if not g then return 0 end

local h:Humanoid?=g:FindFirstChildOfClass"Humanoid"

return if not h then 0 else(h.Health/h.MaxHealth)*100
end

function c.Alive(f,g:Model):boolean
if not g then return false end

local h:Humanoid?=g:FindFirstChildOfClass"Humanoid"
local i:BasePart?=g:FindFirstChild"HumanoidRootPart"

return(h and h.Health>0 and i)~=nil
end

local f:Movement={}do
local g=b.RobloxService:GetService"TweenService"
f.TweenService=g

function f.Formater(h,i:string,j:any):Vector3|CFrame
if not i or not j then return warn"nil args to formater"end

local k:Vector3?=if typeof(j)=="Vector3"then j else nil
local l:Vector3?=if j:IsA"Model"then j:GetPivot().Position else nil
local m:Vector3?=if j:IsA"BasePart"then j.Position else nil

local n:Vector3=k or l or m or j
local o:Vector3=if i and i=="Vector"then n else CFrame.new(n)

return o
end

function f.Teleport(h,i:BasePart,j:any):()
if not i then return end

local k=j and h:Formater("CFrame",j)or nil

i.CFrame=k
end

function f.new(h:BasePart,i:number,j:Enum.EasingStyle,k:{[string]:any}):(Tween)
return g:Create(h,TweenInfo.new(i,Enum.EasingStyle[j]),k)
end
end

return c
end)()

b.Components=(function()

end)()

b.Eye=(function()
local c={}

return c
end)()

b.EntitySimulation=(function()
local c={}
local d:PlayerModule=b.Player
local e:CollectionService=b.Connections.CollectionService

function c.Check(f,g:string|{string},h:Model)
if g==nil then
return true
end

if type(g)=="table"then
return table.find(g,h.Name)
end

if type(g)=="string"then
return h.Name==g
end

return false
end

function c.Alive(f,g:Model):boolean
if not g then return false end

local h:Humanoid?=g:FindFirstChildOfClass"Humanoid"
local i:BasePart?=g:FindFirstChild"HumanoidRootPart"

return(h and h.Health>0 and i)~=nil
end

function c.Multi(f,g:Folder,h:string|{string},i:number,j:()->(boolean))
local k={}

for l,m in pairs(g:GetChildren())do
if not m:IsA"Model"then continue end
if not f:Check(h,m)then continue end

if(j and j(m))or f:Alive(m)then
if d:Distance(m)<i then
table.insert(k,m)
end
end
end

return k
end

function c.Simple(f,g:Folder,h:string|{string},i:number,j:()->(boolean))
local k:Model?
local l:number=i

for m,n in pairs(g:GetChildren())do
if not n:IsA"Model"then continue end
if not f:Check(h,n)then continue end

local o=(j and j(n))or f:Alive(n)
if not o then continue end

local p=d:Distance(n)

if p<l then
l=p
k=n
end
end

return k
end

function c.ByTags(f,g:string,h:string|{string},i:number,j:()->(boolean))
local k:{Model?}=e:GetTagged(g)
local l:Model?
local m:number=i

for n,o in pairs(k)do
if not o:IsA"Model"then continue end
if not f:Check(h,o)then continue end

local p=(j and j(o))or f:Alive(o)
if not p then continue end

local q=d:Distance(o)

if q<m then
m=q
l=o
end
end

return l
end

return c
end)()

b.Visualized=(function()

end)
end

return b

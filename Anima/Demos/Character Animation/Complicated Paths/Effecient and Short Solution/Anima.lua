--[[
    Anima: The unofficial Keyframe animation library of LOVE2D
    Licensed Under GPLv3
    Author: Neer 
]]

local Anima={mark={x=0,y=0,r=0,sx=0,sy=0,op=0},key={x=0,y=0,r=0,sx=0,sy=0,op=0},x=0,y=0,r=0,sx=0,sy=0,op=0,animStart=false,animOver=false,animEnd=false}
--note that animOver(private) is for internal usage and animEnd(public) is for external usage
function Anima:init()
    local obj={
        key={x=0,y=0,r=0,sx=0,sy=0,op=0},
        mark={x=0,y=0,r=0,sx=0,sy=0,op=0},
        x=self.x,y=self.y,r=self.r,sx=self.sx,sy=self.sy,op=self.op,
        animStart=self.animStart,animOver=self.animOver,animEnd=self.animEnd}
    setmetatable(obj,self)
    self.__index=self
    return obj
end

function Anima:newAnimation(animation,...)
    if animation=='scale' then
        self.key.sx,self.key.sy,mark=...
    elseif animation=='move' then
        self.key.x,self.key.y,mark=...
    elseif animation=='rotate' then
        self.key.r,mark=...
    elseif animation=='opacity' then
        self.key.op,mark=...
    else
        self.key.x,self.key.y,self.key.r,self.key.sx,self.key.sy,self.op,mark=animation,...
    end
    self.key.sx=self.key.sx or 0
    self.key.sy=self.key.sy or 0
    self.key.x=self.key.x or 0
    self.key.y=self.key.y or 0
    self.key.r=self.key.r or 0
    self.key.op=self.key.op or 0
    if not mark then
        self.mark={x=0,y=0,r=0,sx=0,sy=0,op=0}
    end
    
end
function Anima:animationStart(x,y,r,sx,sy)
    self.x,self.y=x or 0,y or 0
    self.r=r or 0
    self.sx,self.sy=sx or 0,sy or 0
    self.animStart,self.animOver=true,false
    self.animEnd=false
end
function Anima:animationStarted()
    return self.animStart
end
function Anima:animationRunning()
    return not self.animEnd
end
function Anima:animationOver()
    return self.animEnd
end
function Anima:animationStop(arg)
    if arg==nil then arg=true end
    self.animEnd=arg
end
function Anima:resetKey()
    self.key={x=0,y=0,r=0,sx=0,sy=0}
end
function Anima:resetKeyM()
    self.key.x=0
    self.key.y=0
end
function Anima:resetKeyS()
    self.key.sx=0
    self.key.sy=0
end
--Many times you want to mark a position for various reasons - maybe you want to continue
--from where you stopped and you can do this on your own but I'd discourage you 'cause you 
--are only wasting your time since it has already been done for you in animationMark
function Anima:animationMark(x,y,r,sx,sy,op)
    if x==nil then
        self.mark={x=self.mark.x+self.x,y=self.mark.y+self.y,r=self.mark.r+self.r,sx=self.mark.sx+self.sx,sy=self.mark.sy+self.sy,op=self.mark.op+self.op}
    else
        self.mark.x=self.mark.x+x
        self.mark.y=self.mark.y+(y or 0)
        self.mark.r=self.mark.r+(r or 0)
        self.mark.sx=self.mark.sx+(sx or 0)
        self.mark.sy=self.mark.sy+(sy or 0)
        self.mark.op=self.mark.op+(op or 0)
    end
end
function Anima:animationMarkKey()
    self.mark=self.key
end

function Anima:update(stepx,stepy,stepr,stepsx,stepsy,stepop,forever)
    --(self.x<self.key.x and 1 or -1)
    --(self.y>self.key.y and 1 or -1)
    stepx=stepx or 1
    stepy=stepy or 1
    stepr=stepr or math.pi/20
    stepsx=stepsx or 0.01
    stepsy=stepsy or 0.01
    stepop=stepop or 0.01
    if self.animStart and not self.animOver then
        if self.key.x~=0 then self.x=self.x+(self.x<self.key.x and stepx or -stepx) end
        if self.key.y~=0 then self.y=self.y+(self.y<self.key.y and stepy or -stepy) end
        if self.key.sx~=0 then self.sx=self.sx+(self.sx<self.key.sx and stepsx or -stepsx) end
        if self.key.sy~=0 then self.sy=self.sy+(self.sy<self.key.sy and stepsy or -stepsy) end
        if self.key.r~=0 then self.r=self.r+(self.r<self.key.r and stepr or -stepr) end
        if self.key.op~=0 then self.op=self.op+(self.op<self.key.op and stepop or -stepop) end
        if (self.key.x>0 and self.x>self.key.x) or (self.key.x<=0 and self.x<self.key.x) then
            self.x=self.key.x
        end
        if (self.key.sx>0 and self.sx>self.key.sx) or (self.key.sx<=0 and self.sx<self.key.sx) then
            self.sx=self.key.sx
        end
        if (self.key.y>0 and self.y>self.key.y) or (self.key.y<=0 and self.y<self.key.y) then
            self.y=self.key.y
        end
        if (self.key.sy>0 and self.sy>self.key.sy) or (self.key.sy<=0 and self.sy<self.key.sy) then
            self.sy=self.key.sy
        end
        if (self.key.r>0 and self.r>self.key.r) or (self.key.r<=0 and self.r<self.key.r) then
            self.r=self.key.r
        end
        if (self.key.op>0 and self.op>self.key.op) or (self.key.op<=0 and self.op<self.key.op) then
            self.op=self.key.op
        end
        if self.x==self.key.x and self.y==self.key.y and self.r==self.key.r and self.sx==self.key.sx and self.sy==self.key.sy and self.op==self.key.op then
            --print("hell yeah")
            if forever then
                self.key.x=-self.key.x
                self.key.y=-self.key.y
                self.key.r=-self.key.r
                self.key.sx=-self.key.sx
                self.key.sy=-self.key.sy
                self.key.op=-self.key.op
            else
                self.animOver=true
                self.animEnd=true
            end
        end
    end
end
function Anima:updateF(x,y,r,sx,sy,op)
    self:update(x or 1,y or 1,r or math.pi/20,sx or 0.01,sy or 0.01,op or 0.01,true)
end
function Anima:updateM(stepx,stepy)
    self:update(stepx,stepy)
end

function Anima:updateR(stepr)
    self:update(1,1,stepr)
end

function Anima:updateS(stepsx,stepsy)
    self:update(1,1,math.pi/20,stepsx,stepsy)
end

function Anima:updateO(stepo)
    self:update(1,1,math.pi/20,0.01,0.01,stepo)
end
--render the animation
function Anima:render(img,x,y,r,sx,sy,addKey)
    --you may want - sometimes - to have the render before the animation part look just like
    --how it would look after animation for that addKey must be true
    --P.S. FOR MORE CONTROL I RECOMMEND YOU USE animationOver() AND RENDER IN TWO DIFFERENT WAYS
    --assert(img,"The 'render' function requires atleast a drawable object as an argument")
    x=(x or 0) + (addKey and self.key.x or 0)
    y=(y or 0) + (addKey and self.key.y or 0)
    r=(r or 0) + (addKey and self.key.r or 0)
    sx=(sx or 1) + (addKey and self.key.sx or 0)
    sy=(sy or 1) + (addKey and self.key.sy or 0 )
    
    local cr,cg,cb,ca=love.graphics.getColor()
    love.graphics.setColor(0,1,0)

    if love.keyboard.isDown('space') then
        print(self.mark.x,self.mark.y)
    end
    
    
    love.graphics.setColor(1,1,1)
    
    love.graphics.draw(img,x+self.mark.x+self.x,y+self.mark.y+self.y,r+self.mark.r+self.r,sx+self.mark.sx+self.sx,sy+self.mark.sy+self.sy)
    love.graphics.setColor(cr,cg,cb,ca)
end

function Anima:renderQuad(img,quad,x,y,r,sx,sy,addKey)
    --you may want - sometimes - to have the render before the animation part look just like
    --how it would look after animation for that addKey must be true
    --P.S. FOR MORE CONTROL I RECOMMEND YOU USE animationOver() AND RENDER IN TWO DIFFERENT WAYS
    --assert(img,"The 'render' function requires atleast a drawable object as an argument")
    x=(x or 0) + (addKey and self.key.x or 0)
    y=(y or 0) + (addKey and self.key.y or 0)
    r=(r or 0) + (addKey and self.key.r or 0)
    sx=(sx or 1) + (addKey and self.key.sx or 0)
    sy=(sy or 1) + (addKey and self.key.sy or 0 )
    
    local cr,cg,cb,ca=love.graphics.getColor()
    love.graphics.setColor(cr,cg,cb,ca+self.op+(addKey and self.key.op or 0))

    if love.keyboard.isDown('space') then
        print(self.mark.x,self.mark.y)
    end
    
    love.graphics.draw(img,quad,x+self.mark.x+self.x,y+self.mark.y+self.y,r+self.mark.r+self.r,sx+self.mark.sx+self.sx,sy+self.mark.sy+self.sy)
    love.graphics.setColor(cr,cg,cb,ca)
end
return Anima
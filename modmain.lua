-- local old_onhaunt = inst.components.hauntable.onhaunt
local function onHaunt(inst, haunter)
    -- 起火时不能复活
    if(inst:HasTag("fire")) then
        haunter.components.talker:Say("烫烫烫~")
        return false
    end

    rand = math.random(0, 10)
    GLOBAL.TheNet:Announce(haunter.name.."作祟骨堆，摇出"..rand.."点")

    if(rand == 0) then
        -- 起火
        GLOBAL.MakeMediumBurnable(inst) -- 中等火焰
        GLOBAL.MakeSmallPropagator(inst) -- 小范围

        -- 闪电
        GLOBAL.TheWorld:PushEvent("ms_sendlightningstrike", GLOBAL.Vector3(inst.Transform:GetWorldPosition()))
    else
        haunter:PushEvent("respawnfromghost")
        inst:Remove()
    end

    return true
end

AddPrefabPostInit('skeleton_player', function(inst)
    if(not inst.components.hauntable) then
        inst:AddComponent('hauntable')
    end
    if(not inst.components.burnable) then
        inst:AddComponent("burnable")
    end

    inst.components.hauntable:SetOnHauntFn(onHaunt)
end)

function respawnfromghost(inst)
    local penalty = rand/10
    -- inst.components.hunger:SetPercent(penalty)
    -- inst.components.sanity:SetPercent(penalty)
    inst.components.health:SetPercent(penalty)
    inst.components.health:ForceUpdateHUD(false)
end

AddPlayerPostInit(function(inst) 
    inst:ListenForEvent('respawnfromghost', respawnfromghost)  
end)
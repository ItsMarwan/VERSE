using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Game }

<#
 - MADE BY:
    ██╗████████╗░██████╗███╗░░░███╗░█████╗░██████╗░░██╗░░░░░░░██╗░█████╗░███╗░░██╗
    ██║╚══██╔══╝██╔════╝████╗░████║██╔══██╗██╔══██╗░██║░░██╗░░██║██╔══██╗████╗░██║
    ██║░░░██║░░░╚█████╗░██╔████╔██║███████║██████╔╝░╚██╗████╗██╔╝███████║██╔██╗██║
    ██║░░░██║░░░░╚═══██╗██║╚██╔╝██║██╔══██║██╔══██╗░░████╔═████║░██╔══██║██║╚████║
    ██║░░░██║░░░██████╔╝██║░╚═╝░██║██║░░██║██║░░██║░░╚██╔╝░╚██╔╝░██║░░██║██║░╚███║
    ╚═╝░░░╚═╝░░░╚═════╝░╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚═╝░░╚══╝

#>

SkeletonWallhack := class(creative_device):
    @editable
    Switch : switch_device = switch_device{}
    @editable
    VFX_Apply : []visual_effect_powerup_device = array{}
    @editable
    VFX_Clear : []visual_effect_powerup_device = array{}
    @editable
    VFX_ClearALL : []visual_effect_powerup_device = array{}

    OnBegin<override>()<suspends>:void=
        Switch.TurnedOnEvent.Subscribe(OnSwitchTurnedOn)
        Switch.TurnedOffEvent.Subscribe(OnSwitchTurnedOff)

    OnSwitchTurnedOn(Agent:agent):void=
        for (VFX : VFX_Apply):
            VFX.Pickup(Agent)
        for (ClearVFX : VFX_Clear):
            ClearVFX.Pickup(Agent)

    OnSwitchTurnedOff(Agent:agent):void=
        for (VFX : VFX_ClearALL):
            VFX.Pickup(Agent)

    OnActivateAgain(AgentOpt:?agent):void=
        if (Agent := AgentOpt?):
            for (VFX : VFX_Apply):
                VFX.Pickup(Agent)

    OnNextTrigger(AgentOpt:?agent):void=
        if (Agent := AgentOpt?):
            for (ClearVFX : VFX_Clear):
                ClearVFX.Pickup(Agent)

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

Custom_Pickaxe := class<concrete>():
    @editable Conditional : conditional_button_device = conditional_button_device{}
    @editable VFX : visual_effect_powerup_device = visual_effect_powerup_device{}

    Equip(Agent:agent) : void=
        VFX.Pickup(Agent)


Custom_Pick_Player := class():
    Player : player
    var CustomWepDevice : CustomPickaxe_Manager = CustomPickaxe_Manager{}
    var AllWeapons : []Custom_Pickaxe = array{}
    var ClearTrigger : trigger_device = trigger_device{}
    var BaseCrosshair : hud_message_device = hud_message_device{}

    Initiate() : void=
        spawn:
            CheckWeapons()

    CheckWeapons()<suspends> : void=
        race:
            block:
                loop:
                    Sleep(0.0)
                    LeavingPlayer := CustomWepDevice.GetPlayspace().PlayerRemovedEvent().Await()
                    if(LeavingPlayer = Player):
                        break


            loop:
                Sleep(0.0)
                var IsWeaponFound : logic = false
                for(Wep : AllWeapons , IsWeaponFound = false):
                    if(Wep.Conditional.IsHoldingItem[Player]):
                        set IsWeaponFound = true
                    else{
                        Wep.Equip(Player)
                        set IsWeaponFound = false
                    }

                if(IsWeaponFound = true):
                    ClearTrigger.Trigger(Player)
                    

CustomPickaxe_Manager := class(creative_device):
    var PlayersMap : [player]Custom_Pick_Player = map{}
    @editable AllWeapons : []Custom_Pickaxe = array{}
    @editable ClearTrigger : trigger_device = trigger_device{}


    OnBegin<override>()<suspends>:void=
        for(Player : GetPlayspace().GetPlayers()):
            Initialize(Player)

        GetPlayspace().PlayerAddedEvent().Subscribe(Initialize)


    Initialize(Player : player) : void=
        if(PlayerExists := PlayersMap[Player]):

        else:
            if:
                set PlayersMap[Player] = Custom_Pick_Player{
                Player := Player
                CustomWepDevice := Self
                AllWeapons := AllWeapons
                ClearTrigger := ClearTrigger
                }
                CP := PlayersMap[Player]

            then:
                CP.Initiate()
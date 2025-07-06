using { /Fortnite.com/Devices }
using { /Fortnite.com/Vehicles }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

Car_Device := class(creative_device):
    var CurrentVehicle : ?fort_vehicle = false
    var LastLocationVehicle : vector3 = vector3{}

    @editable
    CarButton : button_device = button_device{}

    @editable
    CarSpawner : vehicle_spawner_sports_car_device = vehicle_spawner_sports_car_device{}

    @editable
    CarVFX : visual_effect_powerup_device = visual_effect_powerup_device{}

    @editable
    CarEMPTY_VFX : visual_effect_powerup_device = visual_effect_powerup_device{}

    OnBegin<override>()<suspends>:void=
        CarButton.InteractedWithEvent.Subscribe(OnCarButtonInteracted)
        CarSpawner.AgentExitsVehicleEvent.Subscribe(OnCarExited)
        CarSpawner.SpawnedEvent.Subscribe(OnCarSpawned)

        CarSpawner.Disable()

    AsyncCarHandle(Agent : agent, bCarSpawned : logic, InitialDelay : float)<suspends>:void=
        Sleep(InitialDelay)

        if(bCarSpawned = true):
            CarSpawner.AssignDriver(Agent)
        else:
            CarButton.Enable()
            if (CarButton.TeleportTo[LastLocationVehicle, IdentityRotation()]){}
            CarEMPTY_VFX.Pickup(Agent)

    OnCarButtonInteracted(Agent : agent):void=
        CarButton.Disable()
        CarVFX.Pickup(Agent)
        var ButtonLocation : vector3 = CarButton.GetTransform().Translation
        set ButtonLocation.Z -= 1000.0
        if (CarSpawner.TeleportTo[ButtonLocation, IdentityRotation()]){}

        CarSpawner.Enable()
        if (FortCharacter := Agent.GetFortCharacter[]):
            var TeleportLocation : vector3 = FortCharacter.GetTransform().Translation
            set TeleportLocation.Z += 50.0
            if(CarSpawner.TeleportTo[TeleportLocation,IdentityRotation()]){}

        spawn{ AsyncCarHandle(Agent, true, 0.1) }
    
    OnCarExited(Agent : agent):void=
        if(CurrentVehicle2 := CurrentVehicle?):
            set LastLocationVehicle = CurrentVehicle2.GetTransform().Translation
        set CurrentVehicle = false
        CarSpawner.Disable()
        spawn{ AsyncCarHandle(Agent, false, 0.25) }

    OnCarSpawned(FortVehicle : fort_vehicle):void=
        set CurrentVehicle = option{ FortVehicle }
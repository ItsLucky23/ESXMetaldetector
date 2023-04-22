Config = {}

Config.SoundActive = true -- if true then there will be a sound indicating how close you are
Config.ZoneActive = true -- if true then there will be a circle indicating how close you are
Config.Language = 'en'
Config.Blips = true -- if true then there will be a blip at the location
Config.BlipArea = false -- if true then there will be a larger area around the main blip 
Config.BlipText = 'Prospecting' -- if you have blips active then this will be there name

Config['ProspectingArea'] = {
    {
        coords = vec3(919.2473, 3376.0227, 68.0150), -- the coords of the prospecting area
        size = 200.0, -- the size of the prospecting area
        locations = 100, -- the amount of locations there will be
        difficultyModifier = 1.0 -- 1.0 is normal, the higher you go the harder you can find it. The lower you go the easer it gets(dont put it to high cause it can glitch)
    },
    {
        coords = vec3(627.4949, 3395.0938, 87.2090),
        size = 50.0,
        locations = 100,
        difficultyModifier = 0.5
    },
}

Config['models'] = {

    ['w_am_digiscanner'] = {

        bone = 18905,
        offset = vector3(0.15, 0.1, 0.0),
        rotation = vector3(270.0, 90.0, 80.0),

    },

    ['w_am_metaldetector'] = {

        bone = 18905,
        offset = vector3(0.15, 0.1, 0.0),
        rotation = vector3(270.0, 90.0, 80.0),

    },

}

Config['translation'] = {
    ['nl'] = {
        ['press_e'] = 'Druk op ~INPUT_CONTEXT~ om te graven',
        ['helpText'] = 'Druk op ~b~[F]~w~ om het geluid uit te zetten, druk op ~b~[x]~w~ om te stoppen',
        ['helpText2'] = 'Druk op ~b~[F]~w~ om het geluid aan te zetten, druk op ~b~[x]~w~ om te stoppen',
        ['cant_carry'] = 'Je kan niet meer voorwerpen dragen',
        ['cant_prospect'] = 'Je kan hier niet je metaaldetector pakken omdat je niet in de buurt op de goede locatie bent',
    },
    ['en'] = {
        ['press_e'] = 'Press ~INPUT_CONTEXT~ to dig',
        ['helpText'] = 'Press ~b~[F]~w~ to turn off the sound, press ~b~[x]~w~ to quit prospecting',
        ['helpText2'] = 'Press ~b~[F]~w~ to turn on the sound, press ~b~[x]~w~ to quit prospecting',
        ['cant_carry'] = 'You cant carry anymore items',
        ['cant_prospect'] = 'You cant take out your metal detector because you are not in the right area',
    },
}

Config['rewards'] = { -- MAKE SURE THE CHANCE ADD UP TO 100. Not more, not less
    {item = 'bread',        amount = math.random(1,2),  chance = 30},
    {item = 'water',        amount = math.random(3,5),  chance = 20},
    {item = 'weed',         amount = 1,                 chance = 10},
    {item = 'weed_seed',    amount = 3,                 chance = 40},
}

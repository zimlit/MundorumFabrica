include("PhysicalCharacteristics.jl")
include("OrbitalCharacteristics.jl")
include("AtmosphericCharacteristics.jl")

struct Orbit
    semimajoraxis::Float64
    eccentricity::Float64
    inclination::Float64
    apoapsis::Float64
    periapsis::Float64
    period::Float64
end

@enum Gas N2 O2 Ar CO2 CH4 N2O O3 Ne He H2 H2O CO NH3 SO2 H2S SO3 Kr

struct Planet
    mass::Float64
    radius::Float64
    surface_area::Float64
    volume::Float64
    density::Float64
    gravity::Float64
    axialtilt::Float64
    rotationperiod::Float64
    albedo::Float64
    orbit::Orbit
    atmpressure::Float64
    atm::Dict{Gas, Float64}
    
    function Planet(
            mass::Float64, radius::Float64, axialtilt::Float64, rotationperiod::Float64, albedo::Float64,
            semimajoraxis::Float64, eccentricity::Float64, inclination::Float64, star::Star,
            atmpressure::Float64, atm::Dict{Gas, Float64}
        )
        surface_area = 4 * π * (radius*6371)^2
        volume = (4/3) * π * (radius*6371)^3
        density = ((mass*5.972e+24)/volume)/1e+12
        gravity = mass/radius^2

        apoapsis = semimajoraxis * (1 + eccentricity)
        periapsis = semimajoraxis * (1 - eccentricity)
        period = sqrt(semimajoraxis^3/star.mass)*365.242

        orbit = Orbit(semimajoraxis, eccentricity, inclination, apoapsis, periapsis, period)

        return new(mass, radius, surface_area, volume, density, gravity, axialtilt, rotationperiod, albedo, orbit, atmpressure, atm)
    end
end

function Base.show(io::Core.IO, p::Planet)
    println(io, "Planet with mass $(p.mass) M☉")
    println(io, "Radius: $(p.radius) R☉")
    println(io, "Surface area: $(p.surface_area) km²")
    println(io, "Volume: $(p.volume) km³")
    println(io, "Density: $(p.density) ρ☉")
    println(io, "Gravity: $(p.gravity) G")
    println(io, "Axial tilt: $(p.axialtilt)°")
    println(io, "Rotation period: $(p.rotationperiod) hours")
    print(io, "Albedo: $(p.albedo)")
end

mutable struct PlanetUi
    box::GtkBox
    physicalcharacteristicsui::PlanetPhysicalCharacteristics
    orbitalcharacteristicsui::PlanetOrbitalCharacteristics
    atmosphericcharacteristicsui::PlanetAtmosphericCharacteristics
    planet::Planet

    function PlanetUi(star)
        planet = Planet(
            1.0, 1.0, 23.5, 24.0, 0.29, 
            1.0, 0.0167, 0.0, star, 
            1.0, Dict(
                N2 => 78.084, 
                O2 => 20.946, 
                Ar => 0.934, 
                CO2 => 0.417, 
                Ne => 0.001818,
                He => 0.000524,
                CH4 => 0.000187,
                Kr => 0.000114
            )
        )

        plvbox = GtkBox(:v)

        plstack = GtkStack()
        plstack.transition_type = Gtk4.StackTransitionType_SLIDE_LEFT_RIGHT
        plstackswitcher = GtkStackSwitcher()
        plstackswitcher.margin_top = 10
        plstackswitcher.margin_start = 10
        plstackswitcher.margin_end = 10
        plstackswitcher.stack = plstack

        physicalcharacteristicsui = PlanetPhysicalCharacteristics(planet)
        orbitalcharacteristicsui = PlanetOrbitalCharacteristics(planet)
        atmosphericcharacteristicsui = PlanetAtmosphericCharacteristics()
        
        push!(plstack, physicalcharacteristicsui.box, "Physical Characteristics", "Physical Characteristics")
        push!(plstack, orbitalcharacteristicsui.box, "Orbital Characteristics", "Orbital Characteristics")
        push!(plstack, atmosphericcharacteristicsui.box, "Atmospheric Characteristics", "Atmospheric Characteristics")
        push!(plvbox, plstackswitcher)
        push!(plvbox, plstack)

        return new(plvbox, physicalcharacteristicsui, orbitalcharacteristicsui, atmosphericcharacteristicsui, planet)
    end
end
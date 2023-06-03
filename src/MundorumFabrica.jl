# Copyright (C) 2023 Devin Rockwell
# 
# This file is part of MundorumFabrica.
# 
# MundorumFabrica is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# MundorumFabrica is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with MundorumFabrica.  If not, see <http://www.gnu.org/licenses/>.

module MundorumFabrica
    __precompile__()

    using Gtk4
    using Printf

    include("Star.jl")
    include("Planet/PhysicalCharacteristics.jl")
    include("Planet/OrbitalCharacteristics.jl")

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

    function activate(app)
        starui = StarUi()

        planet = Planet(
            1.0, 1.0, 23.5, 24.0, 0.29, 
            1.0, 0.0167, 0.0, starui.star, 
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

        win = GtkApplicationWindow(app, "Mundorum Fabrica")
        
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
        
        atmosphericcharacteristicsbox = GtkBox(:v)
        atmosphericcharacteristicsbox.spacing = 15
        atmosphericcharacteristicsbox.margin_top = 20
	    atmosphericcharacteristicsbox.halign = Gtk4.Align_CENTER

        pressure = GtkBox(:h)       
        pressure.spacing = 15
        adjustment = GtkAdjustment(1, 0, 1.7976931348623157e+308, 0.1, 10, 0)
        sb_atm = GtkSpinButton(adjustment, 1, 4)

        atmp_l = GtkLabel("Pressure (atm)")

        push!(pressure, atmp_l)
        push!(pressure, sb_atm)

        gas_t = GtkGrid()
        gas_t.column_spacing = 15

        gas_l = GtkLabel("Gas")
        percent_l = GtkLabel("%")

        gas_t[1, 1] = gas_l
        gas_t[2, 1] = percent_l

        push!(atmosphericcharacteristicsbox, pressure)
        push!(atmosphericcharacteristicsbox, gas_t)

        push!(plstack, physicalcharacteristicsui.box, "Physical Characteristics", "Physical Characteristics")
        push!(plstack, orbitalcharacteristicsui.box, "Orbital Characteristics", "Orbital Characteristics")
        push!(plstack, atmosphericcharacteristicsbox, "Atmospheric Characteristics", "Atmospheric Characteristics")
        push!(plvbox, plstackswitcher)
        push!(plvbox, plstack)

        stack = GtkStack()
        stack.transition_type = Gtk4.StackTransitionType_SLIDE_LEFT_RIGHT
        push!(stack, starui.box, "Star", "Star")
        push!(stack, plvbox, "Planet", "Planet")
        stackswitcher = GtkStackSwitcher()
        stackswitcher.margin_top = 10
        stackswitcher.margin_start = 10
        stackswitcher.margin_end = 10
        stackswitcher.stack = stack

        vbox = GtkBox(:v)
        push!(vbox, stackswitcher)
        push!(vbox, stack)

        push!(win, vbox)

        function compute(w)
            starui.star = Star(starui.sb.value)
            planet = Planet(
                physicalcharacteristicsui.sb_mass.value, physicalcharacteristicsui.sb_radius.value, physicalcharacteristicsui.sb_albedo.value, physicalcharacteristicsui.sb_rotationperiod.value, physicalcharacteristicsui.sb_albedo.value, 
                orbitalcharacteristicsui.sb_semi.value, orbitalcharacteristicsui.sb_ecc.value, orbitalcharacteristicsui.sb_inc.value, starui.star,
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

            starui.li.label = Printf.@sprintf("%.3f", starui.star.lifespan)
            starui.r.label = Printf.@sprintf("%.3f", starui.star.radius)
            starui.sa.label = Printf.@sprintf("%.3e", starui.star.surface_area)
            starui.v.label = Printf.@sprintf("%.3e", starui.star.volume)
            starui.l.label = Printf.@sprintf("%.3f", starui.star.luminosity)
            starui.ρ.label = Printf.@sprintf("%.3f", starui.star.density)
            starui.t.label = Printf.@sprintf("%.3f", starui.star.temperature)
            starui.hz.label = Printf.@sprintf("%.3f", starui.star.HabitableZone[1]) * " to " * Printf.@sprintf("%.3f", starui.star.HabitableZone[2])

            physicalcharacteristicsui.sa.label = Printf.@sprintf("%.3e", planet.surface_area)
            physicalcharacteristicsui.v.label = Printf.@sprintf("%.3e", planet.volume)
            physicalcharacteristicsui.ρ.label = Printf.@sprintf("%.3f", planet.density)
            physicalcharacteristicsui.g.label = Printf.@sprintf("%.3f", planet.gravity)
            orbitalcharacteristicsui.ap.label = Printf.@sprintf("%.3f", planet.orbit.apoapsis)
            orbitalcharacteristicsui.pe.label = Printf.@sprintf("%.3f", planet.orbit.periapsis)
            orbitalcharacteristicsui.per.label = Printf.@sprintf("%.3f", planet.orbit.period)
        end

        signal_connect(compute, starui.sb, "value-changed")
        signal_connect(compute, physicalcharacteristicsui.sb_mass, "value-changed")
        signal_connect(compute, physicalcharacteristicsui.sb_radius, "value-changed")
        signal_connect(compute, physicalcharacteristicsui.sb_axialtilt, "value-changed")
        signal_connect(compute, physicalcharacteristicsui.sb_rotationperiod, "value-changed")
        signal_connect(compute, physicalcharacteristicsui.sb_albedo, "value-changed")
        signal_connect(compute, orbitalcharacteristicsui.sb_semi, "value-changed")
        signal_connect(compute, orbitalcharacteristicsui.sb_ecc, "value-changed")
        signal_connect(compute, orbitalcharacteristicsui.sb_inc, "value-changed")

        show(win)
    end

    app = GtkApplication()

    Gtk4.signal_connect(activate, app, :activate)
    
    run(app)
end

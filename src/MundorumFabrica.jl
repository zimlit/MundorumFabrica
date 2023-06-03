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
    include("Planet/Planet.jl")

    function activate(app)
        starui = StarUi()

        planetui = PlanetUi(starui.star)

        win = GtkApplicationWindow(app, "Mundorum Fabrica")
        
        stack = GtkStack()
        stack.transition_type = Gtk4.StackTransitionType_SLIDE_LEFT_RIGHT
        push!(stack, starui.box, "Star", "Star")
        push!(stack, planetui.box, "Planet", "Planet")
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
            planetui.planet = Planet(
                planetui.physicalcharacteristicsui.sb_mass.value, planetui.physicalcharacteristicsui.sb_radius.value, planetui.physicalcharacteristicsui.sb_albedo.value, planetui.physicalcharacteristicsui.sb_rotationperiod.value, planetui.physicalcharacteristicsui.sb_albedo.value, 
                planetui.orbitalcharacteristicsui.sb_semi.value, planetui.orbitalcharacteristicsui.sb_ecc.value, planetui.orbitalcharacteristicsui.sb_inc.value, starui.star,
                planetui.atmosphericcharacteristicsui.sb_atm.value, Dict(
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

            planetui.physicalcharacteristicsui.sa.label = Printf.@sprintf("%.3e", planetui.planet.surface_area)
            planetui.physicalcharacteristicsui.v.label = Printf.@sprintf("%.3e", planetui.planet.volume)
            planetui.physicalcharacteristicsui.ρ.label = Printf.@sprintf("%.3f", planetui.planet.density)
            planetui.physicalcharacteristicsui.g.label = Printf.@sprintf("%.3f", planetui.planet.gravity)
            planetui.orbitalcharacteristicsui.ap.label = Printf.@sprintf("%.3f", planetui.planet.orbit.apoapsis)
            planetui.orbitalcharacteristicsui.pe.label = Printf.@sprintf("%.3f", planetui.planet.orbit.periapsis)
            planetui.orbitalcharacteristicsui.per.label = Printf.@sprintf("%.3f", planetui.planet.orbit.period)
        end

        signal_connect(compute, starui.sb, "value-changed")
        signal_connect(compute, planetui.physicalcharacteristicsui.sb_mass, "value-changed")
        signal_connect(compute, planetui.physicalcharacteristicsui.sb_radius, "value-changed")
        signal_connect(compute, planetui.physicalcharacteristicsui.sb_axialtilt, "value-changed")
        signal_connect(compute, planetui.physicalcharacteristicsui.sb_rotationperiod, "value-changed")
        signal_connect(compute, planetui.physicalcharacteristicsui.sb_albedo, "value-changed")
        signal_connect(compute, planetui.orbitalcharacteristicsui.sb_semi, "value-changed")
        signal_connect(compute, planetui.orbitalcharacteristicsui.sb_ecc, "value-changed")
        signal_connect(compute, planetui.orbitalcharacteristicsui.sb_inc, "value-changed")

        show(win)
    end

    app = GtkApplication()

    Gtk4.signal_connect(activate, app, :activate)
    
    run(app)
end

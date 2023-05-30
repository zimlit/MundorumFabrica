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

    struct Star
        mass::Float64
        lifespan::Float64
        radius::Float64
        surface_area::Float64
        volume::Float64
        luminosity::Float64
        density::Float64
        temperature::Float64
        HabitableZone::Tuple{Float64, Float64}

        function Star(mass::Float64)
            if mass < 0.43 
                l = 0.23 * mass^2.3
            elseif mass < 2
                l = mass^4
            elseif mass < 55
                l = 1.4 * mass^3.5
            else
                l = 32000 * mass
            end 

            li = (mass/l) * 10
            if mass < 1
                r = mass^0.8
            else
                r = mass^0.57
            end
            sa = 4 * π * (r*696340)^2
            v = (4/3) * π * (r*696340)^3
            ρ = mass/r^3
            t = 5778 * (mass/r^2)^0.25
            hz = (sqrt(l/1.1), sqrt(l/0.53))

            return new(mass, li, r, sa, v, l, ρ, t, hz)
        end
    end

    function Base.show(io::Core.IO, s::Star)
        println(io, "Star with mass $(s.mass) M☉")
        println(io, "Lifespan: $(s.lifespan) billion years")
        println(io, "Radius: $(s.radius) R☉")
        println(io, "Surface area: $(s.surface_area) km²")
        println(io, "Volume: $(s.volume) km³")
        println(io, "Luminosity: $(s.luminosity) L☉")
        println(io, "Density: $(s.density) ρ☉")
        println(io, "Temperature: $(s.temperature) K")
        print(io, "Habitable zone: $(s.HabitableZone[1]) AU to $(s.HabitableZone[2]) AU")
    end

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
        
        function Planet(mass::Float64, radius::Float64, axialtilt::Float64, rotationperiod::Float64, albedo::Float64)
            surface_area = 4 * π * (radius*6371)^2
            volume = (4/3) * π * (radius*6371)^3
            density = ((mass*5.972e+24)/volume)/1e+12
            gravity = mass/radius^2

            return new(mass, radius, surface_area, volume, density, gravity, axialtilt, rotationperiod, albedo)
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

    star = Star(1.0)
    planet = Planet(1.0, 1.0, 23.5, 24.0, 0.29)

    function makestarui()
        starbox = GtkGrid()
        starbox.column_spacing = 15
        starbox.margin_top = 20
        starbox.halign = Gtk4.Align_CENTER

        adjustment = GtkAdjustment(1, 0, 300, 0.1, 10, 0)
        sb = GtkSpinButton(adjustment, 1, 4)

        mass = GtkLabel("Mass (M☉)")
        Gtk4.markup(mass, "Mass (M<sub>☉</sub>)")
        li_l = GtkLabel("Lifespan (Gyr)")
        r_l = GtkLabel("Radius (R☉)")
        Gtk4.markup(r_l, "Radius (R<sub>☉</sub>)")
        sa_l = GtkLabel("Surface area (km²)")
        v_l = GtkLabel("Volume (km³)")
        l_l = GtkLabel("Luminosity (L☉)")
        Gtk4.markup(l_l, "Luminosity (L<sub>☉</sub>)")
        ρ_l = GtkLabel("Density (ρ☉)")
        Gtk4.markup(ρ_l, "Density (ρ<sub>☉</sub>)")
        t_l = GtkLabel("Temperature (K)")
        hz_l = GtkLabel("Habitable zone (AU)")
        mass.xalign = 0
        li_l.xalign = 0
        r_l.xalign = 0
        sa_l.xalign = 0
        v_l.xalign = 0
        l_l.xalign = 0
        ρ_l.xalign = 0
        t_l.xalign = 0
        hz_l.xalign = 0

        li = GtkLabel(Printf.@sprintf("%.3f", star.lifespan))
        r = GtkLabel(Printf.@sprintf("%.3f", star.radius))
        sa = GtkLabel(Printf.@sprintf("%.3e", star.surface_area))
        v = GtkLabel(Printf.@sprintf("%.3e", star.volume))
        l = GtkLabel(Printf.@sprintf("%.3f", star.luminosity))
        ρ = GtkLabel(Printf.@sprintf("%.3f", star.density))
        t = GtkLabel(Printf.@sprintf("%.3f", star.temperature))
        hz = GtkLabel(Printf.@sprintf("%.3f", star.HabitableZone[1]) * " to " * Printf.@sprintf("%.3f", star.HabitableZone[2]))

        starbox[1, 1] = mass
        starbox[2, 1] = sb

        starbox[1, 2] = li_l
        starbox[2, 2] = li

        starbox[1, 3] = r_l
        starbox[2, 3] = r

        starbox[1, 4] = sa_l
        starbox[2, 4] = sa

        starbox[1, 5] = v_l
        starbox[2, 5] = v

        starbox[1, 6] = l_l
        starbox[2, 6] = l

        starbox[1, 7] = ρ_l
        starbox[2, 7] = ρ

        starbox[1, 8] = t_l
        starbox[2, 8] = t

        starbox[1, 9] = hz_l
        starbox[2, 9] = hz
        
        signal_connect(sb, "value-changed") do b
            star = Star(sb.value)
            li.label = Printf.@sprintf("%.3f", star.lifespan)
            r.label = Printf.@sprintf("%.3f", star.radius)
            sa.label = Printf.@sprintf("%.3e", star.surface_area)
            v.label = Printf.@sprintf("%.3e", star.volume)
            l.label = Printf.@sprintf("%.3f", star.luminosity)
            ρ.label = Printf.@sprintf("%.3f", star.density)
            t.label = Printf.@sprintf("%.3f", star.temperature)
            hz.label = Printf.@sprintf("%.3f", star.HabitableZone[1]) * " to " * Printf.@sprintf("%.3f", star.HabitableZone[2])
        end

        return starbox
    end

    function makeplanetui()
        vbox = GtkBox(:v)

        stack = GtkStack()
        stack.transition_type = Gtk4.StackTransitionType_SLIDE_LEFT_RIGHT
        stackswitcher = GtkStackSwitcher()
        stackswitcher.stack = stack

        physicalcharacteristicsbox = GtkGrid()
        physicalcharacteristicsbox.column_spacing = 15
        physicalcharacteristicsbox.margin_top = 20
        physicalcharacteristicsbox.halign = Gtk4.Align_CENTER

        adjustment = GtkAdjustment(1, 0, 4767, 0.1, 10, 0)
        sb_mass = GtkSpinButton(adjustment, 1, 4)

        adjustment = GtkAdjustment(1, 0, 25, 0.1, 10, 0)
        sb_radius = GtkSpinButton(adjustment, 1, 4)

        adjustment = GtkAdjustment(23.5, 0, 360, 0.1, 10, 0)
        sb_axialtilt = GtkSpinButton(adjustment, 1, 4)

        adjustment = GtkAdjustment(24, 0, 10000, 0.1, 10, 0)
        sb_rotationperiod = GtkSpinButton(adjustment, 1, 4)

        adjustment = GtkAdjustment(0.29, 0, 1, 0.01, 10, 0)
        sb_albedo = GtkSpinButton(adjustment, 1, 4)

        mass = GtkLabel("m")
        Gtk4.markup(mass, "Mass (M<sub>⊕</sub>)")
        radius = GtkLabel("r")
        Gtk4.markup(radius, "Radius (R<sub>⊕</sub>)")
        sa_l = GtkLabel("Surface area (km²)")
        v_l = GtkLabel("Volume (km³)")
        ρ_l = GtkLabel("Density (ρ)")
        Gtk4.markup(ρ_l, "Density (gm/cm<sup>3</sup>)")
        g_l = GtkLabel("Gravity (g)")
        a_l = GtkLabel("Axial tilt (°)")
        p_l = GtkLabel("Rotation period (earth hours)")
        albedo_l = GtkLabel("Bond albedo")

        sa = GtkLabel(Printf.@sprintf("%.3e", planet.surface_area))
        v = GtkLabel(Printf.@sprintf("%.3e", planet.volume))
        ρ = GtkLabel(Printf.@sprintf("%.3f", planet.density))
        g = GtkLabel(Printf.@sprintf("%.3f", planet.gravity))

        physicalcharacteristicsbox[1, 1] = mass
        physicalcharacteristicsbox[2, 1] = sb_mass

        physicalcharacteristicsbox[1, 2] = radius
        physicalcharacteristicsbox[2, 2] = sb_radius

        physicalcharacteristicsbox[1, 3] = sa_l
        physicalcharacteristicsbox[2, 3] = sa

        physicalcharacteristicsbox[1, 4] = v_l
        physicalcharacteristicsbox[2, 4] = v

        physicalcharacteristicsbox[1, 5] = ρ_l
        physicalcharacteristicsbox[2, 5] = ρ

        physicalcharacteristicsbox[1, 6] = g_l
        physicalcharacteristicsbox[2, 6] = g

        physicalcharacteristicsbox[1, 7] = a_l
        physicalcharacteristicsbox[2, 7] = sb_axialtilt

        physicalcharacteristicsbox[1, 8] = p_l
        physicalcharacteristicsbox[2, 8] = sb_rotationperiod

        physicalcharacteristicsbox[1, 9] = albedo_l
        physicalcharacteristicsbox[2, 9] = sb_albedo

        function compute(w)
            planet = Planet(sb_mass.value, sb_radius.value, sb_axialtilt.value, sb_rotationperiod.value, sb_albedo.value)
            sa.label = Printf.@sprintf("%.3e", planet.surface_area)
            v.label = Printf.@sprintf("%.3e", planet.volume)
            ρ.label = Printf.@sprintf("%.3f", planet.density)
            g.label = Printf.@sprintf("%.3f", planet.gravity)
        end

        signal_connect(compute, sb_mass, "value-changed")
        signal_connect(compute, sb_radius, "value-changed")
        signal_connect(compute, sb_axialtilt, "value-changed")
        signal_connect(compute, sb_rotationperiod, "value-changed")
        signal_connect(compute, sb_albedo, "value-changed")
        
        orbitalcharacteristicsbox = GtkGrid()

        atmosphericcharacteristicsbox = GtkGrid()

        push!(stack, physicalcharacteristicsbox, "Physical Characteristics", "Physical Characteristics")
        push!(stack, orbitalcharacteristicsbox, "Orbital Characteristics", "Orbital Characteristics")
        push!(stack, atmosphericcharacteristicsbox, "Atmospheric Characteristics", "Atmospheric Characteristics")
        push!(vbox, stackswitcher)
        push!(vbox, stack)

        return vbox
    end

    function activate(app)
        win = GtkApplicationWindow(app, "Mundorum Fabrica")

        starbox = makestarui()
        planetbox = makeplanetui()

        stack = GtkStack()
        stack.transition_type = Gtk4.StackTransitionType_SLIDE_LEFT_RIGHT
        push!(stack, starbox, "Star", "Star")
        push!(stack, planetbox, "Planet", "Planet")
        stackswitcher = GtkStackSwitcher()
        stackswitcher.stack = stack

        vbox = GtkBox(:v)
        push!(vbox, stackswitcher)
        push!(vbox, stack)

        push!(win, vbox)

        show(win)
    end

    app = GtkApplication()

    Gtk4.signal_connect(activate, app, :activate)
    
    run(app)
end

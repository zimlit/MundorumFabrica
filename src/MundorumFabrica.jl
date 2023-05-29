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

    star = Star(1.0)

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

    function activate(app)
        win = GtkApplicationWindow(app, "Mundorum Fabrica")

        starbox = GtkGrid()
        starbox.column_spacing = 15
        starbox.margin_top = 20
        starbox.halign = Gtk4.Align_CENTER

        adjustment = GtkAdjustment(1, 0, 300, 0.1, 10, 0)
        sb = GtkSpinButton(adjustment, 1, 4)

        mass = GtkLabel("Mass (M☉)")
        li_l = GtkLabel("Lifespan (Gyr)")
        r_l = GtkLabel("Radius (R☉)")
        sa_l = GtkLabel("Surface area (km²)")
        v_l = GtkLabel("Volume (km³)")
        l_l = GtkLabel("Luminosity (L☉)")
        ρ_l = GtkLabel("Density (ρ☉)")
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

        stack = GtkStack()
        push!(stack, starbox, "Star", "Star")
        stackswitcher = GtkStackSwitcher()
        stackswitcher.stack = stack

        vbox = GtkBox(:v)
        push!(vbox, stackswitcher)
        push!(vbox, stack)

        push!(win, vbox)

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

        show(win)
    end

    app = GtkApplication()

    Gtk4.signal_connect(activate, app, :activate)
    
    run(app)
end

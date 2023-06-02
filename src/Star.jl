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

mutable struct StarUi
    const box::GtkGrid
    const sb::GtkSpinButton
    star::Star
    li::GtkLabel
    r::GtkLabel
    sa::GtkLabel
    v::GtkLabel 
    l::GtkLabel 
    ρ::GtkLabel 
    t::GtkLabel 
    hz::GtkLabel

    function StarUi()
        star = Star(1.0)

        box = GtkGrid()
        box.column_spacing = 15
        box.margin_top = 20
        box.halign = Gtk4.Align_CENTER

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

        box[1, 1] = mass
        box[2, 1] = sb

        box[1, 2] = li_l
        box[2, 2] = li

        box[1, 3] = r_l
        box[2, 3] = r

        box[1, 4] = sa_l
        box[2, 4] = sa

        box[1, 5] = v_l
        box[2, 5] = v

        box[1, 6] = l_l
        box[2, 6] = l

        box[1, 7] = ρ_l
        box[2, 7] = ρ

        box[1, 8] = t_l
        box[2, 8] = t

        box[1, 9] = hz_l
        box[2, 9] = hz

        return new(box, sb, star, li, r, sa, v, l, ρ, t, hz)
    end
end
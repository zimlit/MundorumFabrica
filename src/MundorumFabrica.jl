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

    function julia_main()::Cint
        print("Enter the mass of the star: ")
        mass = parse(Float64, readline())
        star = Star(mass)

        println(star)

        return 0
    end
end

using Gtk4

mutable struct PlanetAtmosphericCharacteristics
    box::GtkBox
    sb_atm::GtkSpinButton

    function PlanetAtmosphericCharacteristics()
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

        return new(atmosphericcharacteristicsbox, sb_atm)
    end
end
mutable struct PlanetOrbitalCharacteristics
    const box::GtkGrid
    const sb_semi::GtkSpinButton
    const sb_ecc::GtkSpinButton
    const sb_inc::GtkSpinButton
    ap::GtkLabel
    pe::GtkLabel
    per::GtkLabel

    function PlanetOrbitalCharacteristics(planet)
        orbitalcharacteristicsbox = GtkGrid()
        orbitalcharacteristicsbox.column_spacing = 15
        orbitalcharacteristicsbox.margin_top = 20
	    orbitalcharacteristicsbox.halign = Gtk4.Align_CENTER

        adjustment = GtkAdjustment(1, 0, 1.7976931348623157e+308, 0.1, 10, 0)
        sb_semi = GtkSpinButton(adjustment, 1, 4)

        adjustment = GtkAdjustment(0.0167, 0, 1, 0.01, 10, 0)
        sb_ecc = GtkSpinButton(adjustment, 1, 4)

        adjustment = GtkAdjustment(0, 0, 360, 0.1, 10, 0)
        sb_inc = GtkSpinButton(adjustment, 1, 4)

        plsemi_l = GtkLabel("Semi-major axis (AU)")
        plecc_l = GtkLabel("Eccentricity")
        plinc_l = GtkLabel("Inclination (°)")
        plap_l = GtkLabel("Apoapsis (AU)")
        plpe_l = GtkLabel("Periapsis (AU)")
        plper_l = GtkLabel("Orbital Period (earth days)")

        plap = GtkLabel(Printf.@sprintf("%.3f", planet.orbit.apoapsis))
        plpe = GtkLabel(Printf.@sprintf("%.3f", planet.orbit.periapsis))
        plper = GtkLabel(Printf.@sprintf("%.3f", planet.orbit.period))

        orbitalcharacteristicsbox[1, 1] = plsemi_l
        orbitalcharacteristicsbox[2, 1] = sb_semi

        orbitalcharacteristicsbox[1, 2] = plecc_l
        orbitalcharacteristicsbox[2, 2] = sb_ecc

        orbitalcharacteristicsbox[1, 3] = plinc_l
        orbitalcharacteristicsbox[2, 3] = sb_inc

        orbitalcharacteristicsbox[1, 4] = plap_l
        orbitalcharacteristicsbox[2, 4] = plap

        orbitalcharacteristicsbox[1, 5] = plpe_l
        orbitalcharacteristicsbox[2, 5] = plpe

        orbitalcharacteristicsbox[1, 6] = plper_l
        orbitalcharacteristicsbox[2, 6] = plper

        return new(orbitalcharacteristicsbox, sb_semi, sb_ecc, sb_inc, plap, plpe, plper)
    end
end
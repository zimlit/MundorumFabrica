using Gtk4
using Printf

mutable struct PlanetPhysicalCharacteristics
    const box::GtkGrid
    const sb_mass::GtkSpinButton
    const sb_radius::GtkSpinButton
    const sb_axialtilt::GtkSpinButton
    const sb_rotationperiod::GtkSpinButton
    const sb_albedo::GtkSpinButton
    sa::GtkLabel
    v::GtkLabel
    ρ::GtkLabel
    g::GtkLabel

    function PlanetPhysicalCharacteristics(planet)
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

        plmass = GtkLabel("m")
        Gtk4.markup(plmass, "Mass (M<sub>⊕</sub>)")
        plradius = GtkLabel("r")
        Gtk4.markup(plradius, "Radius (R<sub>⊕</sub>)")
        plsa_l = GtkLabel("Surface area (km²)")
        plv_l = GtkLabel("Volume (km³)")
        plρ_l = GtkLabel("Density (ρ)")
        Gtk4.markup(plρ_l, "Density (gm/cm<sup>3</sup>)")
        plg_l = GtkLabel("Gravity (g)")
        pla_l = GtkLabel("Axial tilt (°)")
        plp_l = GtkLabel("Rotation period (earth hours)")
        plalbedo_l = GtkLabel("Bond albedo")
        plmass.xalign = 0
        plradius.xalign = 0
        plsa_l.xalign = 0
        plv_l.xalign = 0
        plρ_l.xalign = 0
        plg_l.xalign = 0
        pla_l.xalign = 0
        plp_l.xalign = 0
        plalbedo_l.xalign = 0

        plsa = GtkLabel(Printf.@sprintf("%.3e", planet.surface_area))
        plv = GtkLabel(Printf.@sprintf("%.3e", planet.volume))
        plρ = GtkLabel(Printf.@sprintf("%.3f", planet.density))
        plg = GtkLabel(Printf.@sprintf("%.3f", planet.gravity))

        physicalcharacteristicsbox[1, 1] = plmass
        physicalcharacteristicsbox[2, 1] = sb_mass

        physicalcharacteristicsbox[1, 2] = plradius
        physicalcharacteristicsbox[2, 2] = sb_radius

        physicalcharacteristicsbox[1, 3] = plsa_l
        physicalcharacteristicsbox[2, 3] = plsa

        physicalcharacteristicsbox[1, 4] = plv_l
        physicalcharacteristicsbox[2, 4] = plv

        physicalcharacteristicsbox[1, 5] = plρ_l
        physicalcharacteristicsbox[2, 5] = plρ

        physicalcharacteristicsbox[1, 6] = plg_l
        physicalcharacteristicsbox[2, 6] = plg

        physicalcharacteristicsbox[1, 7] = pla_l
        physicalcharacteristicsbox[2, 7] = sb_axialtilt

        physicalcharacteristicsbox[1, 8] = plp_l
        physicalcharacteristicsbox[2, 8] = sb_rotationperiod

        physicalcharacteristicsbox[1, 9] = plalbedo_l
        physicalcharacteristicsbox[2, 9] = sb_albedo

        return new(physicalcharacteristicsbox, sb_mass, sb_radius, sb_axialtilt, sb_rotationperiod, sb_albedo, plsa, plv, plρ, plg)
    end
end
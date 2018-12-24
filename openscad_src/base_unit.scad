include <parameters.scad>
use <util.scad>
use <spool_gear.scad>
use <lineroller_ABC_winch.scad>
use <lineroller_D.scad>

base_w = 470;
base_d = 450;
base_h = Spool_outer_radius + 10;

anchor_D_radius = 120;

D_spool_x = base_w / 2;
D_spool_y = base_d - Spool_outer_radius + 40;

module mock_spool(center = true) {
    color("plum")
    rotate([90, 0, 0])
        cylinder(h=Gear_height + Spool_height , r=      Spool_outer_radius, $fn=8*8, center=center);
}
module lineroller_ABC() {
    color("steelblue")
    translate([Spool_outer_radius + 30, 0, 0])
        lineroller_ABC_winch();
}

module position_spool(anchor = "A") {
    translate_y = 150;
    translate_z = base_h;
    if (anchor == "A") {
        translate([base_w / 4, translate_y, translate_z])
            rotate([0, 0, 45])
            children();
    } else if (anchor == "B") {
        translate([3 * base_w / 4, translate_y, translate_z])
            rotate([0, 0, -45])
            children();
    } else if (anchor == "C") {
        translate([base_w / 2, translate_y, translate_z])
            rotate([0, 0, -90])
            children();
    }
}

module D_anchor(anchor = 0) {
    translate([D_spool_x, D_spool_y, base_h])
        rotate([0, 0, anchor * 90])
            translate([anchor_D_radius, 0, 0])
                rotate([0, 0, 180])
                    color("mediumseagreen")
                        lineroller_D();
}

base_unit();
module base_unit() {
    union() {
        difference() {
            rounded_cube2([base_w, base_d, base_h], 30);
            position_spool("A") {
                mock_spool();
            }
            position_spool("B") {
                mock_spool();
            }
            position_spool("C") {
                mock_spool();
            }
        }
        position_spool("A") {
            rotate([0, 0, 180])
                lineroller_ABC();
        }
        position_spool("B") {
            lineroller_ABC();
        }
        position_spool("C") {
            lineroller_ABC();
        }
        D_anchor(0);
        D_anchor(2);
        D_anchor(3);
        translate([D_spool_x, D_spool_y, base_h])
            rotate([-90, 0, 0])
                mock_spool(false);
    }
}
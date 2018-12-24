include <parameters.scad>
use <util.scad>

use <lineroller_ABC_winch.scad>
use <lineroller_D.scad>

layer_height = 25.4 / 2; //.5 inch

base_w = 250;
base_d = 370;
base_h = 6 * layer_height;

D_spool_x = base_w / 2;
D_spool_y = base_d / 2;


module mock_spool(center = true) {
    color("plum")
    cylinder(h=Gear_height + Spool_height + 2, r=Spool_outer_radius, $fn=8*8, center=center);
}

module vertical_spool(center = true, radius = 2.5, length=2 * Gear_height + Spool_height) {
    union() {
        rotate([90, 0, 0])
            mock_spool(center);
        translate([0, length / 2, -radius])
            rotate([90, 0, 0])
                union() {
                    cylinder(h=length, r=radius, $fn=4*4);
                    translate([0, radius, length / 2])
                        cube(size=[2*radius, 2*radius, length], center=true);
                }
    }
}

module lineroller_ABC() {
    color("steelblue")
    translate([Spool_outer_radius + 30, 0, 0])
        lineroller_ABC_winch();
}

module position_spool(anchor = "A") {
    translate_z = base_h;
    if (anchor == "A") {
        translate([30, base_d - 30, translate_z])
            rotate([0, 0, -30])
            children();
    } else if (anchor == "B") {
        translate([base_w - 30, base_d - 30, translate_z])
            rotate([0, 0, 30])
            children();
    } else if (anchor == "C") {
        translate([base_w / 2, 15, translate_z])
            rotate([0, 0, -90])
            children();
    }
}

module D_anchor(anchor = 0) {
    dist = 115;
    translate([D_spool_x, D_spool_y, base_h])
        rotate([0, 0, anchor * 120 - 30])
            translate([dist, 0, 0])
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
                vertical_spool();
            }
            position_spool("B") {
                vertical_spool();
            }
            position_spool("C") {
                vertical_spool();
            }
        }
        D_anchor(0);
        D_anchor(1);
        D_anchor(2);
        translate([D_spool_x, D_spool_y, base_h])
            mock_spool(false);
    }
}
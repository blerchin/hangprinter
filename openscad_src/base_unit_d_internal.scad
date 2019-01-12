include <parameters.scad>
use <util.scad>

use <motor_bracket_side.scad>

RENDER_BRACKETS = true;

layer_height = 25.4 / 2; //.5 inch

base_w = 240;
base_d = 350;
base_h = 7 * layer_height;

D_spool_x = base_w / 2;
D_spool_y = base_d / 2;

extra_bearing_width = 0.3;

mock_spool_h = Gear_height + Spool_height + 2;

Nema17_depth = 28 + 0.43;
Nema17_depth_mecha = Nema17_depth + 22;

motor_mount_depth = 6;

d_roller_depth = layer_height;
d_spool_depth = d_roller_depth + mock_spool_h + b623_vgroove_big_r;

module mock_motor() {
    gear_length = Gear_height + 7;
    color("steelblue")
    translate([-gear_length - 2, -Nema17_cube_width / 2, 0])
    union() {
        translate([gear_length, 0, Nema17_cube_width])
        rotate([0, 90, 0])
          rounded_cube2([Nema17_cube_width, Nema17_cube_width, Nema17_depth_mecha], 3);
        union() {
            rotate([0, 90, 0])
            translate([-Nema17_cube_width / 2, Nema17_cube_width / 2, 0])
              cylinder(r = Motor_outer_radius, h=gear_length + 0.1);
            translate([gear_length / 2, Nema17_cube_width / 2, Nema17_cube_width / 4])
              cube([gear_length + 0.1, Motor_outer_radius * 2, Nema17_cube_width / 2], center=true);
          }
    }
}

module mock_spool(center = true, r=Spool_outer_radius + 2, h=mock_spool_h, drop_in = false, axle_radius = 2.5, axle_length=2 * Gear_height + Spool_height) {
    union() {
        color("plum")
        cylinder(h=h, r=r + 1, $fn=8*8, center=center);
        color("green")
        translate([0, 0, -axle_length / 2])
        union() {
          cylinder(h=axle_length, r=axle_radius, $fn=4*4);
            if (drop_in) { 
              translate([0, axle_radius, axle_length / 2])
                cube(size=[2*axle_radius, 2*axle_radius, axle_length], center=true);
            }
        }
    }
        
}

module vertical_spool(center = true, drop_in = true, r=Spool_outer_radius + 2) {
    union() {
        rotate([90, 0, 0])
            mock_spool(center, drop_in = drop_in, r = r);
    }
}

module position_spool(anchor = "A") {
    translate_z = base_h - 1.5;
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
    channel_width = b623_width + extra_bearing_width;
    channel_len = 40;
    lineroller_bore = b623_bore_r;
    dist = Spool_outer_radius + 2 - channel_width;
    anchor_angle = anchor * 120;
    tangent_angle = anchor_angle - atan(channel_len / dist);
    color("plum")
    translate([D_spool_x, D_spool_y, base_h + 0.1])
        rotate([0, 0, tangent_angle - 30])
            union() {
                translate([dist, 0, -d_spool_depth])
                    rounded_cube2([channel_width, channel_len, d_spool_depth], channel_width / 2, $fn=16);
                translate([dist - channel_width / 2, channel_len - b623_vgroove_big_r, -d_roller_depth - lineroller_bore/2])
                    rotate([0, 90, 0])
                        cylinder(r=lineroller_bore, h=2 * channel_width);
       }
}

translate([-base_w / 2, -base_d / 2, 0])
base_unit();
module base_unit() {
    union() {
        difference() {
            rounded_cube2([base_w, base_d, base_h], 30);
            position_spool("A") {
                vertical_spool();
                rotate([0, 0, 90])
                translate([mock_spool_h / 2 + motor_mount_depth, -Spool_outer_radius / 2, -base_h - 0.1])
                    mock_motor();
            }
            position_spool("B") {
                vertical_spool();
                rotate([0, 0, 90])
                translate([mock_spool_h / 2 + motor_mount_depth, Spool_outer_radius / 2, -base_h - 0.1])
                    mock_motor();
            }
            position_spool("C") {
                vertical_spool();
                rotate([0, 0, 90])
                translate([mock_spool_h / 2 + motor_mount_depth, Spool_outer_radius / 2, -base_h - 0.1])
                    mock_motor();
            }
            translate([D_spool_x, D_spool_y, base_h - d_spool_depth + 0.03])
                mock_spool(center=false, h=d_spool_depth, axle_length = 100);
            D_anchor(0);
            D_anchor(1);
            D_anchor(2);
        }


    }
}
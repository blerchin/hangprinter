include <parameters.scad>
use <util.scad>

RENDER_BRACKETS = true;

layer_height = 25.4 / 2; //.5 inch
$fn = 64;

base_w = 250;
base_d = 360;
base_h = 4 * layer_height;

eigth_inch = 1.5875;
min_tool_radius = eigth_inch + 0.1125;

D_spool_x = base_w / 2;
D_spool_y = base_d / 2;

extra_bearing_width = 0.4;

//mock_spool_h = Gear_height + Spool_height + 2;
mock_spool_h = 27.3 + 2;

Nema17_depth = 28 + 0.43;
Nema17_depth_mecha = 75;
Nema17_ridge_r = 11;
Nema17_ridge_height = 2;

motor_mount_depth = -0.01;

gear_length = 30; //motor face -> spool base

motor_gear_r = 80; //center of spool -> center of motor

d_roller_depth = 0 * layer_height;
spool_gear_height = 18.87;

d_spool_depth = d_roller_depth + mock_spool_h;
d_spool_depth_round = ceil(d_spool_depth / layer_height) * layer_height;

//translate([0, 00, 0])
//mock_motor(square_gear = false);
module mock_motor(hole_shadow_depth = 7, gear_shadow = true, square_gear = true) {
    hole_shadow_width = 3.5;
    hole_shadow_length = 10;
    cw = Nema17_cube_width;
    gl = gear_length + 5;
    color("steelblue")
    translate([-gl, -cw / 2, -cw / 2])
    union() {
        translate([gl, 0, cw])
        rotate([0, 90, 0])
          rounded_cube2([cw, cw, Nema17_depth_mecha], 3);
        //gear
        rotate([0, 90, 0])
          if (square_gear) {
            translate([-cw / 2, cw / 2, gl / 2 + 0.1]) 
              //add extra space to knock out obstacles
              cube([3 * Motor_outer_radius, 3 * Motor_outer_radius, gl + 1], center=true);
          } else {
            translate([-cw / 2, cw / 2, 0.1])
              cylinder(r = Nema17_ridge_r, h=gl, $fn=64);
          }
        //gear shadow
        if (gear_shadow) {
            translate([gl / 2 + 0.1, cw / 2, cw / 4])
                cube([gl, Nema17_ridge_r * 2, cw / 2], center=true);
        }
        //mounting holes
        rotate([0, 90, 0])
        translate([-Nema17_cube_width / 2, cw / 2, gl - motor_mount_depth - hole_shadow_depth + 0.1])
          union() {
            Nema17_screw_holes(3.5, motor_mount_depth + hole_shadow_depth, $fs=1);
            //mounting hole shadow
            Nema17_screw_translate(4) {
              translate([0, -hole_shadow_width / 2, 0])
                cube([hole_shadow_length, hole_shadow_width, hole_shadow_depth]);
            }
          }
    }
}

module mock_spool(center = true, r=Spool_outer_radius + 2, h=mock_spool_h, drop_in = false, axle_radius = 4.1, axle_length=2 * (Gear_height + Spool_height), rounded = true, bracket_screws = false) {
    union() {
        color("plum")
        if (rounded) {
            cylinder(h=h, r=r, $fn=512, center=center);
        } else {
            cube([r * 2, r * 2, h], center=center);
        }
        color("green")
        translate([0, 0, -axle_length / 2])
        union() {
          cylinder(h=axle_length, r=axle_radius, $fn=64);
            if (drop_in) { 
              translate([0, axle_radius, axle_length / 2])
                cube(size=[2*axle_radius, 2*axle_radius, axle_length], center=true);
            }
            if (bracket_screws) {
                translate([-11.5, 0.1, (axle_length - mock_spool_h) / 4 ])
                  rotate([90, 0, 0])
                  cylinder(r=eigth_inch, h=layer_height);
                translate([-11.5, 0.1, mock_spool_h + (3/4) * (axle_length - mock_spool_h) ])
                  rotate([90, 0, 0])
                  cylinder(r=eigth_inch, h=layer_height);
                
            }
        }
    }
        
}

module vertical_spool(center = true, drop_in = false, r=Spool_outer_radius + 2) {
    union() {
        rotate([90, 0, 0])
            mock_spool(center, drop_in = drop_in, r = r, rounded = false, bracket_screws=true);
    }
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

module position_motor(r = Spool_outer_radius) {
    motor_x_offset = 25;
    moter_z_offset = 30;
    z_pos = base_h + 20;
    if (z_pos > r) {
        echo("z_pos out of range");
    }
    x_pos = sqrt(pow(r, 2) - pow(z_pos, 2));
    translate([-x_pos - motor_x_offset, mock_spool_h / 2 - 0.1, -z_pos])
        children();
}

module registration_holes(padding = 30, radius = eigth_inch) {
    translate([padding, padding, 0])
        cylinder(r=radius, h=base_h + 10);
    translate([base_w - padding, padding, 0])
        cylinder(r=radius, h=base_h + 10);
    translate([base_w / 2, base_d - padding, 0])
        cylinder(r=radius, h=base_h + 10);
}

module D_anchor(anchor = 0) {
    channel_width = b623_width + extra_bearing_width;
    channel_len = 55 + Spool_outer_radius - Spool_r;
    roller_inset = 2 * b623_vgroove_big_r;
    lineroller_bore = min_tool_radius;
    dist = Spool_r + 2 - channel_width / 2;
    anchor_angle = anchor * 120;
    tangent_angle = anchor_angle - atan(channel_len / dist);
//  dist_offset = tan(tangent_angle)
    color("magenta")
    translate([D_spool_x, D_spool_y, base_h + 0.1])
        rotate([0, 0, tangent_angle - 30])
            union() {
                translate([dist - channel_width / 2, -channel_width / 2, -d_spool_depth_round + 0.01])
                    rounded_cube2([channel_width, channel_len + roller_inset, d_spool_depth_round], channel_width / 2, $fn=32);
                translate([dist - 1.5 * channel_width, channel_len, -d_roller_depth])
                    rotate([0, 90, 0])
                        cylinder(r=lineroller_bore, h=3 * channel_width, $fn=32);
       }
}
projection(cut = true)
translate([-base_w / 2, -base_d / 2, -1 * layer_height + 0.1])
base_unit();
module base_unit() {
    union() {
        difference() {
            rounded_cube2([base_w, base_d, base_h], 30, $fn = 128);
            position_spool("A") { 
                rotate([0, 0, 180])
                union() {
                    vertical_spool();
                }
            }
            position_spool("B") {
                vertical_spool();
            }
            position_spool("C") {
                vertical_spool();
            }
            translate([D_spool_x, D_spool_y, base_h - d_spool_depth_round + 0.03])
                mock_spool(center=false, h=d_spool_depth_round, axle_length = 100);
            translate([D_spool_x + Spool_outer_radius + Motor_outer_radius, D_spool_y, -0.1])
            rotate([0, 90, 0])
                mock_motor(hole_shadow_depth=100, square_gear=false);
            D_anchor(0);
            D_anchor(1);
            D_anchor(2);
            registration_holes();
        }


    }
}

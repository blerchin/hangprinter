include <parameters.scad>
use <util.scad>
use <lineroller_anchor.scad>

$fn = 128;

inch = 25.4;

lineroller_dist = 150;
cinder_w = 195;
cinder_d = 142;
padding = 60;
base_h = inch / 2;
base_w = cinder_w + 2 * padding;
base_d = cinder_d + 2 * padding;
wiggle = 10;
hole_r = inch / 16 + 0.001;
hole_dist = Depth_of_lineroller_base - 2;

module base() {
  rounded_cube2([base_w, base_d, base_h], 30);
}

module cinder() {
    translate([padding - wiggle, padding - wiggle, base_h / 2 + 0.01])
        rounded_cube2([cinder_w + 2 * wiggle, cinder_d + 2 * wiggle, base_h / 2], 10);
}

module linerollers() {
    rotate([0, 0, 90])
        lineroller_anchor();
    translate([lineroller_dist, 0, 0])
        mirror()
        rotate([0, 0, 90])
            lineroller_anchor();
}
module lineroller_hole_pattern() {
    translate([0, 9, 0]) {
        cylinder(h = base_h + 0.1, r=hole_r);
        translate([-hole_dist, 0, 0])
            cylinder(h = base_h + 0.1, r=hole_r);
    }
}

module lineroller_holes() {
    lineroller_hole_pattern();
    translate([lineroller_dist, 0, 0])
        mirror([1, 0, 0])
        lineroller_hole_pattern();
}

projection(cut = true)
translate([0, 0, -base_h + 0.1])
difference() {
    union() {
        base();
        //translate([(base_w - lineroller_dist) / 2, padding / 4, base_h])
        //   linerollers();
    }
    translate([(base_w - lineroller_dist) / 2, padding / 4, -0.01])
        lineroller_holes();
    cinder();
}
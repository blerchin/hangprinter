include <parameters.scad>
use <util.scad>

lineroller_dist = 150;
hole_dist = Depth_of_lineroller_base - 2;
length_bracket = Depth_of_lineroller_base + 2*b623_vgroove_big_r + 2*Bearing_wall;
width_padding = 7;
width_bracket = lineroller_dist + 2 * hole_dist + 2 * width_padding;
height_bracket = 6;
width_clamp = 35;
depth_plate = 4.95;
depth_clamp = 22.25;
m3_radius = 1.55;

module lineroller_hole_pattern() {
    cylinder(h = height_bracket + 0.1, r=m3_radius, $fn = 32);
    translate([-hole_dist, 0, 0])
        cylinder(h = height_bracket + 0.1, r=m3_radius, $fn = 32);
}

module lineroller_holes() {
    translate([(-width_bracket + width_clamp + 2 * hole_dist) / 2 + width_padding, 0, -0.01]) {
      lineroller_hole_pattern();
      translate([lineroller_dist, 0, 0])
          mirror([1, 0, 0])
          lineroller_hole_pattern();
    }
}

module clamp() {
  difference() {
    translate([-130, -117, 0])
      import("./Light_Stand_GoPro_Mount.stl");
    translate([0, -9.9, 0])
      cube([100, 10, 100]);
  }
}

module translate_holes(corners = 4) {
  for (i=[0:90:90*corners - 1]){
    rotate([0,0,i+45])
      translate([width_bracket/2 - 1.4,0,0])
        rotate([0,0,-i-45])
          children();
  }
}

module angle() {
  translate([width_bracket, 0, 0])
  rotate([0, 0, 90])
    rounded_cube2([length_bracket, width_bracket, height_bracket], Lineroller_base_r, $fn=10*4);
  translate([(width_bracket - width_clamp) / 2, length_bracket - depth_clamp, height_bracket])
  rotate([0, -90, 180])
    scale([1, 1, 2.95])
    inner_round_corner(r=length_bracket - depth_clamp, h=2 * height_bracket, $fn=4*10);   
}

module bracket() {
  clamp();
  translate([-width_bracket / 2 + width_clamp / 2, -length_bracket + depth_clamp, 0])
    angle();
}

module hole_pattern() {
  translate([width_bracket / 2, length_bracket - depth_clamp - depth_plate + 0.7, -0.1])
  translate_holes() {
    cylinder(r=m3_radius, h=height_bracket + 0.1 + 10, $fn = 32);
  }
}
difference() {
  bracket();
  lineroller_holes();
}
include <parameters.scad>
use <util.scad>

bit_width = 12;
bit_len = 24;

module wing() {
  difference() {
   rotate([90,0,0])
      rounded_cube2([bit_len,bit_width,Base_th], Lineroller_base_r);
   screw();
  }


}

module screw() {
  translate([bit_width/2, 0, bit_width/2])
    rotate([90,0,0])
    translate([0,0,-1])
    cylinder(d=Mounting_screw_d, h=Base_th+2, $fs=1);
  translate([bit_width/2, 0, bit_width/2])
    rotate([90,0,0])
    translate([0,0,Base_th])
    cylinder(d2=Mounting_screw_head_d-4, d1=Mounting_screw_head_d, h=12, $fs=1);
}

wing();

include <parameters.scad>
use <util.scad>
use <lineroller_ABC_winch.scad>

base_th = 6;
l = Depth_of_lineroller_base + 2*b623_vgroove_big_r + 2*Bearing_wall;
track_l = l;
head_r = 3.5;
screw_r = 1.5;
post_r = 2;
receiver_r = post_r + 0.2;
tower_h = 17 + b623_vgroove_big_r;
x_len = Depth_of_lineroller_base-4; // For the two "wings" with tracks for screws
y_extra = -2.0; // For the two "wings" with tracks for screws


translate([0,-Depth_of_lineroller_base-5,0])
  mirror([0,1,0])
    lineroller_anchor(
);

lineroller_anchor();
module lineroller_anchor(){

  // Module lineroller_ABC_winch() defined in lineroller_ABC_winch.scad
  lineroller_ABC_winch(edge_start=0, edge_stop=120,
                       base_th = base_th,
                       tower_h = tower_h,
                       bearing_width=b623_width+0.2,
                       big_y_r=40,
                       big_z_r=29);

 
  base_mid(base_th = base_th);
  module base_mid(base_th, l = l){
    difference(){
      translate([-x_len, -Depth_of_lineroller_base/2, 0])
        translate([l, Depth_of_lineroller_base,0])
        rotate([0,0,180])
        rounded_cube2([l, Depth_of_lineroller_base, base_th], Lineroller_base_r, $fn=10*4);
        translate([Depth_of_lineroller_base / 2, 0, -0.01])
        cylinder(d=receiver_r * 2, h=base_th + 0.02, $fn=4*10);
    }
  }

  ptfe_guide();
  module ptfe_guide(){
    line_z = tower_h-b623_vgroove_big_r-b623_vgroove_small_r;
    length = 9;
    width = (Ptfe_r+2)*2;
    difference(){
      union(){
        translate([-x_len+length/2,0,base_th-0.1])
          linear_extrude(height=line_z-base_th+0.1, scale=[1,width/Depth_of_lineroller_base])
            square([length, Depth_of_lineroller_base], center=true);
        translate([-x_len,-width/2,base_th-0.1])
          translate([0, width/2, line_z-base_th+0.1])
            rotate([0,90,0])
            cylinder(d=width, h=length, $fn=4*10);
      }
      translate([-x_len,-width/2,base_th-0.1])
        translate([0, width/2, line_z-base_th+0.1])
        rotate([0,90,0])
        translate([0,0,-1]){
          cylinder(r=Ptfe_r, h=length, $fn=4*10);
          cylinder(r=Ptfe_r-0.5, h=length+2, $fn=4*10);
        }
      for(k=[0,1])
        mirror([0,k,0])
        translate([-x_len,-Depth_of_lineroller_base/2,-1])
        inner_round_corner(r=Lineroller_base_r, h=base_th+10, $fn=4*10);
    }
  }

}

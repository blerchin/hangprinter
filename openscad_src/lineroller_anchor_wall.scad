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
    anchor_wall();

anchor_wall();

module anchor_wall(){

  module slot_for_countersunk_screw(len){
    translate([-x_len, -Depth_of_lineroller_base/2, 0]){
      translate([len-Depth_of_lineroller_base/2, Depth_of_lineroller_base/2, -0.1]){
        rotate([0,0,180]){
          translate([0,0,Screw_h+Screw_head_h-0.01])
            linear_extrude(height=1)
            scale(1+(head_r-screw_r)/screw_r)
            translate([0,-screw_r])
            union(){
              square([track_l-screw_r, 2*screw_r]);
              translate([0,screw_r])
                circle(r=screw_r,$fn=4*10);
            }
          linear_extrude(height=Screw_h+1)
            translate([0,-screw_r])
            union(){
              square([track_l-screw_r, 2*screw_r]);
              translate([0,screw_r])
                circle(r=screw_r,$fn=4*10);
            }
          translate([0,0,Screw_h])
            linear_extrude(height=Screw_head_h, scale=1+(head_r-screw_r)/screw_r)
            translate([0,-screw_r])
            union(){
              square([track_l-screw_r, 2*screw_r]);
              translate([0,screw_r])
                circle(r=screw_r,$fn=4*10);
            }
        }
      }
    }
  }



  //Wall mount follows
  wall_mount();
  module wall_mount(){
      d = Depth_of_lineroller_base;
      length_shelf = 2 * l / 3;
      offset_post = length_shelf * 7/12;
      
      //translate([l/2 + post_r + 3.6, 0, 0])
      rotate([0, 90, 0])
      translate([-base_th, 0, d / 2])
        difference() {
            union() {
                //wall fixture
                translate([0, -d / 2, 0])
                rotate([0, 90, 0])
                rounded_cube2([l, d, base_th], Lineroller_base_r, $fn=10*4);
            
                //rounded support (top)
                rotate([0, -90, 90])
                translate([-base_th, 0, -d / 2])
                inner_round_corner(r=base_th / 3, h=d, $fn=4*10);
          
                //shelf
                rotate([0, 0, 90])
                translate([-d / 2, -base_th, -2 *base_th])
                rounded_cube2([d, length_shelf + base_th, base_th], Lineroller_base_r, $fn=10*4);
                  
                //post
                translate([-offset_post, 0, -base_th])
                cylinder(d=post_r * 2, h=base_th, $fn=10*4);
                
                                        
                //post lattice
                translate([0, -post_r /2, -base_th + 0.5])
                rotate([90, 0, 180])
                support_rectangle([post_r, base_th - 0.5, offset_post - post_r - 0.1]);
                
                //rounded support (bottom)
                translate([0, -d/2, -2 * base_th])
                rotate([0, 90, 90])
                inner_round_corner(r=length_shelf / 2, h=d, $fn=4*10);   
            };
            rotate([0, -90, 0])
            translate([-l / 2, 0, -base_th])
            slot_for_countersunk_screw(l);
        }

  }

}

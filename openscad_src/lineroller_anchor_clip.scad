include <parameters.scad>
use <util.scad>
use <lineroller_ABC_winch.scad>

base_th = 6;
leg_th = 3;
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
    clip();

clip();

module clip(){
  d = Depth_of_lineroller_base;
  length_clip = 30;
  offset_post = length_clip / 2;
  
  translate([length_clip / 2, -d * 2, 0])
  rotate([90, 0, 0])
  translate([-base_th, 0, -l])
    difference() {
        union() {
            //clip side 1
            translate([0, -d / 2, -leg_th])
            rotate([0, 90, 0])
            cube([l, d, leg_th]);
            
            //clip side 2
            translate([-length_clip, -d / 2, -leg_th])
            rotate([0, 88, 0])
            cube([l, d, leg_th]);
      
            //shelf
            rotate([0, 0, 90])
            translate([-d / 2, -leg_th, -base_th])
            cube([d, length_clip + leg_th, leg_th]);
              
            //post
            translate([-offset_post, 0, -leg_th])
            cylinder(d=post_r * 2, h=base_th, $fn=10*4);
                            
            //post lattice
            translate([-offset_post, -post_r / 2, 0.5 - leg_th])
            rotate([90, 0, -90])
            support_rectangle([post_r, base_th - 0.5, d / 2 - post_r / 2]);
            
            //rounded support (bottom 1)
            translate([0, -d/2, -base_th])
            rotate([0, 90, 90])
            inner_round_corner(r=base_th / 2, h=d, $fn=4*10);   
            
            //rounded support (bottom 2)
            translate([-length_clip + leg_th, d / 2, -base_th])
            rotate([180, 90, 90])
            inner_round_corner(r=base_th / 2, h=d, $fn=4*10);   

        };

        
        //rounded edge 1
        translate([leg_th, -d/2 - 0.01, -leg_th])
        rotate([0, 90, 90])
        inner_round_corner(r=2 * base_th / 2, h=d + 0.02, $fn=4*10);
        
        //rounded edge 2
        translate([-length_clip + 0.05, d / 2 + 0.01, 0.1 - leg_th])
        rotate([180, 90, 90])
        inner_round_corner(r=2 * base_th / 2, h=d + 0.02, $fn=4*10);
    }

}

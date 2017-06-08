$fn=100;
tube_radius=10; //mm
tube_height=80; //mm
cap_height=10; //mm


module grooveTool(r_groove=2, r_torus=10) {
    rotate_extrude(angle=360, convexity=2)
    translate([r_torus,r_groove,0])
    circle(r=r_groove);
}

module classicBite() {
    difference(){
        union(){
            cylinder(h=cap_height, r1=tube_radius, r2=tube_radius*0.8);

            translate([0,0,-tube_height])
            cylinder(h=tube_height, r=tube_radius);
            
            translate([0,0,-tube_height-cap_height])
            cylinder(h=cap_height, r1=tube_radius*0.8, r2=tube_radius);
        }

        translate([0,0,0])
        cylinder(r=tube_radius*0.5, h=cap_height+2);

        translate([0,0,-5])
        grooveTool(1, tube_radius);

        translate([0,0,-tube_height+10])
        grooveTool(1, tube_radius);


        translate([0,0,-tube_height+5])
        grooveTool(1, tube_radius);
    }
}

*classicBite();

for(i = [0:9]) 
{
    translate([i*(tube_radius*2+1),0,tube_radius])
    rotate([-90,-90,0])
    classicBite();
}

translate([-20, -25,-0.25])
cube([250, 15, 0.5]);

translate([-20, -50,-0.25])
cube([250, 15, 0.5]);

$fn=100;
tube_radius=15; //mm
tube_height=100; //mm
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

    translate([0,0,-90])
    grooveTool(1, tube_radius);


    translate([0,0,-95])
    grooveTool(1, tube_radius);

    }
}

classicBite();
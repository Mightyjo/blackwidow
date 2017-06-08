$fn=50;

module grooveTool() {
    difference() {
        linear_extrude(height=1) 
        minkowski(){
            square(size=10./3, center=true);
            circle(r=10./3, center=true);
        }
        
        linear_extrude(height=1) 
        minkowski(){
            square(size=9./3, center=true);
            circle(r=9./3, center=true);
        }
    }
}

*translate([0,0,10])
grooveTool();

module widowBite() {
    difference(){
    union(){
        linear_extrude(height=8, scale=0.65) 
        minkowski(){
            square(size=10./3, center=true);
            circle(r=10./3, center=true);
        }

        translate([0,0,-50])
        linear_extrude(height=50) 
        minkowski(){
            square(size=10./3, center=true);
            circle(r=10./3, center=true);
        }
    }

    translate([0,0,-50])
    cylinder(r=2.5, h=70);

    translate([0,0,-2])
    grooveTool();

    translate([0,0, -7])
    rotate([90,0,0])
    cylinder(d=3.5, h=12, center=true);

    translate([2.5,0,-7])
    minkowski() {
        cube([5,3,3], center=true);
        sphere(r=1);
    }

    translate([0,0, -40])
    rotate([90,0,0])
    cylinder(d=3.5, h=12, center=true);


    translate([2.5,0,-40])
    minkowski() {
        cube([5,3,3], center=true);
        sphere(r=1);
    }

    translate([0,0,-47])
    grooveTool();

    }
}

for(i = [0:11]) 
{
    translate([i*(10+1),0,10./2])
    rotate([-90,-90,0])
    widowBite();
}

translate([-10, -20,-0.25])
cube([180, 15, 0.5]);

translate([-10, -45,-0.25])
cube([180, 15, 0.5]);

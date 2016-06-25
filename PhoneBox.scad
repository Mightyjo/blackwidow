$fn=100;

module casePrimitive(){
    minkowski(){
        cube([80, 35, 160], center=true);
        sphere(r=1.5);
    }

    translate([0,0,1])
    minkowski(){
        cube([85, 15, 162], center=true);
        sphere(r=1.5);
    }
}

module keyTool(d=0, h=1.5) {
    rotate([90,0,0])
    linear_extrude(height=h)
    offset(delta=d)
    polygon([[5,0],[30,0],[35,10],[0,10]]);
}

module boxNeck() {
translate([40,18,0])
difference() {
    cube([88, 40, 3], center=true);
    translate([0,0.25,0])
    cube([83, 36.5, 3.2], center=true);
}
}

module phoneBox() {
    union(){
        difference() {
            translate([40,17.5,81.5])
            casePrimitive();
            
            translate([0,0,21.75*5])
            keyTool(d=2.5);
            
            translate([0,0,23*5])
            boxNeck();

            for( i = [0:3] ) {
                translate([5, -3, i*3.5+17*5])  
                cube([70, 3, 1]);
            }
            
            for( i = [0:4] ) {
                translate([5, -3, 15.5*5-2-i*5])  
                cube([70, 3, 2]);
            }
            
            translate([5, -3, 10.5*5-4])  
            cube([70, 3, 7.1]);
            
            
            translate([40, 0, 48.5])
            rotate([90,0,0])
            linear_extrude(height=3)
            polygon([[0,0],
                     [35,0],
                     [35,37.5],
                     [27.5,37.5],
                     [0,7.5]
                    ]);
            
            translate([5, -3, 5])
            cube([50, 3, 37.5]);
            
            translate([60, -3, 5])
            cube([15, 3, 37.5]);
            
        }

       

        translate([5,0.02,5])
        rotate([90,0,0])
        linear_extrude(height=1.5)
        minkowski() {
            square([40, 30]);
            circle(r=1.5);
        }

        translate([68.25,0,11.5])
        rotate([90,0,0])
        linear_extrude(height=3)
        difference(){
            hull() 
            {
                circle(r=6.25);
                translate([0,12.5,0]) circle(r=6.25);        
            }

            circle(r=4.25);
        }

        for(i=[0:2]){
        translate([40,16.5,42+3.5*i])
        minkowski(){
            cube([85, 37, 1], center=true);
            sphere(r=1.5);
        }
        }
    }
}

module phoneBoxTop() {
    difference() {
        phoneBox();
        translate([-5, -5, -5])
        cube([90, 45, 121.5]);
        
        *translate([-5, 15, -5])
        cube([90,45, 170]);
        
        translate([0.5,2,0])
        cube([79, 32, 131.5]);
        
        translate([2.5,4,0])
        cube([75, 28, 160]);
    }
}

translate([-90, 0, -110])
phoneBoxTop();

module phoneBoxBottom() {
    union() {
        difference(){
            phoneBox();
            phoneBoxTop();

            *translate([-5, 15, -5])
            cube([90,45, 170]);
            
            translate([2.5,4,5])
            cube([75, 28, 160]);
        }
        
        translate([0,0,21.75*5])
        keyTool(d=0.75);
    }
}

translate([10, 0, 0])
phoneBoxBottom();
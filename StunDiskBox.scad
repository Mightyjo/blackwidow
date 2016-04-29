// Helper funtions for using $f{a,s,n} in my code
function fragments_for_r(r, fn=0, fa=12, fs=2) = 
    fn > 0.0 ? 
    (fn > 3.0 ? fn : 3.0) : 
    ceil(max(min(360.0 / fa, r*2*PI / fs), 5));
    
function frags (r=1) = fragments_for_r(r, $fn, $fa, $fs);

// Function and module to render the bean-shaped hole in the box's surface
function myNiftyCardioid(r=5, tmin=0, tmax=360.0) =
[ for (t=[tmin:(360.0 / frags(r)):tmax])
        [ r * 1.0 * cos(t) * (0.7 - cos(t)), 
          r * 0.75 * sin(t) * (1.4 - cos(t)) ]
];

module cardioidPoly(r=5) {
    polygon( myNiftyCardioid(r) );
}

module button() {
$fn=max($fn, 30);
difference(){
    union(){
        cylinder(r=5, h=2);

        translate([0,0,2])
        scale([1,1,0.25])
        sphere(r=5);

        for(i=[-60:60:300]){
            rotate([0,0,i])
            translate([3,0,2.25])
            sphere(r=1);
        }
    }

    translate([0,0,3.5])
    sphere(r=1);

}
}

module outerBox(){
    $fn=30;
    cornerRadius = 1.25;
    boxHeight = 85;
    boxWidth = 30;
    difference() {
    translate([cornerRadius, 0])
    minkowski(){
        square([boxWidth-cornerRadius, 
                boxHeight-cornerRadius]);
        circle(r=cornerRadius);
    }
    
    // Square off the bottom. Leave the radiuses on top.
    translate([-cornerRadius, -cornerRadius])
    square([boxWidth+cornerRadius*2, cornerRadius]);
    }
}

// the curvyOnlay has a bounding box of [57, 49]
module curvyOnlay() {
union(){
translate([55*sin(30),-17.5*sin(30)])
difference() {
    rotate([0,0,30])
    union(){
    square([40,40]);
    translate([0,25])
    circle(r=15);
    translate([40,25])
    circle(r=15);
    }
    
    translate([29.5,0])
    square([30, 100]);
    
    translate([-30,0])
    square([100, 8.75]);
}

translate([42.0,0])
square([15,8.5]);
}
}

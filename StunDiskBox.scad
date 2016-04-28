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

// Render quality settings
$fa=2; $fs=0.1;

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

//cardioidPoly();

module button() {
difference(){
    union(){
        cylinder(r1=6.5, r2=5, h=2);

        translate([0,0,1.875])
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

//button();

module boxPoly(dim=[42,85]){
    $fn=30;
    cornerRadius = 1.25;
    boxHeight = dim[1];
    boxWidth = dim[0];
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

//boxPoly();

// the curvyOverlay has a bounding box of [57, 49]
module curvyOverlay() {

difference() {
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
    
    translate([20,10])
    circle(r=5);
    
    translate([52, 20])
    cardioidPoly(r=12);
}
}

//curvyOverlay();

module obnoxiousInlay() {
    // We're recreating the cuts made to the box as a whole, so duplicate up here - with some offset - the solid tools used to cut the diskPack.  Then we'll use this to cut the disk pack too. Inception!
    difference() {
        square([40, 96]);
        
        translate([0, 67.5])
        rotate([0,0,60])
        square([50, 40]);
        
        translate([9, 86,  0])
        rotate([0, 0, 35])
        cardioidPoly(r=16);
        
        translate([6, -2, 0])
        curvyOverlay();
        
        translate([10.25, 21.25])
        rotate([0,0, -40])
        square([50,50]);
        
        translate([20, 3])
        square([10,10]);
    }
    
}

//obnoxiousInlay();

module diskPackSolid() {
    union() {
    // The outside box has its front corner cut off
    difference() {
        translate([0,65,0])
        rotate([90,0,0]) 
        linear_extrude(height=65)
        boxPoly([42, 101]);
        
        translate([-1,0,70])
        rotate([60, 0, 0])
        cube([50,80,50]);
        
        translate([41.75, 11, 86])
        rotate([90, -35, 90])
        linear_extrude(height=1.52)
        cardioidPoly(r=13);
        
        translate([43, 2, 2])
        rotate([90,0,90])
        minkowski() {
            linear_extrude(height=1)
            offset(delta=-1) obnoxiousInlay();
            
            sphere(r=1, $fn = 20);
        }
    }
    
    // The inside box is offset toward the y-axis
    translate([2.5,65,0])
    rotate([90,0,0])
    linear_extrude(height=65)
    boxPoly([35, 98.5]);
    
    // Fill in part of the gap on the outer box near x=0
    cube([2.5, 30, 96]);
    
    // Fill in part of the gap on the outer box near
    // x=100.  This is tricky because the Minkowski
    // operation added some thickness for which I 
    // haven't accounted yet in my formulas.
    // Empirically, the x-offset in the translate is
    // where I've determined the inner box ends.  
    // The width of the cube should be 1mm - 1.5mm less
    // that the remaining extent of the outer box.  
    translate([38.75, 0, 0])
    cube([3, 30, 86]);
    
    translate([40.5, 9, 75])
    rotate([0,90,0])
    button();
    
    translate([43, 8, 0])
    rotate([90,0,90])
    linear_extrude(height=1.5)
    curvyOverlay();
    
    }
}

module diskPack(){
difference() {
    diskPackSolid();
    
    translate([5.75, -0.1, 5])
    cube([30, 60.1, 91]);
}
}

//diskPack();

module drawer() {
difference() {
    cube([29.75, 59.75, 90.75]);
    
    translate([2.5, 2.5, 2.5])
    cube([27.6, 55, 86]);
}
}

// Translate for prettiness beside the case while debugging
//translate([-50, -10, 5]) drawer();

module frontAndBackTrimPart() {
union() {
    difference() {
        linear_extrude(height=7, scale=[.75, .9])
        square([17, 98.5], center=true);
        
        translate([0,-(85.25/2)+3,7])
        rotate([0, 90, 0])
        cylinder(h=14, r=3, center=true);
        
        translate([0,(85.25/2)-3,7])
        rotate([0, 90, 0])
        cylinder(h=14, r=3, center=true);
        
        translate([1,-(80.25/2),4])
        cube([6, 80.25, 5]);
        
        translate([-7,-(80.25/2),4])
        cube([6, 80.25, 5]);
    }
    
    translate([-1,-(86.25/2),0])
    cube([2, 86.25, 7]);
    
    translate([1,86.25/2,2.5])
    rotate([90,0,0])
    linear_extrude(height=86.25)
    polygon(points=[[0,0], [0, 3.5], [3.5, 3.5]]);
    
    translate([-1,-(86.25/2),2.5])
    rotate([90,0,180])
    linear_extrude(height=86.25)
    polygon(points=[[0,0], [0, 3.5], [3.5, 3.5]]);
}
}

//frontAndBackTrimPart();

module frontAndBackTrim() {
union() {
linear_extrude(height=1)
boxPoly([35, 98.5]);

translate([35-(17/2)+0.75, (98.5/2), 0])  
frontAndBackTrimPart();

translate([(17/2)+0.75, (98.5/2), 0])  
frontAndBackTrimPart();
}
}

// Uncomment to check final proportions and for PNGs
// Assumes the diskPack and drawer debugs are both on
//
//    translate([-52.5, -10, 0])
//    rotate([90,0,0])
//    frontAndBackTrim();
//
//    translate([38.75, 64, 0])
//    rotate([90,0,180])
//    frontAndBackTrim();
//

forRealp = false;
forRealp = true;

if(forRealp) {
// This build needs some help on the platter
translate([5, 0, 65])
rotate([-90, 0, 0])
diskPack();

translate([-65, 0, 0])
rotate([0, -90, -90])
drawer();

translate([-(50+1.25), -5, 0])
rotate([0, 0, -90])
frontAndBackTrim();

translate([40+1.25, 101+5, 0])
rotate([0, 0, 90])
frontAndBackTrim();
}
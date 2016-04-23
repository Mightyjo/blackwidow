// Globals :(
polyMaxX = 60;
polyMaxY = 45;
halfBoxHeight = 17.5;
bezelHeight = 2.5;

module batteryPoly() {

// Update polyMaxX and polyMaxY if these points change
points = [
    [2.5, 22],
    [0, 17],
    [0, 5],
    [5, 0],
    [17, 0],
    [22, 2.5],
    [60, 2.5],
    [60, 45],
    [2.5, 45]
];

newpoints = [for (i=points) i-[polyMaxX, polyMaxY]];
paths = [
    [0,1,2,3,4,5,6,7,8]
];

union(){
//Bottom Left
polygon(points=newpoints, paths=paths);

//Bottom Right
rotate([0,180,0])
polygon(points=newpoints, paths=paths);

//Top Left
rotate([180,0,0])
polygon(points=newpoints, paths=paths);

//Top Right
rotate([180,180,0])
polygon(points=newpoints, paths=paths);
}
}

module batteryHalfPack(){
    
union(){
linear_extrude(height=halfBoxHeight){
batteryPoly();
}

// Make the width and height of the bevel equal
bezelWidth = bezelHeight;

// This produces an even bevel all around the perimeter
bezelScale = [ 1-(bezelWidth/polyMaxX),
               1-(bezelWidth/polyMaxY)];

translate([0,0,halfBoxHeight])
linear_extrude( height=bezelHeight, 
                scale=bezelScale){
    batteryPoly();
}
}
}

module batteryPack() {

// I want the inset to be smaller than the bezel so there will be a flat top to strengthen it. I accomplish this by tweaking the scale to make the inset uniformly smaller than the bezel.
insetWidth = 1+bezelHeight;    
insetToolScale = [1-(insetWidth/polyMaxX),
                  1-(insetWidth/polyMaxY),
                  1];

// This scales a sphere to make indentations on either side of a faux access panel.  These dimensions are independent of any others, even if they have the same values.
divotToolScale = [5,10,2.5];

// DEBUG: comment this and set $fa, $fs for STL render
$fn = 10;
    
// PROD: comment this and set $fn for preview
//$fa = 2; $fs = 0.2;

union(){

difference(){
    
    union(){
        batteryHalfPack();
        mirror([0,0,1]) batteryHalfPack();
    }
    
    // Top inset cutting tool
    translate([0,0,halfBoxHeight])
    scale(insetToolScale)
    linear_extrude( height=3 ) batteryPoly();
    
    // Left divot cutting tool
    difference(){
        translate([-35, 0, halfBoxHeight])
        scale(divotToolScale)
        sphere(r=1);
        
        translate([-35, -10, halfBoxHeight-2.5])
        cube(2*divotToolScale);
    }   
    
    // Right divot cutting tool
    difference(){
        translate([35, 0, halfBoxHeight])
        scale(divotToolScale)
        sphere(r=1);
        
        translate([25, -10, halfBoxHeight-2.5])
        cube(2*divotToolScale);
    }
    
    // Top battery panel cutting tool
    difference(){
        translate([-35, -25, halfBoxHeight-2.5])
        cube([70, 50, 3]);
        
        translate([-34.5, -24.5, halfBoxHeight-2.5])
        cube([69, 49, 3]);
    }
} //difference

// The dimensions and placement of the following objects are determined by eyeballing.
// TODO: Fix the dimensions and placement of the following as ratios related to batteryPoly.

// Left side knob
translate([-57.5, 0, 5])
sphere(r=5);

// Right side knob
translate([57.5, 0, 5])
sphere(r=5);

//Left top knob
translate([-43,0,16])
difference(){
    sphere(r=2.5);
    cylinder(r=1, h=2.5);
}

//Right top knob
translate([43,0,16])
difference(){
    sphere(r=2.5);
    cylinder(r=1, h=2.5);
}

} //union

} //module batteryPack

batteryPack();

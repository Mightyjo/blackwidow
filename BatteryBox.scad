// Globals :(
polyMaxX = 62.5;
polyMaxY = 47.5;
halfBoxHeight = 25;
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
    [62.5, 2.5],
    [62.5, 47.5],
    [2.5, 47.5]
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
insetWidth = 2.5+bezelHeight;    
insetToolScale = [1-(insetWidth/polyMaxX),
                  1-(insetWidth/polyMaxY),
                  1];

// This scales a sphere to make indentations on either side of a faux access panel.  These dimensions are independent of any others, even if they have the same values.
divotToolScale = [5,10,2.5];

// DEBUG: comment this and set $fa, $fs for STL render
//$fn = 10;
    
// PROD: comment this and set $fn for preview
$fa = 2; $fs = 0.2;

union(){

difference(){
    
    union(){
        batteryHalfPack();
        mirror([0,0,1]) batteryHalfPack();
    }
    
    // Top inset cutting tool
    translate([0,0,halfBoxHeight+1])
    minkowski(){
        linear_extrude( height=3 ) 
        offset(delta=-(2.5+bezelHeight+1))
        batteryPoly();
        
        sphere(r=1, $fn=20);
    }    
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

// Additive decorations follow

// Left side knob
translate([-(polyMaxX-5), 0, halfBoxHeight-12.5])
sphere(r=5);

// Right side knob
translate([(polyMaxX-5), 0, halfBoxHeight-12.5])
sphere(r=5);

//Left top knob
translate([-43, 0, halfBoxHeight-1.5])
difference(){
    sphere(r=2.5);
    cylinder(r=1, h=2.5);
}

//Right top knob
translate([43, 0, halfBoxHeight-1.5])
difference(){
    sphere(r=2.5);
    cylinder(r=1, h=2.5);
}

} //union

} //module batteryPack

// Make two battery packs, a top and a bottom.
// Make the top first, then use it as a tool to shape the bottom.

module boxTop() {
difference() {
    batteryPack();
    
    // DEBUG: Cut away half the cube so I can see where the holes go
    *translate([0,-polyMaxY-0.5,-(halfBoxHeight+bezelHeight)-0.5])
    cube([polyMaxX+1, 
          2*polyMaxY+1, 
          2*(halfBoxHeight+bezelHeight)+1]);
    
    // Cut off the bottom where the top will stop, probably at the beginning of the bezel or just before
    translate([0, 0,-(halfBoxHeight+bezelHeight/2+1/2)])
    cube([(2*polyMaxX)+10, 
          (2*polyMaxY)+10, 
          bezelHeight+1],
          center=true);

    // Cut the hole into the top that makes this a box
    translate([0,0,-3])
    cube([2*(polyMaxX-7.5), 
          2*(polyMaxY-7.5), 
          (2*halfBoxHeight)-3], 
          center=true);
}
}

module boxBottom() {
difference() {
    batteryPack();
    
    // Cut away the lid, leaving the inner box
    // This leaves an infintesimal shell in preview, ugh
    boxTop();
    
    // DEBUG: Cut away half the cube so I can see where the holes go
    *translate([0,-polyMaxY-0.5,-(halfBoxHeight+bezelHeight)-0.5])
    cube([polyMaxX+1, 
          2*polyMaxY+1, 
          2*(halfBoxHeight+bezelHeight)+1]);
    
    
    // Cut the hole into the bottom that makes this a box
    // Translate up 3mm to leave a 5.5mm bottom wall
    // (3mm + 2.5mm bezel).  That's plenty to stabilize
    // the heat-set nuts I plan to use.
    translate([0,0,3])
    cube([2*(polyMaxX-12), 
          2*(polyMaxY-12), 
          (2*halfBoxHeight)], 
          center=true);
}
}

translate([75, 50, 0])
boxTop();

translate([-75, -50, 0])
boxBottom();


// The boxBottom's inside dimensions are:
// 44mm z
// 101mm x
// 61mm y
//
// The side walls are approximately 5mm thick
// the top is 3mm on average and the bottom is
// 5mm in the center.  (The bottom edges are
// tapered from 2.5mm to nothing.)
//
// That's all subject to change with the magic numbers
// in my code.  I computed it all with a desk calculator
// so maybe someday I'll add echo's with the formulae.

//minkowski(){
//    scale([.9, .9, 1])
//    linear_extrude( height=3 ) 
//    batteryPoly();
//    
//    sphere(r=3, $fn=20);
//}
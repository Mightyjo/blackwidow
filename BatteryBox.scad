module batteryPoly() {
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
newpoints = [
    
    [2.5-60, 22-45],
    [0-60, 17-45],
    [0-60, 5-45],
    [5-60, 0-45],
    [17-60, 0-45],
    [22-60, 2.5-45],
    [60-60, 2.5-45],
    [60-60, 45-45],
    [2.5-60, 45-45]
];
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
linear_extrude(height=17.5){
batteryPoly();
}

bevelScale = [1-(2.5/60),1-(2.5/45)];
translate([0,0,17.5])
linear_extrude( height=2.5, 
                scale=bevelScale){
    batteryPoly();
}
}
}

module batteryPack() {
    
insetToolScale = [1-(3.5/60), 1-(3.5/45), 1];
divotToolScale = [5,10,2.5];
$fn = 10;

union(){

difference(){
    
    union(){
        batteryHalfPack();
        mirror([0,0,1]) batteryHalfPack();
    }
    
    // Top inset cutting tool
    translate([0,0,17.5])
    scale(insetToolScale)
    linear_extrude( height=3 ) batteryPoly();
    
    // Left divot cutting tool
    difference(){
        translate([-35, 0, 17.5])
        scale(divotToolScale)
        sphere(r=1);
        
        translate([-35, -10, 15])
        cube(2*divotToolScale);
    }   
    
    // Right divot cutting tool
    difference(){
        translate([35, 0, 17.5])
        scale(divotToolScale)
        sphere(r=1);
        
        translate([25, -10, 15])
        cube(2*divotToolScale);
    }
    
    // Top battery panel cutting tool
    difference(){
        translate([-35,-25,15])
        cube([70, 50, 3]);
        
        translate([-34, -24, 15])
        cube([68, 48, 3]);
    }
} //difference

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

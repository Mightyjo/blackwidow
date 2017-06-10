$fn=50;

difference() {
cube([60,40,0.5]);

for( i = [4:8:52] ){
    for( j = [24:8:32] ) {
        translate([i,j,0])
        translate([2.5, 2.5,0])
        cylinder(r=2.5, h=2);
    }
}

for( i = [4:8:52] ){
    for( j = [4:8:16] ) {
        translate([i,j,0.95])
        minkowski() {
            cube([3.5,3.5,5]);
            sphere(r=1);
        }
    }
}
}

$fn=100;

module BasePlate() {
    offset(r=-1)
    union() {
        resize([101, 31, 0])
        circle(r=10, center=true);

        translate([0, -10, 0])
        resize([102, 21, 0])
        circle(r=10, center=true);

        offset(r=2)
        polygon([
            [-5,23],
            [-10,10],
            [10,10],
            [5,23]
        ]);
    };
}

module TopPoly() {
    polygon([
        [0,15],
        [-5,15],
        [-8,5],
        [-40,-50],
        [-40,-70],
        [-18,-125],
        [-10,-160],
        [0, -160]
    ]);
}

module TopPlate() {
    offset(r=2)
    union() {
        TopPoly();
        mirror([1,0,0]) TopPoly();
    };
};

intersection() {
    intersection() {
        linear_extrude(height=30)
        TopPlate();

        translate([0, -60, -50])
        rotate([-80,0,0])
        resize([100,150,200])
        cylinder(d=100, h=200, center=true);
    };

    translate([0, 0, -50])
    rotate([80,0,0])
    resize([90,140,400])
    cylinder(d=100, h=200, center=true);

};


linear_extrude(height=2)
BasePlate();


/* How to make the round parts
 *
difference() {
intersection() {

    linear_extrude(h=50)
    BasePlate();
    
    translate([0, 0, 30])
    rotate([90,0,0])
    cylinder(d=100, h=50, center=true);
}

    translate([0, 0, 30])
    rotate([90,0,0])
    cylinder(d=90, h=50, center=true);
}
*/
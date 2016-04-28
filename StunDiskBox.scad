$fa = 12;
$fs = 2;

function frags (r=1) = fragments_for_r(r, $fn, $fa, $fs);

function fragments_for_r(r, fn=0, fa=12, fs=2) = 
    fn > 0.0 ? 
    (fn > 3.0 ? fn : 3.0) : 
    ceil(max(min(360.0 / fa, r*2*PI / fs), 5));

function myNiftyCardioid(r=5, tmin=0, tmax=360.0) =
[ for (t=[tmin:(360.0 / frags(r)):tmax])
        [ r * 1.0 * cos(t) * (0.7 - cos(t)), 
          r * 0.75 * sin(t) * (1.4 - cos(t)) ]
];

polygon( myNiftyCardioid() );
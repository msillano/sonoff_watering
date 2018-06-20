
 difference() {
   resize([28,16,20]) 
       union() {
           difference() {
                sphere(r = 12);
                sphere(r = 10);
                translate([-15, -15, -30]) {cube(size =[30,30,30]);};
           }
           translate([0, 0, -8+0.1])
                difference() {
                    cylinder(h= 8, r = 12);
                    cylinder(h= 8, r = 10);
           };
      }
      translate([10, 0, -3])rotate(a=[0,90,0])cylinder(h= 16, r = 1.5);   

    }

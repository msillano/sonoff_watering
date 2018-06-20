/*
   e3DHW project © 2018 Marco Sillano  (marco.sillano@gmail.com)
   This library is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as published
   by the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This project is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.
   Designed with: http://www.openscad.org/
   Tested with: 3DRAG 1.2 https://www.futurashop.it/3drag-stampante-3d-versione-1.2-in-kit-7350-3dragk
*/
/*
 The e3DHW project is a set of libraries and things in OpenSCAD to make actual DIY electronics hardware in a simple and modular way (see e3DHW_HOWTO.pdf).

 This base library generates an hollow or solid slab of any shape, to be used as structural support for electronics modules and devices.
 An hollow base with a square grid pattern:
     - uses less material
     - allows air circulation
The base board can be used alone to place many small pcb in a container, or can be used with DIN rail clips (see e3DHW_base_lib.scad) or... as you like.
 Above the base can be placed several addons (see files e3DHW_addon_xxxxx.scad) as spacers, terminals etc.

MAIN MODULES
 polyBase:  makes a hollow base board of any shape, using 2 arrays for vertex and holes.
 
 rectangleBase: easy module for rectangular hollow boards with 4 mounting holes.
 
More public in this library:
Constants:
note: public capital constants are used as default values here and in other e3DHW libraries: you can redefine them in your file (global change) or you can use the method parameters (local change), as you need.
EXTRA = 0.1;  // quantum anti non-manifold error.
BOARDTHICKNESS = 3; // default base board thickness
BORDERTHICKNESS = 2; // default border thickness
DEFAULTFILL = 40;  // default hollow factor
note: The grid as a long rendering time. For fastest tests you can use fill=0 or 100.

Modules:
 getBorder: utility module widely used in other e3DHW libraries.

 see also:
 The file e3DHW_pcb_board_data.scad is a collection of commercial pcb geometries, to be used with polyBase().
 The file e3DHW_addon_base.scad is a collection of util things that you can place on base board (see exemples).
 
All e3DHW designs are experimental and may change.

The exemple STL file is from a real project: a timed watering system with local rain detection, controlled via MQTT (IoT).

ver. 0.1.1    18/03/2018 base version
*/

/*
Instructions
How to use "e3DHW_base_lib.scad" library:
  - put all libraries in same directory as your project.
  - In your OpenSCAD code add on top: "include <e3DHW_base_lib.scad>;" then you can use this public modules as you like.

 Tested using 3DRAG, PLA, layer 0.2, perimeter 4 layers, infill 40%-60%.
 For a professional result, choose a high temperature and approved Flame Retardant filament.
*/

include <MCAD/polyholes.scad>
// -------------- parameters  (change with care)

EXTRA = 0.1;  // quantum anti non-manifold error.
BOARDTHICKNESS = 3;
BORDERTHICKNESS = 2;
DEFAULTFILL = 40;

// locals, privates:
_gridSolid = 4;   // square grid solid width (mm)
_gridAngle = 45;
_slabborder = 6;   // board perimetral border (mm)
_slabcorner = 2;   // board round corners (radius, mm)

_slabHoleClearance = 6;   // solid border around mounting holes (radius, mm)

_printer_max_x = 200;  // limits of 3D printer
_printer_max_y = 200; 
//======================= EXPORT MAIN MODULES

// polyBase: makes a hollow base of any shape, using the arrays vertex and holes.
// parameters:
// vertex is an array of points: [[p1.x, p1.y],[p2.x,p2,y],...]
//     x range: mm [0.._printer_max_x], y range: mm [0.._printer_max_y]]
// holes is an array of mounting holes: [[h1.x,h1.y,h1.d],...]. Each hole will have around a solid circular border (_slabHoleClearance).
// fill: a value in percent: 0 (empty)... 100 (solid), usual range 20..50. (default DEFAULTFILL)
// thickness: board thickness. (default BOARDTHICKNESS)
// note: the square holes in hollow grid are calculated from fill and _gridSolid parameter: smaller _gridSolid value produces smaller holes.
module polyBase(vertex, holes, fill= DEFAULTFILL, thickness =BOARDTHICKNESS){
    intersection(){
      _do_baseh(vertex, holes, fill, thickness);
      translate([0,0,-EXTRA])_cut_base(vertex,thickness+2*EXTRA);
      }
}

//rectangleBase: easy module for rectangular hollow boards with 4 mounting holes. See images for parameters.
// holex: x holes distance 
// holey: y holes distance
// dxl, dxr: x border, left and right (board x size = holex+dxl+dxr)
// dyu, dyl: y border, up and low (board y size = holey+dyu+dyl)
// dhole: holes diameter
// fill: a value in percent: 0 (empty)... 100 (solid), usual range 20..50. (default DEFAULTFILL)
// thickness: board thickness. (default BOARDTHICKNESS)

module rectangleBase(holex, holey, dxl=10, dxr=10, dyu=10, dyl=10, dhole = 3, fill= DEFAULTFILL, thickness =BOARDTHICKNESS) { 
    rectPoints = [[0,0],[holex+dxl+dxr,0],[holex+dxl+dxr,holey+dyu+dyl],[0,holey+dyu+dyl]];
    rectHoles = [[dxl,dyl,dhole],[dxl,holey+dyl,dhole],[dxl+holex,dyl,dhole],[dxl+holex,holey+dyl,dhole]];
   polyBase(rectPoints, rectHoles, fill, thickness); 
   }

//getBorder: utility module, generates borders from vertex (rounds corners).
// vertex is an array of points: [[p1.x, p1.y],[p2.x,p2,y],...]
// height: border height (vertical)
// b: border thickness (default BORDERTHICKNESS)
module getBorder(vertex, height, b = BORDERTHICKNESS){
 difference(){
    _cut_base(vertex, height);
    translate([0,0,-EXTRA])linear_extrude(height = height+2*EXTRA, convexity = 20, twist = 0)  offset(delta=-b) polygon(vertex); 
        }
    }

// ===================== private local modules
module _do_grill(f,h){
    if (f > 98){
        cube([_printer_max_x+50,_printer_max_y+50,h],false);
    }  else {
        t = sqrt(100/(100-f-1));
        y = _gridSolid/(t-1);
       prtL = _printer_max_x> _printer_max_y ? _printer_max_x:_printer_max_y;
       translate([prtL/2,prtL/2,0])rotate([0,0,_gridAngle]) translate([-prtL*3/4,-prtL*3/4,0])union(){
          for (k = [0 : _gridSolid+y : prtL*3/2])  
             translate([k,0,0]) cube([_gridSolid,prtL*3/2,h],false); 
          for (j = [0 : _gridSolid+y : prtL*3/2])  
             translate([0,j,0]) cube([prtL*3/2,_gridSolid,h],false); 
       }
    }
 }
 
module _cut_base(vertex, hb){
    linear_extrude(height = hb, convexity = 20, twist = 0,$fn=64) offset(r=_slabcorner) offset(delta=-_slabcorner) polygon(vertex); 
}

module _do_baseh(vertex, holes, fill, s) {
difference(){
   union(){
      intersection(){
         _do_grill(fill, s);
         translate([0,0,-EXTRA])_cut_base(vertex,s+2*EXTRA);
         }
       getBorder(vertex, s, _slabborder);
       for (n =[0:1:len(holes)-1]) translate([holes[n].x,holes[n].y,0]) cylinder(r=_slabHoleClearance, h=s);
    }
   for (n =[0:1:len(holes)-1]) translate([holes[n].x,holes[n].y,-EXTRA]) polyhole(2*s,holes[n].z);
    }
}
/*
// =================== EXAMPLE
// base support for scheduled irrigation system with sonoff-basic + humidity meter (https://www.banggood.com/Soil-Hygrometer-Humidity-Detection-Module-Moisture-Sensor-For-Arduino-p-79227.html), to fit in Itead box
// see photos
include <e3DHW_addon_base.1.1.scad>        // the base board addons
include <e3DHW_pcb_board_data.1.1.scad>    // Sonoff pcb data

module watering_Sonoff03(){
   union() {
     rectangleBase(43,44,12.3,12.3,6,6); // base: size from Itead box
     //here you add and translate addons as reqired
     translate([0,0,0])add_polyBox(sonoffBasicVertex);
     translate([17,38.3,0])add_rectangleBox(30.50,15.08); // humidity meter pcb
     translate([66,38.3,0])add_text(txt="MSWS03", size=3, rot=[0,0,90]);
     }
  }
// top level geometry:
watering_Sonoff03();
*/

include <relativity/relativity.scad>

$fn = 32;

// Shaft or shank
shaft_diameter = 6;
shaft_radius = shaft_diameter / 2;
shaft_length = 50;

// Handle or bow
bow_width = 18;
bow_height = 23;

bit_length = 8;
bit_depth = 12;
bit_thickness = 3.8;
bit_distance_top = -7; // Distance from top end of shaft
bit_off_axis = -0.4; // Moved towards build plate

// Cuts
cut_shallow_width = 4;
cut_deep_width = 1.4;
cut_depth = 2;

ward_radius = 2 / 2;
ward_depth = 1.5;
ward_pos_bottom = 6;

module handle() {
  difference() {
  hulled()
    rod(d=bow_width, h=shaft_diameter)
    align([1,0,0])
    rod(r=shaft_radius, h=3, anchor=[-1,0,0], orientation=x);
  translate([-bit_thickness / 2,0,0])
  rod(d=bow_width - bit_thickness, h=10, $class="cuts");
  }
}

module bit() {
  differed("cuts")
    // Bit body
    box([bit_length, bit_depth + $parent_size.x / 2, bit_thickness], anchor=[0,1,0])
    // Cuts
    union() {
      align([0,-1,0])
      box([cut_shallow_width,cut_depth,bit_thickness], anchor=-y, $class="cuts")
      align([0,1,0])
      box([cut_deep_width,cut_depth,bit_thickness], anchor=-y);
      align([0,0,1])
      translate([0,-ward_radius/2,-1])
      rod(r=ward_radius, h=bit_length, orientation=x, $class="cuts");
    }
}

module key() {
  rod(h=shaft_length, r=shaft_radius, orientation=x)
  align([-1,0,0])
  handle();
  translate([shaft_length / 2,0,0])
  align([1,0,0])
  ball(r=shaft_radius, anchor=[0,0,0])
  align([0,-1,0])
  translate([bit_distance_top,$parent_size.x / 2, bit_off_axis])
  bit();
}

// Assembly
key();

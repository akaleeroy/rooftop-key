include <relativity/relativity.scad>

$fn = 32;
pro = 0.02; // Protrusion value for CSG ops

// Shank or shaft
shaft_radius = 6 / 2;
shaft_length = 50;

// Handle or bow
bow_width = 18;
bow_height = 23;

bit_length = 8;
bit_depth = 12;
bit_thickness = 4;

// Cuts
cut_shallow_width = 4;
cut_deep_width = 1.4;
cut_depth = 2;

ward_radius = 2 / 2;
ward_depth = 1.5;
// Pozitie, de jos: 6, 2, 4
ward_pos_bottom = 6;

module handle() {
  // TODO Differed doesn't work
  difference() {
  hulled()
    rod(d=bow_width, h=bit_thickness)
    align([1,0,0])
    rod(r=shaft_radius, h=1, anchor=[-1,0,0], orientation=x);
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
      // Alternate positioning from bit bottom
      // align([0,-1,1])
      // translate([0,ward_radius*2 + ward_pos_bottom,-1])
      rod(r=ward_radius, h=bit_length, orientation=x, $class="cuts");
    }
}

module key() {
  rod(h=shaft_length, r=shaft_radius, orientation=x)
  align([-1,0,0])
  // resize([0,bow_height,0])
  handle();
  translate([shaft_length / 2,0,0])
  align([1,0,0])
  ball(r=shaft_radius, anchor=[0,0,0])
  align([0,-1,0])
  translate([-$parent_size.x - 1,$parent_size.x / 2,-0.4])
  bit();
}

// Assembly
key();

/******************************************************************************/
default_thickness = 2; // Thickness of the jig.
default_hole_diameter = 4;  // Size of hole to cut out of jig.

/******************************************************************************/
/*

  A single pole knob.

  Only requires that a single hole be cut out of the jig.

*/
module single_pole_knob(
  /* What size hole should be cut out of the jig? */
    hole_diameter = default_hole_diameter)
{
  height = 10;
  cylinder(d=hole_diameter, h=height, center=true);
}

/******************************************************************************/
/*

  A handle with two attachment points.

*/
module dual_pole_handle(
  /* Distance between the centers of the two poles. */
  pole_distance,

  /* What size hole should be cut out of the jig? */
  hole_diameter = default_hole_diameter)
{
  offset = pole_distance/2;

  for (i = [offset, -offset]) {
    translate([i, 0, 0])
      single_pole_knob(hole_diameter=hole_diameter);
  }
}

/******************************************************************************/
/*

  A jig for drilling holes in a cabinet door.

  Give the handle as a child object.
*/
module door_jig(
  /*
    How wide is the trim piece on the door?  The handle will be placed
    in the center of the trim.
  */
  width,

  /*
    How far from the bottom (or top) edge of the door to place the
    center of then handle?  If not given defaults to the `width'
    value.
  */
  handle_center,

  /*
    How thick do you want the jig to be?
  */
  thickness = default_thickness)
{
  height = handle_center == undef ? width * 2 : handle_center * 2;

  union() {
    difference() {
      // Plate.
      cube([width, height, thickness]);

      // Hole(s).
      translate([width/2, height/2, 0])
        rotate([0, 0, 90])
          children();
    }

    // Long edge.
    translate([-thickness, -thickness, 0])
      cube(size=[thickness, height+thickness, thickness*4]);

    // Short edge.
    translate([0, -thickness, 0])
      cube(size=[width, thickness, thickness*4]);
  }
}

/******************************************************************************/
/*

  A jig for drilling holes in a cabinet drawer.

  Give the handle as a child object.

*/
module drawer_jig(
  /*
    What is the height of the drawer?  The handle will be placed in
    the center of the drawer.  The jig will be slightly larger than
    half of this value.
  */
  height,

  /*
    How wide to make the jig.  A good value is the total width of the
    handle, maybe a little wider.
  */
  width,

  /*
    How thick do you want the jig to be?
  */
  thickness = default_thickness)
{
  edge_height = thickness * 4;

  jig_height = height / 2 + edge_height;
  jig_width = width;

  hole_x = jig_width / 2;
  hole_y = height / 2;

  difference() {
    union() {
      difference() {
        // Plate:
        cube([jig_width, jig_height, thickness]);

        // Holes:
        translate([hole_x, hole_y, 0])
          children();
      }

      // Edge:
      translate([0, -thickness, 0])
        cube([jig_width, thickness, edge_height]);
    }

    // Cut out to mark the center of the jig:
    translate([hole_x, 0, edge_height/2])
      cube(
        size=[thickness, edge_height, edge_height],
        center=true);
  }
}

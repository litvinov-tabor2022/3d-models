// ******
//DEBUG = true;
DEBUG = false;

board_size = [59.9, 39.4, 2];
board_col_height = 5.6;

header_size = [7.9, 10.6, 5];
header_pos = [19.1, board_size.z];

header2_size = [14.5, 14.85, 6.75];
header3_size = [2.5, 10.4, 5];

shaft_length_diff = 5.4;
rails_offset = 33.2;

hold_len = 10;

function MFRC_board_size() = board_size;

// ---------------------------------------------

fatness = 1.4;
fatness_inner = .8;
inset = .2;

shaft_inset = .4;

round_prec = 40;

// ---------------------------------------------

inner_box = [board_size.x + 2 * inset, board_size.y + 2 * inset, board_size.z + header_size.z + 2 * inset];
box = [inner_box.x + 2 * fatness_inner, inner_box.y + 2 * fatness_inner, inner_box.z + fatness_inner];


cover_size_inner = [box.x + inset, box.y + inset, box.z + inset];
cover_size_outter = [cover_size_inner.x + 2 * fatness_inner, cover_size_inner.y + 2 * fatness_inner, cover_size_inner.z + fatness_inner];

shaft_size_inner = [
        cover_size_outter.x + shaft_length_diff,
        cover_size_outter.y + 2 * shaft_inset,
        cover_size_outter.z + shaft_inset + .5
    ];

shaft_size_outter = [
    shaft_size_inner.x, shaft_size_inner.y + 2 * fatness + 2 * (1 + shaft_inset), shaft_size_inner.z + 2 * fatness
    ];

cs_size = [header2_size.x + header3_size.x + 4, shaft_size_outter.y, shaft_size_outter.z];

echo("MFRC shatf size outter:", shaft_size_outter);

header_hole_size = [header_size.x + .4, header_size.y + .4, 100];

holds_dia = 6;

function MFRC_holds_dia() = holds_dia;
// ******

function Shaft_size_outter() = [shaft_size_outter.x + cs_size.x, shaft_size_outter.y, shaft_size_outter.z];

module MFRC_board() {
    union() {
        color("black") cube(board_size);
        color("grey") translate([- header_size.x, board_size.y - header_pos.x - header_size.y, header_pos.y]) cube(header_size);
        col_size = [9.9, 4.5, board_col_height - board_size.z];
        col_pos = [1.5, 1];
        color("blue") translate([col_pos.x, board_size.y - col_size.y - col_pos.x, board_size.z]) cube(col_size);
    }
}

module MFRC_inner(x, y, z) {
    union() {
        difference() {
            color("blue") union() {
                difference() {
                    cube([box.x, box.y, box.z]);
                    translate([fatness_inner, fatness_inner, fatness_inner]) {
                        cube([inner_box.x, inner_box.y, box.z]);
                    }
                }
            }

            translate([- .01, fatness_inner + board_size.y - header_pos.x - header_hole_size.y + .4, fatness_inner + header_pos.y - .2]) {
                cube(header_hole_size);
            }

            // if (DEBUG) translate([- .01, fatness, fatness]) cube([fatness + .02, box.y - 2 * fatness, 100]);
        }

        if (DEBUG) translate([fatness_inner + inset, fatness_inner + inset, fatness_inner]) MFRC_board();
    }
}

module MFRC_cover() {
    union() {
        difference() {
            union() {
                difference() {
                    cube(cover_size_outter);
                    translate([fatness_inner, fatness_inner, fatness_inner]) {
                        cube([cover_size_inner.x, cover_size_inner.y, 100]);
                    }
                }
            }

            translate([- .01, 2 * fatness_inner + header_pos.x + inset / 2, fatness_inner + .3]) {
                cube(header_hole_size);
            }

            if (DEBUG) translate([- .01, fatness_inner, fatness_inner]) cube([fatness_inner + .02, cover_size_inner.y, 100]);
            if (DEBUG) translate([fatness_inner, fatness_inner, - .1]) cube([cover_size_inner.x, cover_size_inner.y, 100]);
        }

        // cols/supports
        supp_size = [3, 3, cover_size_outter.z - 2 * fatness_inner - board_size.z - .1];
        translate([15, (cover_size_inner.y - supp_size.y) / 2, fatness_inner - .01]) cube(supp_size);
        translate([40, (cover_size_inner.y - supp_size.y) / 2, fatness_inner - .01]) cube(supp_size);

        translate([rails_offset + .5, - 1.5, 0]) cube([20, 1.5 + .01, 1]);
        translate([rails_offset + .5, cover_size_outter.y, 0]) cube([20, 1.5 + .01, 1]);

        // holds
        difference() {
            union() {
                h = 3.2;

                for (i = [0:1]) {
                    translate([cover_size_outter.x, i * (cover_size_outter.y + h), cover_size_outter.z / 2]) rotate([90])
                        cylinder(h = h, d = holds_dia, $fn = round_prec);
                }
            }

            translate([cover_size_outter.x, - 5 - .01]) cube([100, cover_size_outter.y + 10 + .02, 100]);
        }
    }
}

module MFRC_shaft() {
    translate([cs_size.x, 0]) union() {
        difference() {
            union() {
                color("green") difference() {
                    cube(shaft_size_outter);
                    translate([fatness, fatness + (1 + shaft_inset), fatness - .01]) {
                        cube([shaft_size_inner.x + .02, shaft_size_inner.y, shaft_size_inner.z]);
                    }
                }
            }

            translate([- .1, fatness + (1 + shaft_inset), fatness]) {
                cube([fatness + .2, shaft_size_inner.y + 0 * (1 + shaft_inset), shaft_size_inner.z - .01]);
            }

            // rails
            rails_x = rails_offset + shaft_length_diff;
            rails_z = shaft_size_outter.z - fatness - (1 + shaft_inset) - .01;

            translate([rails_x, fatness, rails_z])
                cube([shaft_size_inner.x, (1 + shaft_inset) + .01, 1 + shaft_inset]);
            translate([rails_x, shaft_size_outter.y - fatness - (1 + shaft_inset) - .01, rails_z])
                cube([shaft_size_inner.x, (1 + shaft_inset) + .01, 1 + shaft_inset]);

            // holes for hold

            translate([shaft_size_outter.x, 5 - .01, shaft_size_outter.z / 2]) rotate([90])
                cylinder(h = 5, d = holds_dia + .3, $fn = round_prec);
            translate([shaft_size_outter.x, shaft_size_outter.y + .01, shaft_size_outter.z / 2]) rotate([90])
                cylinder(h = 5, d = holds_dia + .3, $fn = round_prec);

//            if (DEBUG) translate([0, fatness, shaft_size_outter.z - fatness - .1])
//                cube([shaft_size_inner.x + fatness, shaft_size_inner.y + 2 * (1 + shaft_inset), fatness + .2]);
        }

        // conector shaft
        translate([- cs_size.x + .01, 0, 0]) union() {

            header_hole_offset = 14.57;

            difference() {
                cube(cs_size);
                translate([fatness, fatness, fatness]) {
                    cube([cs_size.x - fatness - 0.8, cs_size.y - 2 * fatness, cs_size.z]);
                }


                translate([cs_size.x - fatness_inner - .01, header_hole_offset, 2]) {
                    cube([1, header_hole_size.y, header_hole_size.z + 2.6]);
                }

                if (DEBUG) {
                    translate([- .01, fatness, fatness]) cube([fatness + .02, shaft_size_inner.y + 2 * 1.5, shaft_size_inner.z]);
                }
            }

            // header
            translate([cs_size.x - header2_size.x - header3_size.x - fatness_inner,
                    header_hole_offset + (header_hole_size.y - header2_size.y) / 2,
                fatness]) {
                if (DEBUG) translate([0, 0, 1.5]) {
                    color("black") cube(header2_size);
                    color("red") translate([header2_size.x, (header2_size.y - header3_size.y) / 2, 1.5]) cube(header3_size);
                }

                difference() {
                    w = 4;
                    w2 = header3_size.y + .4;
                    h = 6.3;
                    translate([- 3, - 3, - .01]) difference() {
                        size = [3 + header2_size.x + 2, 2 * 3 + header2_size.y, h];
                        cube(size);
                        translate([- .01, 3 + w, - .01]) cube([3 + .02, header2_size.y - 2 * w, 100]);
                        translate([- .01, (size.y - w2) / 2, - .01]) cube([100, w2, 100]);
                    }
                    translate([0, 0, 1.45]) cube([header2_size.x + .02, header2_size.y + .02, 100]);
                    translate([1, 1]) cube([header2_size.x - 2, header2_size.y - 2, 100]);
                    translate([1, (header2_size.y - 8) / 2]) cube([100, 8, 100]);
                }
            }
        }

        if (DEBUG) translate([7.2, 5.08, 2.4]) MFRC_board();
    }
}

// ---------------------------------------------

module MFRC_all() {
    MFRC_shaft();

    translate([27.2, 4.08, 1.6]) {
        MFRC_inner();

        translate([- fatness_inner - inset / 2, - 17.68, box.z + fatness_inner + inset]) rotate([180])
            translate([0, - 60]) MFRC_cover();

    }
}

difference() {
    MFRC_all();
//  translate([50, - .01, - .01]) cube([100, 100, 100]);
}

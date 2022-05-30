function switch_hole_dia() = 12.7;
function switch_inner_height() = 17.65;

function button_size() = [12, 3.85, 12];
function button_hole_dia() = 11.8;
function button_total_height() = 12.3;
function button_top_height() = 4.3;

contacts_length = 5.2;

module Button() {
    union() {
        color("gray") translate([0, button_total_height() - button_size().y]) cube(button_size());
        color("blue") translate([button_size().x / 2, + button_top_height(), button_size().z / 2]) rotate([90])
            cylinder(d = button_hole_dia() - .3, h = button_top_height(), $fn = 30);
        s = 6;
        color("gray") translate([(button_size().x - s) / 2, button_top_height(), (button_size().z - s) / 2]) cube([s, 5, s]);

    }
}

module Switch(fatness) {
    color("black") translate([-1, - (switch_hole_dia() - 6.6) / 2, - contacts_length]) cube([2, 6.6, contacts_length]);
    color("black") translate([0, 0, switch_inner_height() - fatness - 4.6]) cylinder(d = 16.35, h = 4.6, $fn = 30);
    color("black") cylinder(d = switch_hole_dia() - .3, h = switch_inner_height(), $fn = 30);
    color("black") translate([0, 0, switch_inner_height()]) cylinder(d = 14.3, h = 2.2, $fn = 30);
    color("red") translate([0, 0, switch_inner_height() + 2.2]) cylinder(d = 9, h = 4.15, $fn = 30);
}

charger_size = [17.4, 1, 27.9];

function Charger_size() = charger_size;

module Charger() {
    union() {
        color("black") cube([charger_size.x, charger_size.y, charger_size.z]);
        color("black") translate([0, charger_size.y - 1, 0])cube([charger_size.x, 1, 1]);
        usb_size = [9.2, 3.4, 7.7];
        color("red") translate([3.7, - usb_size.y, charger_size.z - usb_size.z + 1]) cube(usb_size);

        color("gray") rotate([90]) translate([0, 10]) text("Chrgr", size = 5);
    }
}

package mov

import "core:os"
import "core:fmt"
import "core:reflect"
import "core:strings"

MOV: u8 : 0b10001000

Register :: enum(u8) {
	CL_CX = 0b001,
	DL_DX = 0b010,
	BL_BX = 0b011,
	AH_SP = 0b100,
	CH_BP = 0b101,
	DH_SI = 0b110,
	BH_DI = 0b111,
}

OPS :: []u8{ MOV }

main :: proc() {
	bytes, ok := os.read_entire_file("listing_0037_single_register_mov")
	assert(ok)

	fmt.println("bits 16\n")

	op: u8 = 0
	for x in OPS {
		if bytes[0] & x == x {
			op = x
			break
		}
	}

	switch op {
	case MOV:
		dval := bytes[0] & 0b00000010
		wval := bytes[0] & 0b00000001

		modval := bytes[1] & 0b11000000
		regval := bytes[1] & 0b00111000
		rmval  := bytes[1] & 0b00000111

		reg := Register(regval >> 3)
		reg_str := strings.to_lower(reflect.enum_string(reg))
		reg_split := strings.split(reg_str, "_")

		rm := Register(rmval)
		rm_str := strings.to_lower(reflect.enum_string(rm))
		rm_split := strings.split(rm_str, "_")

		if wval == 0 {
			fmt.printf("mov %s, %s\n", rm_split[0], reg_split[0])
		} else {
			fmt.printf("mov %s, %s\n", rm_split[1], reg_split[1])
		}
	}
}
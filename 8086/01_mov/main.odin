package main

import "core:os"
import "core:fmt"
import "core:bytes"
import "core:reflect"
import "core:strings"

Register :: enum(u8) {
	AL_AX = 0b000,
	CL_CX = 0b001,
	DL_DX = 0b010,
	BL_BX = 0b011,
	AH_SP = 0b100,
	CH_BP = 0b101,
	DH_SI = 0b110,
	BH_DI = 0b111,
}

Ops :: enum(u8) {
	Mov = 0b10001000,
}

main :: proc() {
	path := os.args[1]
	data, ok := os.read_entire_file(path)
	assert(ok)

	fmt.println("bits 16")

	for i := 0; i < len(data); i += 2 {
		switch {
		case (data[i] & u8(Ops.Mov)) == u8(Ops.Mov):
			dval      := data[i + 0] & 0b00000010
			wval      := data[i + 0] & 0b00000001
			modval    := data[i + 1] & 0b11000000
			regval    := data[i + 1] & 0b00111000
			rmval     := data[i + 1] & 0b00000111
			reg       := Register(regval >> 3)
			reg_str   := strings.to_lower(reflect.enum_string(reg))
			reg_split := strings.split(reg_str, "_")
			rm        := Register(rmval)
			rm_str    := strings.to_lower(reflect.enum_string(rm))
			rm_split  := strings.split(rm_str, "_")
			if 0 == wval {
				fmt.printf("mov %s, %s\n", rm_split[0], reg_split[0])
			} else {
				fmt.printf("mov %s, %s\n", rm_split[1], reg_split[1])
			}
		}
	}
}
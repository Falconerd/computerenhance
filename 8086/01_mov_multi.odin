package mov_multi

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

Op :: enum(u8) {
	Mov = 0b10001000,
}

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  sys_defs.vh                 11.3 version                         //
//                                                                     //
//  Description :  This file has the macro-defines for macros used in  //
//                 the pipeline design.                                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

// -------------------------------------------------------------------ROB-------------------------------------------------
`define N_way 4		//change N_way_div_2_round_up at the same time
`define N_way_div_2_round_up 2
`define N_LEN 2//$clog2(`N_way)
`define Areg_num 32
`define Preg_num 64
`define ROB_size `Preg_num-`Areg_num
`define Areg_LEN 5  // $clog2(`Areg_num)
`define Preg_LEN 6  // $clog2(`Preg_num)
`define ROB_LEN 5 //$clog2(`ROB_size)
`define XLEN 32
`define FU_num `ALU_num + `MUL_num
`define FU_LEN 3//$clog2(`FU_num)


`define Freelist_size `Preg_num-`Areg_num
`define Freelist_LEN 5//$clog2(`Freelist_size)

`define SQ_size 8
`define SQ_LEN 3
//RS-----------------------------------------------------------------------------------
`define b_mask_reg_width  4
`define width_b_mask    4
`define width_b_mask_len 2 //$clog2(`width_b_mask)
`define ALU_num 4
`define MUL_num 2
`define RS_depth 8

//IB----------------------------------------------------------------------------------------------
`define MUL_IB_Detpth 8
`define ALU_IB_Detpth 8
`define LOAD_IB_Depth 8
`define STORE_IB_Depth 8
//BP--------------------------------------------------------------------------------------------
`define BTB_depth 32				//inst [9:2] 
`define BHT_depth 32              //xiashede 
`define BHT_width 2             
`define PHT_depth 2**`BHT_width	

//Cache-----------------------------------------------------------------------------------------
`define CACHE_Assoc 2   
`define CACHE_SIZE 256     // The capacity of cache in bytes.
`define CACHE_BLOCK_SIZE    8       // The number of bytes in a block
`define Cache_depth		`CACHE_SIZE/`CACHE_Assoc/`CACHE_BLOCK_SIZE //16
`define Cache_Index		$clog2(`CACHE_SIZE/`CACHE_Assoc/`CACHE_BLOCK_SIZE)
`define block_offset_bit $clog2(`CACHE_BLOCK_SIZE/1)  // 1 indicates 1 byte,byte addresseble
`define lsb_Cache_tag	(`block_offset_bit+`Cache_Index)
`define MSHR_Depth     8    // The number of entries in the MSHR.

//Prefetch ICache-----------------------------------------------------------------------------------------
`define STRIDE 3
`define I_MSHR_Depth 8
`define I_MSHR_LEN 3

`ifndef __SYS_DEFS_VH__
`define __SYS_DEFS_VH__


/* Synthesis testing definition, used in DUT module instantiation */

`ifdef  SYNTH_TEST
`define DUT(mod) mod``_svsim
`else
`define DUT(mod) mod
`endif


//////////////////////////////////////////////
//
// Memory/testbench attribute definitions
//
//////////////////////////////////////////////
`define CACHE_MODE //removes the byte-level interface from the memory mode, DO NOT MODIFY!
`define NUM_MEM_TAGS           15

`define MEM_SIZE_IN_BYTES      (64*1024)
`define MEM_64BIT_LINES        (`MEM_SIZE_IN_BYTES/8)

//you can change the clock period to whatever, 10 is just fine
`define VERILOG_CLOCK_PERIOD   20.8
`define SYNTH_CLOCK_PERIOD     20.8 // Clock period for synth and memory latency

`define MEM_LATENCY_IN_CYCLES (100.0/`SYNTH_CLOCK_PERIOD+0.49999)
// the 0.49999 is to force ceiling(100/period).  The default behavior for
// float to integer conversion is rounding to nearest

typedef union packed {
    logic [7:0][7:0] byte_level;
    logic [3:0][15:0] half_level;
    logic [1:0][31:0] word_level;
} EXAMPLE_CACHE_BLOCK;

//////////////////////////////////////////////
// Exception codes
// This mostly follows the RISC-V Privileged spec
// except a few add-ons for our infrastructure
// The majority of them won't be used, but it's
// good to know what they are
//////////////////////////////////////////////

typedef enum logic [3:0] {
	INST_ADDR_MISALIGN  = 4'h0,
	INST_ACCESS_FAULT   = 4'h1,
	ILLEGAL_INST        = 4'h2,
	BREAKPOINT          = 4'h3,
	LOAD_ADDR_MISALIGN  = 4'h4,
	LOAD_ACCESS_FAULT   = 4'h5,
	STORE_ADDR_MISALIGN = 4'h6,
	STORE_ACCESS_FAULT  = 4'h7,
	ECALL_U_MODE        = 4'h8,
	ECALL_S_MODE        = 4'h9,
	NO_ERROR            = 4'ha, //a reserved code that we modified for our purpose
	ECALL_M_MODE        = 4'hb,
	INST_PAGE_FAULT     = 4'hc,
	LOAD_PAGE_FAULT     = 4'hd,
	HALTED_ON_WFI       = 4'he, //another reserved code that we used
	STORE_PAGE_FAULT    = 4'hf
} EXCEPTION_CODE;


//////////////////////////////////////////////
//
// Datapath control signals
//
//////////////////////////////////////////////

//
// ALU opA input mux selects
//
typedef enum logic [1:0] {
	OPA_IS_RS1  = 2'h0,
	OPA_IS_NPC  = 2'h1,
	OPA_IS_PC   = 2'h2,
	OPA_IS_ZERO = 2'h3
} ALU_OPA_SELECT;

//
// ALU opB input mux selects
//
typedef enum logic [3:0] {
	OPB_IS_RS2    = 4'h0,
	OPB_IS_I_IMM  = 4'h1,
	OPB_IS_S_IMM  = 4'h2,
	OPB_IS_B_IMM  = 4'h3,
	OPB_IS_U_IMM  = 4'h4,
	OPB_IS_J_IMM  = 4'h5
} ALU_OPB_SELECT;

//
// Destination register select
//
typedef enum logic [1:0] {
	DEST_RD = 2'h0,
	DEST_NONE  = 2'h1
} DEST_REG_SEL;

//
// ALU function code input
// probably want to leave these alone
//
typedef enum logic [4:0] {
	ALU_ADD     = 5'h00,
	ALU_SUB     = 5'h01,
	ALU_SLT     = 5'h02,
	ALU_SLTU    = 5'h03,
	ALU_AND     = 5'h04,
	ALU_OR      = 5'h05,
	ALU_XOR     = 5'h06,
	ALU_SLL     = 5'h07,
	ALU_SRL     = 5'h08,
	ALU_SRA     = 5'h09,
	ALU_MUL     = 5'h0a,
	ALU_MULH    = 5'h0b,
	ALU_MULHSU  = 5'h0c,
	ALU_MULHU   = 5'h0d,
	ALU_DIV     = 5'h0e,
	ALU_DIVU    = 5'h0f,
	ALU_REM     = 5'h10,
	ALU_REMU    = 5'h11
} ALU_FUNC;

//////////////////////////////////////////////
//
// Assorted things it is not wise to change
//
//////////////////////////////////////////////

//
// actually, you might have to change this if you change VERILOG_CLOCK_PERIOD
// JK you don't ^^^
//
`define SD #1


// the RISCV register file zero register, any read of this register always
// returns a zero value, and any write to this register is thrown away
//
`define ZERO_REG 5'd0

//
// Memory bus commands control signals
//
typedef enum logic [1:0] {
	BUS_NONE     = 2'h0,
	BUS_LOAD     = 2'h1,
	BUS_STORE    = 2'h2
} BUS_COMMAND;

//`ifndef CACHE_MODE
typedef enum logic [1:0] {
	BYTE = 2'h0,
	HALF = 2'h1,
	WORD = 2'h2,
	DOUBLE = 2'h3
} MEM_SIZE;
// `endif
//
// useful boolean single-bit definitions
//
`define FALSE  1'h0
`define TRUE  1'h1

// RISCV ISA SPEC
// `define XLEN 32
typedef union packed {
	logic [31:0] inst;
	struct packed {
		logic [6:0] funct7;
		logic [4:0] rs2;
		logic [4:0] rs1;
		logic [2:0] funct3;
		logic [4:0] rd;
		logic [6:0] opcode;
	} r; //register to register instructions
	struct packed {
		logic [11:0] imm;
		logic [4:0]  rs1; //base
		logic [2:0]  funct3;
		logic [4:0]  rd;  //dest
		logic [6:0]  opcode;
	} i; //immediate or load instructions
	struct packed {
		logic [6:0] off; //offset[11:5] for calculating address
		logic [4:0] rs2; //source
		logic [4:0] rs1; //base
		logic [2:0] funct3;
		logic [4:0] set; //offset[4:0] for calculating address
		logic [6:0] opcode;
	} s; //store instructions
	struct packed {
		logic       of; //offset[12]
		logic [5:0] s;   //offset[10:5]
		logic [4:0] rs2;//source 2
		logic [4:0] rs1;//source 1
		logic [2:0] funct3;
		logic [3:0] et; //offset[4:1]
		logic       f;  //offset[11]
		logic [6:0] opcode;
	} b; //branch instructions
	struct packed {
		logic [19:0] imm;
		logic [4:0]  rd;
		logic [6:0]  opcode;
	} u; //upper immediate instructions
	struct packed {
		logic       of; //offset[20]
		logic [9:0] et; //offset[10:1]
		logic       s;  //offset[11]
		logic [7:0] f;	//offset[19:12]
		logic [4:0] rd; //dest
		logic [6:0] opcode;
	} j;  //jump instructions
`ifdef ATOMIC_EXT
	struct packed {
		logic [4:0] funct5;
		logic       aq;
		logic       rl;
		logic [4:0] rs2;
		logic [4:0] rs1;
		logic [2:0] funct3;
		logic [4:0] rd;
		logic [6:0] opcode;
	} a; //atomic instructions
`endif
`ifdef SYSTEM_EXT
	struct packed {
		logic [11:0] csr;
		logic [4:0]  rs1;
		logic [2:0]  funct3;
		logic [4:0]  rd;
		logic [6:0]  opcode;
	} sys; //system call instructions
`endif

} INST; //instruction typedef, this should cover all types of instructions

//
// Basic NOP instruction.  Allows pipline registers to clearly be reset with
// an instruction that does nothing instead of Zero which is really an ADDI x0, x0, 0
//
`define NOP 32'h00000013

//////////////////////////////////////////////
//
// IF Packets:
// Data that is exchanged between the IF and the ID stages  
//
//////////////////////////////////////////////

typedef struct packed {
	logic valid; // If low, the data in this struct is garbage
    INST  inst;  // fetched instruction out
	logic [`XLEN-1:0] NPC; // PC + 4
	logic [`XLEN-1:0] PC;  // PC 
    logic BP_predicted_taken;
	logic [`XLEN-1:0]BP_predicted_target_PC;
} IF_ID_PACKET;

//////////////////////////////////////////////
//
// ID Packets:
// Data that is exchanged from ID to EX stage
//
//////////////////////////////////////////////

typedef struct packed {
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC

	logic [`XLEN-1:0] rs1_value;    // reg A value                                  
	logic [`XLEN-1:0] rs2_value;    // reg B value                                  
	                                                                                
	ALU_OPA_SELECT opa_select; // ALU opa mux select (ALU_OPA_xxx *)
	ALU_OPB_SELECT opb_select; // ALU opb mux select (ALU_OPB_xxx *)
	INST inst;                 // instruction
	
	logic [4:0] dest_reg_idx;  // destination (writeback) register index      
	ALU_FUNC    alu_func;      // ALU function select (ALU_xxx *)
	logic       rd_mem;        // does inst read memory?
	logic       wr_mem;        // does inst write memory?
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
} ID_EX_PACKET;


typedef struct packed {

	logic [`Areg_LEN-1:0]Rs1_Areg;    // From Dispatch depth N-way
	logic [`Areg_LEN-1:0]Rs2_Areg;	// From Dispatch
	logic [`Areg_LEN-1:0]Rd_Areg;		// From Dispatch

	logic [`Preg_LEN-1:0]Rd_Preg;		// From Free List

	logic Dispatch_enable;

	logic [`Preg_LEN-1:0]Set_ready_bit;   //From CDB
	logic Set_ready_bit_enable;			//From CDB

		// Updated on 10.28
	logic is_branch;	// From Dispatch
} RAT_IN_PACKET;

typedef struct packed {
	logic [`Areg_num-1:0][`Preg_LEN-1:0]Preg;
	logic [`Areg_num-1:0]ready_bit;
}RAT_PACKET;

typedef struct packed {

	logic [`Preg_LEN-1:0]Rd_old_Preg_ROB;		// To ROB
	logic [`Preg_LEN-1:0]Rs1_Preg_RS;		// To RS
	logic [`Preg_LEN-1:0]Rs2_Preg_RS;    // input  [`XLEN-1:0] mem_wb_NPC,            // incoming instruction PC+4
	logic Rs1_Preg_ready_RS;		// To RS
	logic Rs2_Preg_ready_RS;		// To RS

} RAT_OUT_PACKET;
// -------------------------------------------------------------------RAT end-------------------------------------------------

//----------------------------------------------------RRAT--------------------------------------------------------------------
typedef struct packed {

	logic [`Preg_LEN-1:0]Rd_old_Preg_ROB; 	// T_old from ROB
    logic [`Preg_LEN-1:0]Rd_Preg_ROB;	    // T from ROB
	logic Retire_enable;                    // retire signal

} RRAT_IN_PACKET;

typedef struct packed {
	logic [`Preg_LEN-1:0]Preg;
	logic ready_bit;
}RRAT_PACKET;

// -------------------------------------------------RRAT end------------------------------------------------------------------
// -------------------------------------------------------------------Freelist end-------------------------------------------------

typedef struct packed {

	logic Retire_enable;	// From ROB
	logic [`Preg_LEN-1:0]Rd_old_Preg_ROB;	// From ROB
	logic Dispatch_enable;
	logic Dispatch_Rd_available;
	logic [`Areg_LEN-1:0]Rd_Areg;

	logic is_branch; // From Dispatch
} Freelist_IN_PACKET;

typedef struct packed{
	logic [`Preg_LEN-1:0] Preg;
} Freelist_PACKET;

typedef struct packed {

	logic [`Preg_LEN-1:0]Rd_Preg_out; // To RAT, ROB, RS

} Freelist_OUT_PACKET;

// -------------------------------------------------------------------Freelist end-------------------------------------------------


// -------------------------------------------------------------------Complete-------------------------------------------------


typedef struct packed {
	logic [`Preg_LEN-1:0]Rd_Preg_Complete;	// To physical register file, CDB
	logic [`XLEN-1:0]Rd_value_Pregfile; //to physical register file
} Complete_Preg_OUT_PACKET;

// -------------------------------------------------------------------Complete end-------------------------------------------------
// -------------------------------------------------------------------ROB-------------------------------------------------

typedef struct packed {
	INST inst;
	logic [`Preg_LEN-1:0]Rd_old_Preg_RAT; //From RAT
	logic [`Preg_LEN-1:0]Rd_Preg_Freelist;  //From Freelist
	logic Dispatch_enable;
	logic [`Areg_LEN-1:0]Rd_Areg;

	logic [`Preg_LEN-1:0]Rd_Preg_CDB;   //From CDB
	logic Rd_Preg_CDB_valid;
	logic [`ROB_LEN:0]ROB_tail;
	logic [`XLEN-1:0]Rd_Preg_value;

	logic is_branch;
	logic rd_mem;
	logic wr_mem;
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC
} ROB_IN_PACKET;

typedef struct packed {
	INST inst;
	logic [`Preg_LEN-1:0]Preg;
	logic Preg_ready_bit;
	logic [`Preg_LEN-1:0]Preg_old;
	logic [`Areg_LEN-1:0]Rd_Areg;
	logic [`XLEN-1:0]Rd_Preg_value;

	logic is_branch;
	logic rd_mem;
	logic wr_mem;
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC
}ROB_PACKET;


typedef struct packed {


	logic [`ROB_LEN:0] branch_tail; //To Branch prediction checkpoint 
	logic branch_tail_valid;

	logic rd_mem;
	logic wr_mem;
	logic [`ROB_LEN:0] store_tail;
	logic [`ROB_LEN:0] load_tail;
	logic [`ROB_LEN:0] ROB_tail;
	
	logic [`Preg_LEN-1:0]Rd_old_Preg_RRAT; //To RRAT and freelist
	logic [`Preg_LEN-1:0]Rd_Preg_RRAT;  //To RRAT
	logic Retire_enable;  //To RRAT and freelist
	logic [`XLEN-1:0]Rd_Preg_value;
	logic [`Areg_LEN-1:0]Rd_Areg;
	// logic [`XLEN-1:0] NPC;   // PC + 4

} ROB_OUT_PACKET;

typedef struct packed{
	INST inst;
	logic [`Preg_LEN-1:0]Preg;
	logic Preg_ready_bit;
	logic [`Preg_LEN-1:0]Preg_old;
	logic [`XLEN-1:0]Rd_Preg_value;
	logic [`Areg_LEN-1:0]Rd_Areg;

	logic is_branch;
	logic rd_mem;
	logic wr_mem;
	logic [`ROB_LEN:0]ROB_pointer;
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC

	logic Retire_enable;
} ROB_RETIRE_PACKET;

// -------------------------------------------------------------------ROB end-------------------------------------------------

// -------------------------------------------------------------------connected_ROB-------------------------------------------------

typedef struct packed {
	logic Dispatch_enable;
	logic Dispatch_Rd_available;
	logic [`Areg_LEN-1:0]Rs1_Areg;
	logic [`Areg_LEN-1:0]Rs2_Areg;
	logic [`Areg_LEN-1:0]Rd_Areg;
	INST inst;
	logic rd_mem;
	logic wr_mem;

		// Updated on 10.28
	logic is_branch;

	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC

}Dispatch_TO_ConnectedROB_PACKET;


typedef struct packed {
	logic [`Preg_LEN-1:0]Rs1_Preg_RS;
	logic [`Preg_LEN-1:0]Rs2_Preg_RS;
	logic Rs1_Preg_ready_RS;
	logic Rs2_Preg_ready_RS;
	logic [`Preg_LEN-1:0]Rd_Preg_out_Freelist;
}ConnectedROB_TO_RS_PACKET;

// -------------------------------------------------------------------connected_ROB end-------------------------------------------------


typedef struct packed {
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC
	//logic [`XLEN-1:0] rs1_value;    // reg A value                                  
	//logic [`XLEN-1:0] rs2_value;    // reg B value                                  
	                                                                                
	ALU_OPA_SELECT opa_select; // ALU opa mux select (ALU_OPA_xxx *)
	ALU_OPB_SELECT opb_select; // ALU opb mux select (ALU_OPB_xxx *)
	INST inst;                 // instruction
	
	//logic [4:0] dest_reg_idx;  // destination (writeback) register index      
	ALU_FUNC    alu_func;      // ALU function select (ALU_xxx *)
	logic       rd_mem;        // does inst read memory?
	logic       wr_mem;        // does inst write memory?
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic        if_mul;
	// logic [`b_mask_reg_width-1:0] b_mask_in;   
	logic is_branch;     //if it is mul inst
	// logic [$clog2(`width_b_mask)-1:0] b_mask_bit_branch;
	logic BP_predicted_taken;
	logic [`XLEN-1:0]BP_predicted_target_PC;
	logic load_issue_valid;
} DP_BRAT_PACKET;

typedef struct packed {
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC                                 
	                                                                                
	ALU_OPA_SELECT opa_select; // ALU opa mux select (ALU_OPA_xxx *)
	ALU_OPB_SELECT opb_select; // ALU opb mux select (ALU_OPB_xxx *)
	INST inst;                 // instruction
	    
	ALU_FUNC    alu_func;      // ALU function select (ALU_xxx *)
	logic       rd_mem;        // does inst read memory?
	logic       wr_mem;        // does inst write memory?
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic        if_mul;
	logic [`b_mask_reg_width-1:0] b_mask_in;   
	logic is_branch;     //if it is mul inst
	logic [$clog2(`width_b_mask)-1:0] b_mask_bit_branch;
	logic BP_predicted_taken;
	logic [`XLEN-1:0]BP_predicted_target_PC;
	logic load_issue_valid;
} BRAT_RS_PACKET;


typedef struct packed {
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC

	logic [$clog2(`Preg_num)-1:0] prs1_idx;   // preg A value from physical register file                                 
	logic [$clog2(`Preg_num)-1:0] prs2_idx;    // preg B value                                  
	                                                                                
	ALU_OPA_SELECT opa_select; // ALU opa mux select (ALU_OPA_xxx *)
	ALU_OPB_SELECT opb_select; // ALU opb mux select (ALU_OPB_xxx *)
	INST inst;                 // instruction
	
	logic [$clog2(`Preg_num)-1:0] p_dest_reg_idx;  // destination (writeback) register index      
	ALU_FUNC    alu_func;      // ALU function select (ALU_xxx *)
	logic       rd_mem;        // does inst read memory?
	logic       wr_mem;        // does inst write memory?
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;
	logic        if_mul;         // is inst a valid instruction to be counted for CPI calculations?
	logic [`b_mask_reg_width-1:0] is_b_mask;
	logic is_branch; 
	logic [$clog2(`width_b_mask)-1:0] b_mask_bit_branch;
	logic BP_predicted_taken;
	logic [`XLEN-1:0]BP_predicted_target_PC;

	//just change packet, haven't updated codes
	logic [`SQ_LEN:0]SQ_tail;
	logic [`ROB_LEN:0]ROB_tail;
	logic load_issue_valid;
	logic no_sort_sq;
} RS_IS_PACKET;

typedef struct packed {
	logic	[`XLEN-1:0] rs_NPC;   // PC + 4
	logic	[`XLEN-1:0] rs_PC;    // PC
	ALU_OPA_SELECT	 rs_opa_select; // ALU opa mux select (ALU_OPA_xxx *)
	ALU_OPB_SELECT rs_opb_select; // ALU opb mux select (ALU_OPB_xxx *)
	INST 		rs_inst;                 // instruction    
	ALU_FUNC     rs_alu_func;      // ALU function select (ALU_xxx *)
	logic       rs_rd_mem;        // does inst read memory?
	logic      rs_wr_mem;        // does inst write memory?
	logic       rs_cond_branch;   // is inst a conditional branch?
	logic       rs_uncond_branch; // is inst an unconditional branch?
	logic      rs_halt;          // is this a halt?
	logic       rs_illegal;       // is this instruction illegal?
	logic       rs_csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       rs_valid;         // is inst a valid instruction to be counted for CPI calculations?

	logic  busy_rs;
	logic [$clog2(`Preg_num)-1:0] p_rd;  //tag rd
	logic [$clog2(`Preg_num)-1:0] preg1,preg2;
	logic  preg1_ready,preg2_ready;
	logic [`b_mask_reg_width-1:0] rs_b_mask;
    logic        if_mul;
	logic is_branch; 
	logic [$clog2(`width_b_mask)-1:0] b_mask_bit_branch;
	logic BP_predicted_taken;
	logic [`XLEN-1:0]BP_predicted_target_PC;

	//just change packet, haven't updated codes
	logic [`SQ_LEN:0]SQ_tail;
	logic [`ROB_LEN:0]ROB_tail;
	logic load_issue_valid;
	logic no_sort_sq;
} RS_PACKET;


typedef struct packed {
	INST 		inst;                 // instruction    
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic  busy;
	logic [`Preg_LEN-1:0] p_rd;  //tag rd
	logic [`Preg_LEN-1:0] preg1,preg2;
	logic  preg1_ready,preg2_ready;
	logic [`SQ_LEN:0]SQ_tail;
} rs_table;

//----------------------------------------------------EX_COM--------------------------------------------------------------------
typedef struct packed {
	logic [`XLEN-1:0] alu_result;  // result from alu
	logic [`XLEN-1:0] NPC; //pc + 4
	logic             take_branch; // is this a taken branch?
	INST inst;
	//pass throughs from decode stage
	logic [`XLEN-1:0] rs2_value;
	logic             rd_mem, wr_mem;
	logic       cond_branch;   //for ex_stage testbench						// is inst a conditional branch?
	logic       uncond_branch; //for ex_stage testbench						// is inst an unconditional branch?
	logic [`Preg_LEN-1:0]       dest_reg_idx;      //
	logic             halt, illegal, csr_op, valid;
	MEM_SIZE       mem_size; // byte, half-word or word

	logic [`b_mask_reg_width-1:0] is_b_mask;
	logic [$clog2(`b_mask_reg_width)-1:0] b_mask_bit_branch;

	//just change packet, haven't updated codes
	logic [`SQ_LEN:0]SQ_tail;
	logic [`ROB_LEN:0]ROB_tail;
	logic no_sort_sq;
} EX_COM_PACKET;

//----------------------------------------------------EX_COM end--------------------------------------------------------------------

// -------------------------------------------------------------------CDB-------------------------------------------------

typedef struct packed {
	logic [`Preg_LEN-1:0]Rd_Preg_From_C;	// FROM Complete
	logic [`XLEN-1:0]Preg_result;
	logic [$clog2(`b_mask_reg_width)-1:0] b_mask_bit_branch;
	logic [`ROB_LEN:0]ROB_tail;
	logic valid;
} CDB_IN_PACKET;

typedef struct packed {
	logic [`Preg_LEN-1:0]Rd_Preg_CDB;	// To RAT RS ROB
	logic Rd_Preg_ready_bit_CDB; // To RAT RS ROB
	logic [`XLEN-1:0]Preg_result;
	logic [$clog2(`b_mask_reg_width)-1:0] b_mask_bit_branch;
	logic [`ROB_LEN:0]ROB_tail;
	logic valid;
} CDB_OUT_PACKET;

// -------------------------------------------------------------------CDB end-------------------------------------------------
//------------------------------------------------------------BRAT------------------------------------------------------------------//


typedef struct packed {
	logic[`ROB_LEN:0]	rob_tail_brat;
	logic [`Freelist_size-1:0][`Preg_LEN-1:0]freelist_table_to_BRAT;
	logic[`Freelist_LEN:0] freelist_head_to_BRAT;
	logic[`Freelist_LEN:0] freelist_tail_to_BRAT;
	logic [`Areg_num-1:0][`Preg_LEN-1:0]Preg;
	logic [`Areg_num-1:0]ready_bit;
	logic[`width_b_mask-1:0]	b_mask_org;		//this is pre b_mask
	logic [`SQ_LEN:0]SQ_tail_BRAT;
	logic reset_sq;
} BRAT_PACKET;

typedef struct packed {
	logic [`Freelist_size-1:0][`Preg_LEN-1:0]freelist_table_to_BRAT;
	logic[`Freelist_LEN:0] freelist_head_to_BRAT;
	logic[`Freelist_LEN:0] freelist_tail_to_BRAT;
} FL2BRAT_PACKET;




typedef struct packed {
	logic [`Freelist_size-1:0][`Preg_LEN-1:0]freelist_table_to_BRAT;
	logic[`Freelist_LEN:0] freelist_head_to_BRAT;
	logic[`Freelist_LEN:0] freelist_tail_to_BRAT;
} BRAT2FL_PACKET;

typedef struct packed {
	logic [`Areg_num-1:0][`Preg_LEN-1:0]Preg;
	logic [`Areg_num-1:0]ready_bit;

} BRAT2RAT_PACKET;

typedef struct packed {
logic[`ROB_LEN:0]	rob_tail_brat;
} BRAT2ROB_PACKET;

typedef struct packed {
logic[`XLEN-1:0]	recovery_pc;
} BRAT2PC_PACKET;


typedef struct packed {
	logic rollback_brat_en;
	logic clean_brat_en;
	logic [`ALU_num-1:0]clean_bit_brat_en;
} brat_rec;


typedef struct packed {
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC

	logic [`XLEN-1:0] prs1_value;   // preg A value from physical register file                                 
	logic [`XLEN-1:0] prs2_value;    // preg B value                                  
	                                                                                
	ALU_OPA_SELECT opa_select; // ALU opa mux select (ALU_OPA_xxx *)
	ALU_OPB_SELECT opb_select; // ALU opb mux select (ALU_OPB_xxx *)
	INST inst;                 // instruction
	
	logic [$clog2(`Preg_num)-1:0] p_dest_reg_idx;  // destination (writeback) register index      
	ALU_FUNC    alu_func;      // ALU function select (ALU_xxx *)
	logic       rd_mem;        // does inst read memory?
	logic       wr_mem;        // does inst write memory?
	logic       cond_branch;   // is inst a conditional branch?
	logic       uncond_branch; // is inst an unconditional branch?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;
	logic        if_mul;
	logic [`b_mask_reg_width-1:0] rs_b_mask;
	logic [$clog2(`width_b_mask)-1:0] b_mask_bit_branch;
	logic is_branch; 
	
	logic BP_predicted_taken;
	logic [`XLEN-1:0]BP_predicted_target_PC;

	//just change packet, haven't updated codes
	logic [`SQ_LEN:0]SQ_tail;
	logic [`ROB_LEN:0]ROB_tail;
	logic load_issue_valid;
	logic no_sort_sq;
} Pre_IS_EX_PACKET;

typedef struct packed {
	logic [`XLEN-1:0] NPC;   												// PC + 4
	logic [`XLEN-1:0] PC;   												// PC

	logic [`XLEN-1:0] prs1_value;   //for ex_stage testbench 				// preg A value from physical register file                                 
	logic [`XLEN-1:0] prs2_value;   //for ex_stage testbench 				// preg B value                                  
	                                                                                
	ALU_OPA_SELECT opa_select; //for ex_stage testbench						// ALU opa mux select (ALU_OPA_xxx *)
	ALU_OPB_SELECT opb_select; //for ex_stage testbench						// ALU opb mux select (ALU_OPB_xxx *)
	INST inst;                 //for ex_stage testbench						// instruction
	
	logic [`Preg_LEN-1:0] p_dest_reg_idx;  							// destination (writeback) register index      
	ALU_FUNC    alu_func;      //for ex_stage testbench	 					// ALU function select (ALU_xxx *)
	logic       rd_mem;        												// does inst read memory?
	logic       wr_mem;        												// does inst write memory?
	logic       cond_branch;   //for ex_stage testbench						// is inst a conditional branch?
	logic       uncond_branch; //for ex_stage testbench						// is inst an unconditional branch?
	logic       halt;          												// is this a halt?
	logic       illegal;       												// is this instruction illegal?
	logic       csr_op;        												// is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;			//for ex_stage testbench	
	logic        if_mul;         //for ex_stage testbench					// is inst a valid instruction to be counted for CPI calculations?
	logic [`b_mask_reg_width-1:0] is_b_mask;
	logic [$clog2(`b_mask_reg_width)-1:0] b_mask_bit_branch; //which index of b mask is this branch
	logic is_branch;

	logic cond_bp;
	logic [`XLEN-1:0]target_PC_bp;

	//just change packet, haven't updated codes
	logic [`SQ_LEN:0]SQ_tail;
	logic [`ROB_LEN:0]ROB_tail;
	logic load_issue_valid;
	logic no_sort_sq;
} IS_EX_PACKET;
//--------------------------------------------------------brat end-----------------------------//
//-----------------------------------------------------BP------------------------------------------//
typedef struct packed {
	logic[9:0] BTB_tag;
	logic[11:0] part_target_pc;
	logic		uncond_BTB;
	logic		cond_BTB;
} BTB_table;

typedef struct packed {
	logic[`BHT_width-1:0] Branch_history;
} BHT_table;


typedef struct packed {
	logic[`XLEN-1:0]   calculated_target; ///////// calculated branch target, 4 alu                                                               
	logic              if_cond;                       ////////  
	logic[`XLEN-1:0]   branch_pc;  ////////   branch pc
	logic			   if_uncond;
	logic			   c_branch_taken;
} C_BTB_table;

typedef enum logic [1:0] {
	Strong_Taken = 2'h3,
	Taken      = 2'h2,
	Not_Taken  =2'h1,
	Strong_Not_Taken  =2'h0
}BC2;

typedef struct packed {
	logic Dispatch_enable;
	// logic [`Areg_LEN-1:0]Rs2_Areg;
	// logic [`Areg_LEN-1:0]Rd_Areg;

	INST inst;
	logic is_branch;
	logic       rd_mem;        // does inst read memory?
	logic       wr_mem;        // does inst write memory?
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC
	logic [`b_mask_reg_width-1:0] is_b_mask;
	logic [$clog2(`width_b_mask)-1:0] b_mask_bit_branch;
} LSQ_IN_Packet; //from dispatch


typedef struct packed{

	logic [`XLEN-1:0]value;               //from physical register or CDB
	logic [`ROB_LEN:0]ROB_pointer;		// from ROB
	logic [`XLEN-1:0]store_address;   //from execute
	logic address_value_valid;

	// logic [`Areg_LEN-1:0]Rs2_Areg;		//from dispatch
	logic [`Preg_LEN-1:0]Rs2_Preg;		//from RAT

	INST inst;

	logic       rd_mem;        // does inst read memory? load
	logic       wr_mem;        // does inst write memory? store 
	logic       halt;          // is this a halt?
	logic       illegal;       // is this instruction illegal?
	logic       csr_op;        // is this a CSR operation? (we only used this as a cheap way to get return code)
	logic       valid;         // is inst a valid instruction to be counted for CPI calculations?
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC
	logic [`b_mask_reg_width-1:0] is_b_mask;
	logic [$clog2(`width_b_mask)-1:0] b_mask_bit_branch;
	logic Retire_enable;

	MEM_SIZE       mem_size;
	logic addr_depend;
}SQ_PACKET;

typedef struct packed{

	logic [`XLEN-1:0]value;               //from physical register or CDB

	logic [`XLEN-1:0]store_address;   //from execute
	logic address_value_valid;
	INST inst;
	logic [`XLEN-1:0] NPC;   // PC + 4
	logic [`XLEN-1:0] PC;    // PC
	logic       rd_mem;        // does inst read memory? load
	logic       wr_mem;        // does inst write memory? store 
	MEM_SIZE mem_size;

}SQ_OUT_PACKET;

typedef struct packed {

	logic block_valid;
	logic	dirty;                                                        
	logic[$clog2(`CACHE_Assoc)-1:0] LRU_num;	
	logic[2*`XLEN-1:0] block_data;
	logic[`XLEN-`lsb_Cache_tag-1:0] tag;
} D_CACHE_BLOCK;


typedef enum logic [3:0] {
	IDLE='d0,
	LOAD_MISS_WAITTING_BUS='d1,
	STORE_MISS_WAITTING_BUS='d2,
	LOAD_MISS_IN_USE='d3,
	STORE_MISS_IN_USE='d4,
	LOAD_COMPLETE='d5,
	STORE_COMPLETE='d6,
	WAIT_EVICT='d7,
	EVICTING='d8,
	EVICT_COMPLETE='d9,
	INDEX_DEPEND='d10, // writing same index into D_cache
	ADDR_DEPEND='d11 // getting same block from mem
	//
}MSHR_FSM;

typedef struct packed {
	MSHR_FSM MSHR_state;
	BUS_COMMAND CMD; //// `BUS_NONE `BUS_LOAD or `BUS_STORE
	MEM_SIZE size_type;
	logic [`XLEN-1:0] MSHR_addr;
	logic [2*`XLEN-1:0] MSHR_data;   //mem to mshr block
	logic [`XLEN-1:0] st_data;		//store data 
	logic[$clog2(`MSHR_Depth):0] link_entry;
	// logic[$clog2(`MSHR_Depth):0] linked_entry;
	logic  [3:0] mem_tag;
	logic linked_idx_en;
	logic linked_addr_en;
	logic [`Preg_LEN-1:0]   ld_rd_preg;
	logic if_load;
	logic if_store;
	logic if_evict;
///////// for debug////////////////
	INST  inst;  
	logic [`XLEN-1:0] NPC; 
	
	logic mshr_valid;
	
	
	logic dirty;
	logic             take_branch; // is this a taken branch?
	
	//pass throughs from decode stage
	logic [`XLEN-1:0] rs2_value;
	logic             rd_mem, wr_mem;
	
	logic             halt, illegal, csr_op, valid;
	

	logic [`b_mask_reg_width-1:0] is_b_mask;
	logic [$clog2(`b_mask_reg_width)-1:0] b_mask_bit_branch;
	logic [`ROB_LEN:0]ROB_tail;	
} MSHR_ENTRY;


typedef struct packed{


	logic [`XLEN-1:0] alu_result;  // result from alu
	logic [`XLEN-1:0] NPC; //pc + 4
	logic             take_branch; // is this a taken branch?
	INST inst;
	//pass throughs from decode stage
	logic [`XLEN-1:0] rs2_value;
	logic [2*`XLEN-1:0]evict_data;
	logic             rd_mem, wr_mem;
	logic [`Preg_LEN-1:0]       dest_reg_idx;      //
	logic             halt, illegal, csr_op, valid;   //valid evict packet 0
	MEM_SIZE       mem_size; // byte, half-word or word

	logic [`b_mask_reg_width-1:0] is_b_mask;
	logic [$clog2(`b_mask_reg_width)-1:0] b_mask_bit_branch;

	//just change packet, haven't updated codes
	logic [`SQ_LEN:0]SQ_tail;
	logic [`ROB_LEN:0]ROB_tail;

	logic[`Cache_Index-1:0] index_addr;
	logic[`XLEN-`lsb_Cache_tag-1:0] tag_addr;

}MSHR_IN_PACKET;

typedef struct packed {

	logic block_valid;                                               
	logic[$clog2(`CACHE_Assoc)-1:0] LRU_num;	
	logic[2*`XLEN-1:0] block_data;
	logic[`XLEN-`lsb_Cache_tag-1:0] tag;
} I_CACHE_BLOCK;

typedef enum logic [1:0] {
	I_IDLE='d0,
	MISS_WAITTING_BUS='d1,
	MISS_IN_USE='d2,
	COMPLETE='d3
}I_MSHR_FSM;

typedef struct packed {
	I_MSHR_FSM MSHR_state;
	logic [`XLEN-1:0] MSHR_addr;
	logic [2*`XLEN-1:0] MSHR_data;   //mem to mshr block
	logic  [3:0] mem_tag;
	// logic mshr_valid;
} I_MSHR_ENTRY;

`endif // __SYS_DEFS_VH__

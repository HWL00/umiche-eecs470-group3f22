/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  testbench.v                                         //
//                                                                     //
//  Description :  Testbench module for the verisimple pipeline;       //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

import "DPI-C" function void print_header(string str);
import "DPI-C" function void print_cycles();
import "DPI-C" function void print_stage(string div, int inst, int npc, int valid_inst);
import "DPI-C" function void print_reg(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo,
                                       int wb_reg_wr_idx_out, int wb_reg_wr_en_out);
import "DPI-C" function void print_membus(int proc2mem_command, int mem2proc_response,
                                          int proc2mem_addr_hi, int proc2mem_addr_lo,
						 			     int proc2mem_data_hi, int proc2mem_data_lo);
import "DPI-C" function void print_close();



import "DPI-C" function void print_header_connected(string str);
import "DPI-C" function void print_RAT(int i, int Preg, int ready_bit);
import "DPI-C" function void print_ROB(int inst, int Preg, int Preg_ready_bit, int Preg_old);
import "DPI-C" function void print_Freelist(int i, int Preg);
import "DPI-C" function void print_RRAT(int i, int Preg, int ready_bit);
import "DPI-C" function void print_RS(int inst, int p_rd, int preg1, int preg2 , int preg1_ready,int preg2_ready ,int busy);
import "DPI-C" function void print_cycles_connected();
import "DPI-C" function void print_close_connected();
import "DPI-C" function void print_IS(int inst,int p_dest_reg_idx,int valid);
import "DPI-C" function void print_CDB(int i,int Rd_Preg_CDB,int Preg_result,int valid,int rob_tail);

import "DPI-C" function void print_header_physical(string str);
import "DPI-C" function void print_physical(int i,int value);
import "DPI-C" function void print_cycles_physical();
import "DPI-C" function void print_close_physical();

import "DPI-C" function void print_header_lsq_dcache(string str);
// import "DPI-C" function void print_phyprint_stage_lsq_dcachesical(int i,int value);
import "DPI-C" function void print_cycles_lsq_dcache();
import "DPI-C" function void print_close_lsq_dcache();
import "DPI-C" function void print_LSQ(int inst,int store_address,int value_hi,int value_lo,int address_value_valid,int ROB_pointer,int Retire_enable);
import "DPI-C" function void print_MSHR(int inst,int MSHR_state,int link_entry,int MSHR_addr,int MSHR_data_hi,int MSHR_data_lo,int st_data,int linked_idx_en,int linked_addr_en, int ld_rd_preg, int mem_tag);
import "DPI-C" function void print_dcache(int i,int block_data_hi,int block_data_lo,int tag,int LRU_num,int dirty,int block_valid);

import "DPI-C" function void print_header_icache(string str);
import "DPI-C" function void print_cycles_icache();
import "DPI-C" function void print_icache(int i,int block_data_hi,int block_data_lo,int tag,int LRU_num,int block_valid);
import "DPI-C" function void print_icache_MSHR(int MSHR_state,int MSHR_addr,int MSHR_data_hi,int MSHR_data_lo, int mem_tag);
import "DPI-C" function void print_close_icache();

module testbench;

	// variables used in the testbench
	logic        clock;
	logic        reset;

	logic [31:0] clock_count;
	logic [31:0] mshr_empty_clk_count;
	logic [31:0] mshr_empty_clk_count_tmp;
	logic [31:0] write_back_count;
	logic [31:0] evict_count;
	logic [31:0]mis_branch_count;
	logic [31:0]branch_count;
	logic [31:0] instr_count;
	logic [31:0] halt_count;
	logic mshr_empty;
	logic halt_flag;
	logic mshr_empty_flag;
	logic [`CACHE_Assoc-1:0]writing_asso;
	logic [`Cache_Index-1:0]writing_depth;

	int          wb_fileno;
	
	
	// logic [1:0]  proc2mem_command;
	// logic [`XLEN-1:0] proc2mem_addr;
	// logic [63:0] proc2mem_data;
	// logic  [3:0] mem2proc_response;
	// logic [63:0] mem2proc_data;
	// logic  [3:0] mem2proc_tag;
// `ifndef CACHE_MODE
// 	MEM_SIZE     proc2mem_size;
// `endif

	logic [3:0]   mem2proc_response;        // Tag from memory about current request
	logic [63:0]  mem2proc_data;            // Data coming back from memory
	logic [3:0]   mem2proc_tag;              // Tag from memory about current reply
	// logic [`XLEN-1:0]proc2Imem_addr,
	// output BUS_COMMAND  proc2mem_command,    // command sent to memory
	// output logic [`XLEN-1:0] proc2mem_addr,      // Address sent to memory
	// output logic [63:0] proc2mem_data,      // Data sent to memory
	// output MEM_SIZE proc2mem_size,          // data size sent to memory
	// logic [`XLEN-1:0] proc2mem_addr_out;    // address for current command
    // logic [63:0] proc2mem_data_out;    // address for current command
    // BUS_COMMAND   proc2mem_command_out;
	logic  [3:0] pipeline_completed_insts;
	EXCEPTION_CODE   pipeline_error_status;
	logic [`N_way-1:0] [4:0] pipeline_commit_wr_idx;
	logic [`N_way-1:0][`XLEN-1:0] pipeline_commit_wr_data;
	logic [`N_way-1:0]       pipeline_commit_wr_en;
	logic [`N_way-1:0][`XLEN-1:0] pipeline_commit_NPC;
	



//-----------------------------------new------------------------------

	logic [`N_way-1:0] [`XLEN-1:0]Imem2proc_data;
	logic [`XLEN-1:0] proc2Imem_addr;
	logic [`N_way-1:0][`XLEN-1:0] if_NPC_out;
	logic [`N_way-1:0] [31:0] if_IR_out;
	logic [`N_way-1:0]       if_valid_inst_out;
	logic [`N_way-1:0][`XLEN-1:0] if_dp_NPC;
	logic [`N_way-1:0][31:0] if_dp_IR;
	logic [`N_way-1:0]       if_dp_valid_inst;
	logic [`N_way-1:0][`XLEN-1:0] rs_is_NPC;
	logic [`N_way-1:0][31:0] rs_is_IR;
	logic [`N_way-1:0]       rs_is_valid_inst;
	logic [`ALU_num-1:0][`XLEN-1:0] is_ex_NPC_alu;
	logic [`ALU_num-1:0][31:0] is_ex_IR_alu;
	logic [`ALU_num-1:0]       is_ex_valid_inst_alu;
	logic [`MUL_num-1:0][`XLEN-1:0] is_ex_NPC_mul;
	logic [`MUL_num-1:0][31:0] is_ex_IR_mul;
	logic [`MUL_num-1:0]       is_ex_valid_inst_mul;
	logic [31:0]is_ex_NPC_load ;
	logic [31:0]is_ex_IR_load;
	logic is_ex_valid_inst_load;
	logic [31:0]is_ex_NPC_store;
	logic [31:0]is_ex_IR_store;
	logic is_ex_valid_inst_store;
	logic [`N_way-1:0][`XLEN-1:0] ex_com_NPC;
	logic [`N_way-1:0][31:0] ex_com_IR;
	logic [`N_way-1:0]       ex_com_valid_inst;
	logic [`N_way-1:0][`XLEN-1:0] retire_NPC;
	logic [`N_way-1:0][31:0] retire_IR;
	logic [`N_way-1:0]       retire_valid_inst;

	
	Pre_IS_EX_PACKET[`ALU_IB_Detpth-1:0] test_alu_is;
	Pre_IS_EX_PACKET[`MUL_IB_Detpth-1:0] test_mul_is;
	Pre_IS_EX_PACKET[`LOAD_IB_Depth-1:0] test_load_is;
	Pre_IS_EX_PACKET[`STORE_IB_Depth-1:0] test_store_is;
	CDB_OUT_PACKET [`N_way-1:0] cdb_out_packet;

	RRAT_PACKET [`Areg_num-1:0]RRAT_table; //to print
    Freelist_PACKET [`Freelist_size-1:0]Freelist_table;
    ROB_PACKET [`ROB_size-1:0]ROB_table;
    RAT_PACKET  RAT_table;

	rs_table [`RS_depth-1:0] rs_out_table;
	logic [`Preg_num-1:0] [`XLEN-1:0] registers;
	logic[`N_way-1:0][`XLEN-1:0]	final_entry2memory;


//----------------------------for inst fetch from memory--------------------
	// logic [63:0]                    unified_memory  [`MEM_64BIT_LINES - 1:0];
	logic[`N_way-1:0][`XLEN-1:0]	pre_proc2Imem_addr;
	logic [`N_way-1:0] [2*`XLEN-1:0] pre_Imem2proc_data;  //`N_way_div_2_round_up

	
	// logic [`XLEN-1:0] mem_wb_NPC;
	// logic [31:0] mem_wb_IR;
	// logic        mem_wb_valid_inst;

    //counter used for when pipeline infinite loops, forces termination
    logic [63:0] debug_counter;
	D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] d_cache;
	//for print
	MSHR_ENTRY[`MSHR_Depth:1] mshr;

	I_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] i_cache;
	//for print
	I_MSHR_ENTRY[`I_MSHR_Depth-1:0] i_mshr;
	SQ_PACKET [`SQ_size-1:0]store_queue;

	logic [`XLEN-1:0] proc2mem_addr;    // address for current command
    logic [63:0] proc2mem_data;    // address for current command
    BUS_COMMAND   proc2mem_command;
	logic[`Cache_Index-1:0] dcache_index;

	logic [`XLEN-1:0] proc2mem_addr2mem;    // address for current command
    logic [63:0] proc2mem_data2mem;    // address for current command
    BUS_COMMAND   proc2mem_command2mem;
	logic [3:0]complete_branch_count;
	logic [3:0]complete_mis_branch_count;
	logic [`XLEN-1:0] proc2mem_addr2mem_tmp;    // address for current command
    logic [63:0] proc2mem_data2mem_tmp;    // address for current command
    BUS_COMMAND   proc2mem_command2mem_tmp;
	// Instantiate the Pipeline
	pipeline core(
		// Inputs
		.clock             (clock),
		.reset             (reset),
		.Imem2proc_data(Imem2proc_data),

		.mem2proc_response (mem2proc_response),
		.mem2proc_data     (mem2proc_data),
		.mem2proc_tag      (mem2proc_tag),
		
		
		// Outputs
		.proc2Imem_addr(proc2Imem_addr),

		.proc2mem_addr_out     (proc2mem_addr),
		.proc2mem_data_out     (proc2mem_data),
		.proc2mem_command_out     (proc2mem_command),
		
		.pipeline_completed_insts(pipeline_completed_insts),
		.pipeline_error_status(pipeline_error_status),
		.pipeline_commit_wr_data(pipeline_commit_wr_data),
		.pipeline_commit_wr_idx(pipeline_commit_wr_idx),
		.pipeline_commit_wr_en(pipeline_commit_wr_en),
		.pipeline_commit_NPC(pipeline_commit_NPC),
		
		.if_NPC_out(if_NPC_out),
		.if_IR_out(if_IR_out),
		.if_valid_inst_out(if_valid_inst_out),
		.if_dp_NPC(if_dp_NPC),
		.if_dp_IR(if_dp_IR),
		.if_dp_valid_inst(if_dp_valid_inst),
		.rs_is_NPC(rs_is_NPC),
		.rs_is_IR(rs_is_IR),
		.rs_is_valid_inst(rs_is_valid_inst),
		.is_ex_NPC_alu(is_ex_NPC_alu),
		.is_ex_IR_alu(is_ex_IR_alu),
		.is_ex_valid_inst_alu(is_ex_valid_inst_alu),
		.is_ex_NPC_mul(is_ex_NPC_mul),
		.is_ex_IR_mul(is_ex_IR_mul),
		.is_ex_valid_inst_mul(is_ex_valid_inst_mul),
		.is_ex_NPC_load(is_ex_NPC_load),
		.is_ex_IR_load(is_ex_IR_load),
		.is_ex_valid_inst_load(is_ex_valid_inst_load),
		.is_ex_NPC_store(is_ex_NPC_store),
		.is_ex_IR_store(is_ex_IR_store),
		.is_ex_valid_inst_store(is_ex_valid_inst_store),
		.ex_com_NPC(ex_com_NPC),
		.ex_com_IR(ex_com_IR),
		.ex_com_valid_inst(ex_com_valid_inst),
		.retire_NPC(retire_NPC),
		.retire_IR(retire_IR),
		.retire_valid_inst(retire_valid_inst),

		.RRAT_table(RRAT_table), //to print
		.Freelist_table(Freelist_table),
		.ROB_table(ROB_table),
		.RAT_table(RAT_table),
		.rs_out_table(rs_out_table),
		.test_alu_is(test_alu_is),
		.test_mul_is(test_mul_is),
		.test_load_is(test_load_is),
		.test_store_is(test_store_is),
		.cdb_out_packet(cdb_out_packet),
		.registers(registers),
		.d_cache(d_cache),
	//for print
		.mshr(mshr),
		.i_cache(i_cache),
	//for print
		.i_mshr(i_mshr),
		.store_queue(store_queue),
		.complete_branch_count(complete_branch_count),
		.complete_mis_branch_count(complete_mis_branch_count)
	);
	
	
	// Instantiate the Data Memory
	mem memory (
		// Inputs
		.clk               (clock),
		.proc2mem_command  (proc2mem_command2mem),
		.proc2mem_addr     (proc2mem_addr2mem),
		.proc2mem_data     (proc2mem_data2mem),
`ifndef CACHE_MODE
		.proc2mem_size     (proc2mem_size),
`endif
		.reset(reset),
		// Outputs

		.mem2proc_response (mem2proc_response),
		.mem2proc_data     (mem2proc_data),
		.mem2proc_tag      (mem2proc_tag)
	);
	
	// Generate System Clock
	always begin
		#(`VERILOG_CLOCK_PERIOD/2.0);
		clock = ~clock;
	end
	
	// Task to display # of elapsed clock edges
	task show_clk_count;
		real cpi;
		input [31:0]clock_count;
		
		begin
			cpi = (clock_count + 1.0) / instr_count;
			$display("@@  %0d cycles / %0d instrs = %f CPI\n##",
			          clock_count+1, instr_count, cpi);
			$display("@@  %4.2f ns total time to execute\n##\n",
			          clock_count*`VERILOG_CLOCK_PERIOD);
		end
	endtask  // task show_clk_count 

	task show_branch_count;
		real mis_branch_rate;
		
		begin
			mis_branch_rate = (mis_branch_count+0.0) / branch_count;
			$display("##  %0d mis_branch_count / %0d branch_count = %f mis_branch_rate\n##",
			          mis_branch_count, branch_count, mis_branch_rate);
		end
	endtask  // task show_clk_count 
	
	// Show contents of a range of Unified Memory, in both hex and decimal
	task show_mem_with_decimal;
		input [31:0] start_addr;
		input [31:0] end_addr;
		int showing_data;
		begin
			$display("@@@");
			showing_data=0;
			for(int k=start_addr;k<=end_addr; k=k+1)
				if (memory.unified_memory[k] != 0) begin
					$display("@@@ mem[%5d] = %x : %0d", k*8, memory.unified_memory[k], 
				                                            memory.unified_memory[k]);
					showing_data=1;
				end else if(showing_data!=0) begin
					$display("@@@");
					showing_data=0;
				end
			$display("@@@");
		end
	endtask  // task show_mem_with_decimal

	task print_ALL_ROB_Freelist;
	input ROB_PACKET[`ROB_size-1:0]ROB_table;
	input Freelist_PACKET[`Freelist_size-1:0]Freelist_table;
	begin
		print_header_connected("ROB                                                                      Freelist");
		print_header_connected("\t Inst     | \t Preg \t| Preg ready | \t Preg_old 	                 Index \t | \t Preg \t ");
		for(int i=0;i<`Freelist_size;i++)
		begin
			print_ROB(ROB_table[i].inst,ROB_table[i].Preg,ROB_table[i].Preg_ready_bit,ROB_table[i].Preg_old);
			print_Freelist(i,Freelist_table[i].Preg);
		end
		print_header_connected("---------------------------ROB Freelist end------------------------------------------------------------\n");
	end
	endtask

	task print_ALL_RAT_RRAT;
	input RAT_PACKET RAT_table;
	input RRAT_PACKET[`Areg_num-1:0]RRAT_table;
	begin
		print_cycles_connected();
		print_header_connected("RAT                                                                       RRAT");
		print_header_connected("\t Areg \t | \t Preg \t | \t ready bit 		  	 	 	 	 	 	      Areg \t | \t Preg \t | \t ready bit \t ");
		for(int i=0;i<`Areg_num;i++)
		begin
			print_RAT(i,RAT_table.Preg[i],RAT_table.ready_bit[i]);
			print_RRAT(i,RRAT_table[i].Preg,RRAT_table[i].ready_bit);
		end
		print_header_connected("---------------------------RAT RRAT end----------------------------------------------------------------\n");
	end
	endtask

	task print_ALL_RS;
	input rs_table [`RS_depth-1:0] rs_out_table;
	begin
		print_header_connected("RS");
		print_header_connected("\t inst \t | \t T     \t | \t T1 \t | \t T2 \t|  T1ready  |\tT2ready | \t busy \t ");
		for(int i=0;i<`RS_depth;i++)
		begin
			print_RS(rs_out_table[i].inst,rs_out_table[i].p_rd,rs_out_table[i].preg1,rs_out_table[i].preg2,rs_out_table[i].preg1_ready,rs_out_table[i].preg2_ready,rs_out_table[i].busy);
		end
		print_header_connected("---------------------------RS end----------------------------------------------------------------\n");
	end
	endtask

	task print_IS_ALL;
	input Pre_IS_EX_PACKET[`ALU_IB_Detpth-1:0] test_alu_is;
	input Pre_IS_EX_PACKET[`MUL_IB_Detpth-1:0] test_mul_is;
	input Pre_IS_EX_PACKET[`LOAD_IB_Depth-1:0] test_load_is;
	input Pre_IS_EX_PACKET[`STORE_IB_Depth-1:0] test_store_is;

	begin
		print_header_connected("IS alu												                       IS mul");
		print_header_connected("\t inst \t | 	 P_rd    | \t valid \t         \t          \t inst \t | 	 P_rd    | \t valid \t ");
		for(int i=0;i<`ALU_IB_Detpth;i++)
		begin
			print_IS(test_alu_is[i].inst,test_alu_is[i].p_dest_reg_idx,test_alu_is[i].valid);
			print_IS(test_mul_is[i].inst,test_mul_is[i].p_dest_reg_idx,test_mul_is[i].valid);
			
			print_header_connected("\n");
		end
		print_header_connected("IS load												                       IS store");
		print_header_connected("\t inst \t | 	 P_rd    | \t valid \t         \t          \t inst \t | 	 P_rd    | \t valid \t ");
		for(int i=0;i<`ALU_IB_Detpth;i++)
		begin
			print_IS(test_load_is[i].inst,test_load_is[i].p_dest_reg_idx,test_load_is[i].valid);
			
			print_IS(test_store_is[i].inst,test_store_is[i].p_dest_reg_idx,test_store_is[i].valid);
			
			print_header_connected("\n");
		end
		print_header_connected("---------------------------IS end----------------------------------------------------------------\n");
	end
	endtask

	task print_CDB_ALL;
	input CDB_OUT_PACKET [`N_way-1:0] cdb_out_packet;
	begin
		print_header_connected("CDB");
		print_header_connected("\t i \t     |\t Preg \t | result \t |\t valid \t | ROB_tail \t ");
		for(int i=0;i<`N_way;i++)
		begin
			print_CDB(i,cdb_out_packet[i].Rd_Preg_CDB,cdb_out_packet[i].Preg_result,cdb_out_packet[i].Rd_Preg_ready_bit_CDB,cdb_out_packet[i].ROB_tail[`ROB_LEN-1:0]);
		end
		print_header_connected("---------------------------CDB end----------------------------------------------------------------\n");
	end
	endtask
	
	task print_physicalregisterfile;
	input logic [`Preg_num-1:0] [`XLEN-1:0] registers;
	begin
		print_header_physical("physical register file");
		print_cycles_physical();
		print_header_physical("\t Preg \t    | result \t ");
		for(int i=0;i<`Preg_num;i++)
		begin
			print_physical(i,registers[i]);
		end
		print_header_physical("---------------------------physical register file end-------------------------------------------\n");
		// print_close_physical();
	end

	endtask

	task print_SQ;
	input SQ_PACKET [`SQ_size-1:0]store_queue;
	begin
		print_cycles_lsq_dcache();
		print_header_lsq_dcache("Store Queue                                                                    ");
		print_header_lsq_dcache("\t Inst    | \tstore_address  |     value_hi  value_lo   | \t valid   | ROB_pointer |\t  Retire_enable");
		for(int i=0;i<`SQ_size;i++)
		begin
			print_LSQ(store_queue[i].inst,store_queue[i].store_address,store_queue[i].value[63:32],store_queue[i].value[31:0],store_queue[i].address_value_valid,store_queue[i].ROB_pointer[`ROB_LEN-1:0],store_queue[i].Retire_enable);
		end
		print_header_lsq_dcache("---------------------------Store Queue end------------------------------------------------------------\n");
	end
	endtask


	task print_MSHR_all;
	input MSHR_ENTRY[`MSHR_Depth:1] mshr;
	begin
		print_header_lsq_dcache("MSHR ");
		print_header_lsq_dcache("\t Inst    | 	          MSHR_state	     | link_entry | \t   MSHR_addr  \t  | MSHR_data_hi  MSHR_data_lo | \t st_data \t| linked_idx_en  |  linked_addr_en  | ld_rd_preg | \t  mem_tag");
		for(int i=1;i<`MSHR_Depth+1;i++)
		begin
			print_MSHR(mshr[i].inst,mshr[i].MSHR_state,mshr[i].link_entry,mshr[i].MSHR_addr,mshr[i].MSHR_data[63:32],mshr[i].MSHR_data[31:0],mshr[i].st_data,mshr[i].linked_idx_en,mshr[i].linked_addr_en,mshr[i].ld_rd_preg,mshr[i].mem_tag);

		end
		print_header_lsq_dcache("---------------------------MSHR end-------------------------------------------------------------------------------------------------------------------------------------\n");
	end
	endtask

	task print_d_cache_all;
	input D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] d_cache;
	begin
		print_header_lsq_dcache("D CACHE ");
		print_header_lsq_dcache("\t index \t  | block_data_hi block_data_lo| 	 	tag 	  | \t LRU_num | 	  dirty	   | \t block_valid                     index	  | block_data_hi block_data_lo| 	     tag 	  |    LRU_num 	 | 	  dirty    | 	 block_valid");
		for(int i=0;i<`Cache_depth;i++)begin
			for(int j=0;j<`CACHE_Assoc;j++)begin
				print_dcache(i,d_cache[j][i].block_data[63:32],d_cache[j][i].block_data[31:0],d_cache[j][i].tag,d_cache[j][i].LRU_num,d_cache[j][i].dirty,d_cache[j][i].block_valid);
			end
			print_header_lsq_dcache("");
		end
		print_header_lsq_dcache("---------------------------D CACHE end-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
	end
	endtask

	task print_icache_MSHR_all;
	input I_MSHR_ENTRY[`I_MSHR_Depth-1:0] i_mshr;
	begin
		print_cycles_icache();
		print_header_icache("MSHR ");
		print_header_icache("      MSHR_state     |    inst_hi  |   inst_lo   | \t   MSHR_addr      | MSHR_data_hi  MSHR_data_lo | \t  mem_tag");
		for(int i=0;i<`I_MSHR_Depth;i++)
		begin
			print_icache_MSHR(i_mshr[i].MSHR_state,i_mshr[i].MSHR_addr,i_mshr[i].MSHR_data[63:32],i_mshr[i].MSHR_data[31:0],i_mshr[i].mem_tag);

		end
		print_header_icache("---------------------------MSHR end-------------------------------------------------------------------------------------------------------------------------------------\n");
	end
	endtask

	task print_i_cache_all;
	input I_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] i_cache;
	begin
		print_header_icache("I CACHE ");
		print_header_icache("   inst_hi   |    inst_lo  | 	 index  | blockdata_hi   blockdata_lo| 	 	tag 	  | LRU_num  | 	 block_valid                  inst_hi  |   inst_lo   |	 index  | block_data_hi block_data_lo| 	     tag 	  |  LRU_num |	 block_valid");
		for(int i=0;i<`Cache_depth;i++)begin
			for(int j=0;j<`CACHE_Assoc;j++)begin
				print_icache(i,i_cache[j][i].block_data[63:32],i_cache[j][i].block_data[31:0],i_cache[j][i].tag,i_cache[j][i].LRU_num,i_cache[j][i].block_valid);
			end
			print_header_icache("");
		end
		print_header_icache("---------------------------I CACHE end-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
	end
	endtask

	initial begin
		//$dumpvars;
	
		clock = 1'b0;
		reset = 1'b1;
		Imem2proc_data = 0;
		halt_flag = 0;
		dcache_index = 0;
		mshr_empty = 0;
		mshr_empty_flag = 0;
		halt_count = 0;
		// mshr_empty_clk_count = 0;
		mshr_empty_clk_count_tmp = 0;
		evict_count = `MEM_LATENCY_IN_CYCLES+`MSHR_Depth + 1 + `MEM_LATENCY_IN_CYCLES + `MEM_LATENCY_IN_CYCLES + 32;
		// proc2mem_command2mem = BUS_NONE;
		// proc2mem_addr2mem = 0;
		// proc2mem_data2mem = 0;
		proc2mem_command2mem_tmp = 0;
		proc2mem_addr2mem_tmp = 0;
		proc2mem_data2mem_tmp = 0;
		write_back_count = `Cache_depth + `Cache_depth + `MEM_LATENCY_IN_CYCLES + `MEM_LATENCY_IN_CYCLES + 32;
		// mem2proc_response = 'd5;
		// mem2proc_data = 'd500;
		// mem2proc_tag = 'd5;
		
		// Pulse the reset signal
		$display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
		// reset = 1'b1;
		@(posedge clock);
		@(posedge clock);

		$readmemh("program.mem", memory.unified_memory);

		@(posedge clock);
		@(posedge clock);
		`SD;
		// This reset is at an odd time to avoid the pos & neg clock edges
		
		reset = 1'b0;

		$display("@@  %t  Deasserting System reset......\n@@\n@@", $realtime);
		wb_fileno = $fopen("writeback.out");
		
		//Open header AFTER throwing the reset otherwise the reset state is displayed
		print_header("                                                                           		 D-MEM Bus &\n");
		print_header("Cycle:  IF    |   IF/DP     |   DP/IS    |    IS/EX    |   EX/COM     |   Retire   Reg Result");



		// #10000 $finish;
	end
	
	// assign	proc2mem_command2mem = (halt_flag&&mshr_empty)?proc2mem_command2mem_tmp:proc2mem_command;
	// assign	proc2mem_addr2mem = (halt_flag&&mshr_empty)?proc2mem_addr2mem_tmp:proc2mem_addr; 
	// assign	proc2mem_data2mem = (halt_flag&&mshr_empty)?proc2mem_data2mem_tmp:proc2mem_data;

	assign	proc2mem_command2mem = mshr_empty?((clock_count> evict_count+mshr_empty_clk_count)?proc2mem_command2mem_tmp:0):proc2mem_command;
	assign	proc2mem_addr2mem = mshr_empty?((clock_count> evict_count+mshr_empty_clk_count)?proc2mem_addr2mem_tmp:0):proc2mem_addr;
	assign	proc2mem_data2mem = mshr_empty?((clock_count> evict_count+mshr_empty_clk_count)?proc2mem_data2mem_tmp:0):proc2mem_data;

	

	// Count the number of posedges and number of instructions completed
	// till simulation ends
	always @(posedge clock) begin
		if(reset) begin
			clock_count <= `SD 0;
			instr_count <= `SD 0;
			branch_count <= `SD 0;
			mis_branch_count <= `SD 0;
		end else begin
			clock_count <= `SD (clock_count + 1);
			if(halt_flag)begin
				instr_count <= `SD instr_count;
				branch_count <= `SD branch_count;
				mis_branch_count <= `SD mis_branch_count;
			end
			else begin
				instr_count <= `SD (instr_count + pipeline_completed_insts);
				branch_count <= `SD (branch_count + complete_branch_count);
				mis_branch_count <= `SD (mis_branch_count + complete_mis_branch_count);
			end
		end
	end  
	
	logic [`N_way-1:0][`XLEN-1:0]pre_addr;
	always @(negedge clock) begin
        if(reset) begin
			$display("@@\n@@  %t : System STILL at reset, can't show anything\n@@",
			         $realtime);
            debug_counter <= 0;
        end else begin
			if(!halt_flag)begin
			// proc2mem_command2mem = proc2mem_command;
			// proc2mem_addr2mem = proc2mem_addr; 
			// proc2mem_data2mem = proc2mem_data;
			// $display("clock_count%d",clock_count);
				// for(int i=0;i<`N_way;i++)begin 
				// 	pre_addr[i] = proc2Imem_addr + 4*i;
				// end
				// // $readmemh("program.mem", unified_memory);
				// for(int i=0;i<`N_way;i++)begin 
				// 	pre_proc2Imem_addr[i]= {pre_addr[i][`XLEN-1:3], 3'b0};       //not address, read lines
				// 	// $display("pre_proc2Imem_addr %h",pre_proc2Imem_addr[i]);
				// end
				
				// for(int i=0;i<`N_way;i++)begin 
				// 	final_entry2memory[i]=pre_proc2Imem_addr[i]/8;
				// 	pre_Imem2proc_data[i]=memory.unified_memory[final_entry2memory[i]];
				// end
				
				// // for(int j=0;j<`N_way;j++)begin
					
				// // 	// $display("pre_Imem2proc_data %h",pre_Imem2proc_data[i]);
				// // 	end
				// for(int i=0;i<`N_way;i++)begin 
				// 	Imem2proc_data[i]=pre_addr[i][2]? pre_Imem2proc_data[i][63:32] : pre_Imem2proc_data[i][31:0];
				// 	// $display("Imem2proc_data %h",Imem2proc_data[i]);
				// 	// $display("pre_proc2Imem_addr %h",(pre_proc2Imem_addr[i]/4)%2)
				// end

				`SD;
				`SD;
				// print the piepline stuff via c code to the pipeline.out
				// print_cycles();
				// print_header("\n");
				// for(int i=0;i<`ALU_num;i++)begin
				// 	if(i<`N_way) begin
				// 		print_stage(" ", if_IR_out[i], if_NPC_out[i], {31'b0,if_valid_inst_out[i]});
				// 		print_stage("|", if_dp_IR[i], if_dp_NPC[i], {31'b0,if_dp_valid_inst[i]});
				// 		print_stage("|", rs_is_IR[i], rs_is_NPC[i], {31'b0,rs_is_valid_inst[i]});
				// 	end
				// 	else begin
				// 		print_stage(" ", 0, 0, 0);
				// 		print_stage("|", 0, 0, 0);
				// 		print_stage("|", 0, 0, 0);
				// 	end
					
					
				// 	print_stage("|", is_ex_IR_alu[i], is_ex_NPC_alu[i], {31'b0,is_ex_valid_inst_alu[i]});
				// 	// print_stage("|", is_ex_IR_mul[i], is_ex_NPC_mul[i][31:0], {31'b0,is_ex_valid_inst_mul[i]});
				// 	if(i<`N_way)begin
				// 		print_stage("|", ex_com_IR[i], ex_com_NPC[i], {31'b0,ex_com_valid_inst[i]});
				// 		print_stage("|", retire_IR[i], retire_NPC[i], {31'b0,retire_valid_inst[i]});
				// 		print_reg(32'b0, pipeline_commit_wr_data[i][31:0],
				// 	{27'b0,pipeline_commit_wr_idx[i]}, {31'b0,pipeline_commit_wr_en[i]});
				// 	end
				// 	else begin
				// 		print_stage("|", 0, 0, 0);
				// 		print_stage("|", 0, 0, 0);
				// 	end
				// 	// print_stage("|", mem_wb_IR, mem_wb_NPC[31:0], {31'b0,mem_wb_valid_inst});
				// 	print_header("\n");
				// end
				// for(int i=0;i<`MUL_num;i++)begin
				// 	if(i+`ALU_num<`N_way)begin
				// 		print_stage(" ", if_IR_out[i+`ALU_num], if_NPC_out[i+`ALU_num], {31'b0,if_valid_inst_out[i+`ALU_num]});
				// 		print_stage("|", if_dp_IR[i+`ALU_num], if_dp_NPC[i+`ALU_num], {31'b0,if_dp_valid_inst[i+`ALU_num]});
				// 		print_stage("|", rs_is_IR[i+`ALU_num], rs_is_NPC[i+`ALU_num], {31'b0,rs_is_valid_inst[i+`ALU_num]});
				// 	end
				// 	else begin
				// 		print_stage(" ", 0, 0, 0);
				// 		print_stage("|", 0, 0, 0);
				// 		print_stage("|", 0, 0, 0);
				// 	end
				// 	print_stage("|", is_ex_IR_mul[i], is_ex_NPC_mul[i][31:0], {31'b0,is_ex_valid_inst_mul[i]});
				// 	if(i+`ALU_num<`N_way)begin
				// 		print_stage("|", ex_com_IR[i+`ALU_num], ex_com_NPC[i+`ALU_num], {31'b0,ex_com_valid_inst[i+`ALU_num]});
				// 		print_stage("|", retire_IR[i+`ALU_num], retire_NPC[i+`ALU_num], {31'b0,retire_valid_inst[i+`ALU_num]});
				// 		print_reg(32'b0, pipeline_commit_wr_data[i+`ALU_num][31:0],
				// 	{27'b0,pipeline_commit_wr_idx[i+`ALU_num]}, {31'b0,pipeline_commit_wr_en[i+`ALU_num]});
				// 	end
				// 	else begin 
				// 		print_stage("|", 0, 0, 0);
				// 		print_stage("|", 0, 0, 0);
				// 	end
				// 	// print_stage("|", mem_wb_IR, mem_wb_NPC[31:0], {31'b0,mem_wb_valid_inst});
				// 	print_header("\n");
					
				// 	// print_stage("|", mem_wb_IR, mem_wb_NPC[31:0], {31'b0,mem_wb_valid_inst});
				// end
				// print_stage(" ", 0, 0, 0);
				// print_stage("|", 0, 0, 0);
				// print_stage("|", 0, 0, 0);
				// print_stage("|", is_ex_IR_load, is_ex_NPC_load, {31'b0,is_ex_valid_inst_load});
				// print_stage("|", 0, 0, 0);
				// print_stage("|", 0, 0, 0);
				// print_header("\n");
				// print_stage(" ", 0, 0, 0);
				// print_stage("|", 0, 0, 0);
				// print_stage("|", 0, 0, 0);
				// print_stage("|", is_ex_IR_store, is_ex_NPC_store, {31'b0,is_ex_valid_inst_store});
				// print_stage("|", 0, 0, 0);
				// print_stage("|", 0, 0, 0);
				// // print_header("\n");


				// // print_header("\n");
				// //  print_close();

				// // if(!mshr_empty)begin
				// // 	print_SQ(store_queue);
				// // 	print_MSHR_all(mshr);
				// // 	print_d_cache_all(d_cache);
				// // end

				// print_IS_ALL(test_alu_is,test_mul_is,test_load_is,test_store_is);
				// print_ALL_RAT_RRAT(RAT_table,RRAT_table);
				// print_ALL_ROB_Freelist(ROB_table,Freelist_table);
				// print_ALL_RS(rs_out_table);
				// print_CDB_ALL(cdb_out_packet);
				// // print_close_connected();
				// print_physicalregisterfile(registers);
				// print_header_physical("\n");
				// print_icache_MSHR_all(i_mshr);
				// print_i_cache_all(i_cache);
				// //  print_reg(32'b0, pipeline_commit_wr_data[31:0],
				// // 	{27'b0,pipeline_commit_wr_idx}, {31'b0,pipeline_commit_wr_en});
				// print_membus({30'b0,proc2mem_command}, {28'b0,mem2proc_response},
				// 	32'b0, proc2mem_addr[31:0],
				// 	proc2mem_data[63:32], proc2mem_data[31:0]);
				// print_header("\n");
				// // print_header("\n");
				// // print_header("\n");
				// // print_header("\n");
				// // print_header("\n");
				// // print_header("\n");
				// // print_header("\n");

				
				// // if(!halt_flag)begin
				// print the writeback information to writeback.out
				// if(pipeline_completed_insts>0) begin
				for(int i=0;i<`N_way;i++)begin
					if(pipeline_commit_wr_en[i] && pipeline_commit_wr_idx[i])	begin
						$fdisplay(wb_fileno, "PC=%x, REG[%d]=%x",
							pipeline_commit_NPC[i]-4,
							pipeline_commit_wr_idx[i],
							pipeline_commit_wr_data[i]);
					end
					else if(pipeline_commit_wr_en[i]) begin
						$fdisplay(wb_fileno, "PC=%x, ---",
							pipeline_commit_NPC[i]-4);
					end
					
				end
				// end
			end 	 	
			// if(!mshr_empty || !halt_flag)begin
					// print_SQ(store_queue);
					// print_MSHR_all(mshr);
					// print_d_cache_all(d_cache);
			// end
			// deal with any halting conditions
			if((pipeline_error_status != NO_ERROR) &&!halt_flag) begin //50000000 // 
				
				// $display("@@@ Unified Memory contents hex on left, decimal on right: ");
				// show_mem_with_decimal(0,`MEM_64BIT_LINES - 1); 
				// 8Bytes per line, 16kB total
				
				$display("@@  %t : System halted\n@@", $realtime);
				
				case(pipeline_error_status)
					LOAD_ACCESS_FAULT:  
						$display("@@ System halted on memory error");
					HALTED_ON_WFI:          begin
						$display("@@ System halted on WFI instruction");

					end
					ILLEGAL_INST:
						$display("@@ System halted on illegal instruction");
					default: 
						$display("@@ System halted on unknown error code %x", 
							pipeline_error_status);
				endcase

				$display("@@\n@@");
				halt_flag = 1;
				halt_count = clock_count;
				// show_clk_count(halt_count);
				// show_branch_count;
				// print_close(); // close the pipe_print output file
				// $fclose(wb_fileno);
				// #100 $finish;
				
			end
			// if(debug_counter > 700)
			// 	#100 $finish;
            debug_counter <= debug_counter + 1;

			if(halt_flag)begin
				mshr_empty = 1;
				for(int j=`MSHR_Depth; j>0;j--)begin
					mshr_empty = mshr_empty && !mshr[j].mshr_valid;
				end
				if(mshr_empty)begin
					mshr_empty_clk_count_tmp = clock_count;
				end
				
			end
			// if(mshr_empty_flag)begin
			// 	mshr_empty_clk_count = clock_count;
			// 	mshr_empty_flag = 0;
			// end
			if(halt_flag && mshr_empty && clock_count> evict_count+evict_count+evict_count+mshr_empty_clk_count)begin
				if(d_cache[writing_asso][writing_depth].dirty)begin
					proc2mem_command2mem_tmp = BUS_STORE;
					proc2mem_addr2mem_tmp = {d_cache[writing_asso][writing_depth].tag,writing_depth,3'd0}; 
					proc2mem_data2mem_tmp = d_cache[writing_asso][writing_depth].block_data;		
				end



				if(clock_count==mshr_empty_clk_count+write_back_count+evict_count+evict_count+evict_count)begin
					$display("@@@ Unified Memory contents hex on left, decimal on right: ");
					show_mem_with_decimal(0,`MEM_64BIT_LINES - 1); 
					// $display("@@  %t : System halted\n@@", $realtime);
					$display("@@@ System halted on WFI instruction");
					$display("@@@\n@@");
					// show_branch_count;
					show_clk_count(halt_count);
					#100 $finish;
				end
			end
			// #100 $finish;
			if( debug_counter > 1000000)begin
				show_clk_count(clock_count);
				#100 $finish;
			end
		end  // if(reset)  
		
	end  
	always @(negedge clock) begin
			if(reset) begin
				writing_asso <= `SD 0;
				writing_depth <= `SD 0;
			end else if(halt_flag && mshr_empty  && clock_count> evict_count+evict_count+evict_count+mshr_empty_clk_count && mshr_empty_clk_count!=0)begin
				
				if(writing_depth==`Cache_depth-1)begin
					if(writing_asso==`CACHE_Assoc-1)begin
						writing_asso <= `SD 0;
					end
					else begin
						writing_asso <= `SD writing_asso + 1;
						writing_depth <= `SD 0;
					end
				end

				else begin
					writing_asso <= `SD writing_asso;
					writing_depth <= `SD writing_depth + 1;
				end
				
			end
	end 
	always@(negedge clock) begin
		if(reset)begin
			mshr_empty_clk_count <= `SD 0;
		end
		else begin
			if(mshr_empty_clk_count!=0)begin
				mshr_empty_clk_count <= `SD mshr_empty_clk_count;
			end
			else begin
				mshr_empty_clk_count <= `SD mshr_empty_clk_count_tmp;
			end
		end
	end

endmodule  // module testbench

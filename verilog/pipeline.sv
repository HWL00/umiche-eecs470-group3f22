/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  pipeline.v                                          //
//                                                                     //
//  Description :  Top-level module of the verisimple pipeline;        //
//                 This instantiates and connects the 5 stages of the  //
//                 Verisimple pipeline togeather.                      //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`ifndef __PIPELINE_V__
`define __PIPELINE_V__

`timescale 1ns/100ps

module pipeline (

	input         clock,                    // System clock
	input         reset,                    // System reset
	input [`N_way-1:0] [`XLEN-1:0]Imem2proc_data,   //fetch

	input [3:0]   mem2proc_response,        // Tag from memory about current request
	input [63:0]  mem2proc_data,            // Data coming back from memory
	input [3:0]   mem2proc_tag,              // Tag from memory about current reply
	output logic [`XLEN-1:0]proc2Imem_addr,
	// output BUS_COMMAND  proc2mem_command,    // command sent to memory
	// output logic [`XLEN-1:0] proc2mem_addr,      // Address sent to memory
	// output logic [63:0] proc2mem_data,      // Data sent to memory
	// output MEM_SIZE proc2mem_size,          // data size sent to memory
	output logic [`XLEN-1:0] proc2mem_addr_out,    // address for current command
    output logic [63:0] proc2mem_data_out,    // address for current command
    output BUS_COMMAND   proc2mem_command_out,

	output logic [3:0]  pipeline_completed_insts,
	output EXCEPTION_CODE   pipeline_error_status,
	output logic [`N_way-1:0][4:0]  pipeline_commit_wr_idx,
	output logic [`N_way-1:0][`XLEN-1:0] pipeline_commit_wr_data,
	output logic  [`N_way-1:0]      pipeline_commit_wr_en,
	output logic [`N_way-1:0][`XLEN-1:0] pipeline_commit_NPC,
	
	
	// testing hooks (these must be exported so we can test
	// the synthesized version) data is tested by looking at
	// the final values in memory
	
	output logic [`N_way-1:0][`XLEN-1:0] if_NPC_out,
	output logic [`N_way-1:0] [31:0] if_IR_out,
	output logic [`N_way-1:0]       if_valid_inst_out,
	output logic [`N_way-1:0][`XLEN-1:0] if_dp_NPC,
	output logic [`N_way-1:0][31:0] if_dp_IR,
	output logic [`N_way-1:0]       if_dp_valid_inst,
	output logic [`N_way-1:0][`XLEN-1:0] rs_is_NPC,
	output logic [`N_way-1:0][31:0] rs_is_IR,
	output logic [`N_way-1:0]       rs_is_valid_inst,
	output logic [`ALU_num-1:0][`XLEN-1:0] is_ex_NPC_alu,
	output logic [`ALU_num-1:0][31:0] is_ex_IR_alu,
	output logic [`ALU_num-1:0]       is_ex_valid_inst_alu,
	output logic [`MUL_num-1:0][`XLEN-1:0] is_ex_NPC_mul,
	output logic [`MUL_num-1:0][31:0] is_ex_IR_mul,
	output logic [`MUL_num-1:0]       is_ex_valid_inst_mul,
	output logic [31:0]is_ex_NPC_load,
	output logic [31:0]is_ex_IR_load,
	output logic is_ex_valid_inst_load,

	output logic [31:0]is_ex_NPC_store,
	output logic [31:0]is_ex_IR_store,
	output logic is_ex_valid_inst_store,
	output logic [`N_way-1:0][`XLEN-1:0] ex_com_NPC,
	output logic [`N_way-1:0][31:0] ex_com_IR,
	output logic [`N_way-1:0]       ex_com_valid_inst,
	output logic [`N_way-1:0][`XLEN-1:0] retire_NPC,
	output logic [`N_way-1:0][31:0] retire_IR,
	output logic [`N_way-1:0]       retire_valid_inst,


	//for print
	output RRAT_PACKET [`Areg_num-1:0]RRAT_table, //to print
    output Freelist_PACKET [`Freelist_size-1:0]Freelist_table,
    output ROB_PACKET [`ROB_size-1:0]ROB_table,
    output RAT_PACKET RAT_table,

	output rs_table [`RS_depth-1:0] rs_out_table,
	output Pre_IS_EX_PACKET[`ALU_IB_Detpth-1:0] test_alu_is,
	output Pre_IS_EX_PACKET[`MUL_IB_Detpth-1:0] test_mul_is,
	output Pre_IS_EX_PACKET[`LOAD_IB_Depth-1:0] test_load_is,
	output Pre_IS_EX_PACKET[`STORE_IB_Depth-1:0] test_store_is,
	output CDB_OUT_PACKET [`N_way-1:0] cdb_out_packet,

	output logic [`Preg_num-1:0] [`XLEN-1:0] registers,
	output D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] d_cache,

	output MSHR_ENTRY[`MSHR_Depth:1] mshr,
	output I_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] i_cache,
	output I_MSHR_ENTRY[`I_MSHR_Depth-1:0] i_mshr,
	output SQ_PACKET [`SQ_size-1:0]store_queue,
	output logic [3:0]complete_branch_count,
	output logic [3:0]complete_mis_branch_count

);
	//icache



	
	logic[`XLEN-1:0] miss_PC;
	logic [`I_MSHR_Depth-1:0] I_gnt_bus;
	logic [`XLEN-1:0] Iproc2mem_addr;
	BUS_COMMAND   Iproc2mem_command;
	logic[`XLEN-1:0]  Iblock_addr_mshr_out;
	logic[2*`XLEN-1:0] Iblock_data_mshr_out;  
	logic [`I_MSHR_Depth-1:0] Irequest_bus;
	logic Imshr_out_valid;
	logic [`N_way-1:0] Icache_hit;
	logic [`N_way-1:0]Icache_miss;
	logic [`N_way-1:0][`XLEN-1:0] icache2fetch_inst;
	// logic [`XLEN-1:0]current_PC;
	IF_ID_PACKET[`N_way-1:0] if_packet2Icache;

	logic [`XLEN-1:0] Dproc2mem_addr;    // address for current command
    logic [63:0] Dproc2mem_data;    // address for current command
    BUS_COMMAND   Dproc2mem_command;
	//-----------fetch----------------------------------------------------
	// logic [`XLEN-1:0] proc2Imem_addr;
	IF_ID_PACKET[`N_way-1:0] if_packet_out;
	logic [`XLEN-1:0] brat_full_back_pc;
	//--------------------bp--------------------------------------------
	logic [`N_way-1:0] pre_pc_valid;
	C_BTB_table[`ALU_num-1:0]  c_btb_packet;
	logic [`N_way-1:0][`XLEN-1:0] target_pc; //predict branch target pc
	logic [`N_way-1:0] branch_prediction;// cond_bp 
	// for bp test//
	logic [`N_way-1:0][`XLEN-1:0] test_target_pc;
	logic [`N_way-1:0] test_branch_prediction;
	BTB_table[`BTB_depth-1:0] test_btb;
	BHT_table [`BHT_depth-1:0] test_bht;
	BC2 [`PHT_depth-1:0]test_pht;
	//--------------------if/dp pipeline register--------------------------------------------
	logic if_dp_enable;
	IF_ID_PACKET[`N_way-1:0] if_dp_packet;

	FL2BRAT_PACKET [`N_way-1:0] freelist_table_to_BRAT_in;
	
	Freelist_PACKET [`Freelist_size-1:0]Freelist_table_BRAT;
    logic [`Freelist_LEN:0] head_BRAT;
    logic [`Freelist_LEN:0] tail_BRAT;
	

	//--------------------dispatch--------------------------------------------

	
	logic[`SQ_LEN:0]  num_avail_lsq;
	// assign num_avail_lsq = 'd`N_way;

	logic brat_full_stall;
	RAT_PACKET [`Areg_num-1:0] rat_brat;
	logic flag_back_pc;
	logic [`XLEN-1:0] back2fetch_pc;
	DP_BRAT_PACKET[`N_way-1:0] dp_brat_packet_out;
	Dispatch_TO_ConnectedROB_PACKET [`N_way-1:0] dp_rob_packet_out;

	//--------------------BRAT------------------------------------------------
	
	logic clean_brat_en;              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit

    logic[$clog2(`width_b_mask)-1:0]   clean_brat_num;
    BRAT2FL_PACKET   brat2fl_rollback;
    BRAT2RAT_PACKET    brat2rat_rollback;
    BRAT2ROB_PACKET     brat2rob_rollback;
	// logic[$clog2(`width_b_mask):0] avail_num_b_mask;
///////////////for rs//////////////////////////////
	BRAT_RS_PACKET[`N_way-1:0] brat2rs_out;
    BRAT2ROB_PACKET[`ALU_num-1:0]    brat2rob_clean_bit;  
///////////////////////for test////////////////////////////////
 	BRAT_PACKET[`width_b_mask-1:0]  test_bart;
	brat_rec recver;
	logic [`N_way-1:0] [`width_b_mask-1:0] test_b_mask_reg_out;
	Dispatch_TO_ConnectedROB_PACKET [`N_way-1 :0]brat_rob_packet_out;

	//--------------------connected ROB RS--------------------------------------------
	logic [`ROB_LEN:0]BP_mispredicted_tail; //from BRAT clear_en  tail
    logic BP_mispredicted_tail_valid;  //clear_en 
    logic [`ALU_num-1:0][`ROB_LEN:0]BP_notmispredicted_tail; //clear_bit_en tail
    logic [`ALU_num-1:0]BP_notmispredicted_tail_valid; //clear_bit_en 


    logic [`N_way-1:0] [`ROB_LEN:0] branch_tail; //ROB To bp

	logic [`N_LEN:0] freelist_available_num_out; //To dispatch
    logic [`N_LEN:0] ROB_available_size_out;

    RS_IS_PACKET [`N_way-1:0] rs_is_packet_out;
    logic [$clog2(`N_way) :0] avail_rs;

	Freelist_PACKET [`N_way-1:0][`Freelist_size-1:0]Freelist_table_to_BRAT; // Copy to BRAT
    logic [`N_way-1:0][`Freelist_LEN:0]freelist_head_to_BRAT;
    logic [`N_way-1:0][`Freelist_LEN:0]freelist_tail_to_BRAT;
	RAT_PACKET [`N_way-1:0] RAT_table_to_BRAT;

	logic [`N_way-1:0][`Preg_LEN-1:0]Rd_old_Preg_BRAT;

	ROB_RETIRE_PACKET [`N_way-1:0]ROB_retire_out;

	
	//D cache LSQ
	EX_COM_PACKET ex_ld_packet_in;   //from execute
    logic  [`LOAD_IB_Depth-1:0][`SQ_LEN:0]load_SQ_tail_to_SQ;   //load from rs to check ready
    logic [`LOAD_IB_Depth-1:0]load_SQ_tail_to_SQ_valid;    //load from rs to check ready
    logic  SQ_BP_mispredicted_tail_valid;   //from BRAT  connected BP_mispredicted_tail_valid   pipeline clean_brat_en
    logic [`SQ_LEN:0]SQ_BP_mispredicted_tail;  //from BRAT
    EX_COM_PACKET ex_out_packet_store;

    ///MEM/////////////////////////////////////
    // logic [3:0] mem2proc_response;// 0 = can't accept, other=tag of transaction
    // logic [63:0] mem2proc_data;    // data resulting from a load
    // logic [3:0] mem2proc_tag;     // 0 = no value, other=tag of transaction
    //////////from arbiter////////////
    logic [`MSHR_Depth-1:0] D_gnt_bus;    //D cache
	// assign gnt_bus = {`MSHR_Depth{1'b1}};
	// always_comb begin
	// 	gnt_bus = 0;
	// 	gnt_bus[7] = 1;
	// end

    logic [`LOAD_IB_Depth-1:0]load_SQ_tail_to_is_valid;
	logic [`SQ_LEN:0]retire_head2rs_is;
    logic retire_enable2rs_is;
     //BRAT//////////////////////////////////////////
    logic [`N_way-1:0][`SQ_LEN:0]SQ_tail_BRAT;
	logic reset_sq;    
    // EX_COM_PACKET ex_out_packet_load_new; //with load address forwarding
    // logic load_hit_sq;
    // logic stop_is_en_mshr;
    ///To Issue Buffer
    logic stop_is_en;
	logic stop_is_st_en;
	logic sq_memsize_stall; //stop load FU
    EX_COM_PACKET ex_ld_packet_to_execute;
    // logic  ld_Dcache_hit_out;

    // To dispatch
    logic  [`SQ_LEN:0] sq_available_num;
    // SQ_PACKET [`SQ_size-1:0]store_queue; //For print
    //--------------------output for memory----------------------------------------//
    // logic [`XLEN-1:0] proc2mem_addr_out;    // address for current command
    // logic [63:0] proc2mem_data_out;    // address for current command
    // BUS_COMMAND   proc2mem_command_out;
    //--------------------output for arbiter--------------------------------------//
    logic [`MSHR_Depth-1:0] request_bus;
	// D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] d_cache;
	// //for print
	// MSHR_ENTRY[`MSHR_Depth:1] mshr;
	//D cache LSQ

	//--------------------RS/IS Pipeline Register--------------------------------------------
	logic rs_is_enable;

	RS_IS_PACKET[`N_way-1:0] rs_is_packet;
	IS_EX_PACKET[`ALU_num-1:0] is_ex_packet_alu;
	IS_EX_PACKET[`MUL_num-1:0] is_ex_packet_mul;

	//---------IS stage input and output---------------------------------------------------

	logic [`N_way-1:0] [$clog2(`Preg_num)-1:0] preg1_index;
	logic [`N_way-1:0] [$clog2(`Preg_num)-1:0] preg2_index;
	logic[`N_LEN:0]  issue_buffer_alu_avail;
	logic[`N_LEN:0 ] issue_buffer_mul_avail;
	logic[`N_LEN:0] issue_buffer_load_avail;
	Pre_IS_EX_PACKET [`ALU_num-1:0] pre_alu_is_out;
	Pre_IS_EX_PACKET [`MUL_num-1:0] pre_mul_is_out;
	Pre_IS_EX_PACKET pre_load_is_ex_out;
	Pre_IS_EX_PACKET pre_store_is_ex_out;
	
	//--------------------IS/EX Pipeline Register--------------------------------------------
	logic is_ex_enable;
	IS_EX_PACKET  [`ALU_num-1:0] is_ex_alu_packet_in;
	IS_EX_PACKET  [`MUL_num-1:0] is_ex_mul_packet_in;


	//---------execute stage input and output---------------------------------------------------

	//output
	EX_COM_PACKET [`N_way-1:0] ex_packet_out_N;
	logic [`ALU_num-1:0] alu_busy_bits;
	logic [`MUL_num-1:0] mul_busy_bits;
	// logic [`FU_num-1:0] arbiter_out;
	EX_COM_PACKET [`FU_num-1:0] ex_packet_out;

	logic [`ALU_num-1:0]mis_bp;
	logic [`XLEN-1:0]target_PC_bp_out;
	logic [`ALU_num-1:0]is_branch;

	logic  [`ALU_num-1:0]clean_bit_brat_en;
	logic  [`ALU_num-1:0][$clog2(`b_mask_reg_width)-1:0]clean_bit_brat_num;

	//-------------------- EX/COM  Pipeline Register--------------------------------------------
	logic ex_com_enable;
	EX_COM_PACKET [`N_way-1:0]ex_com_packet;

	//---------complete stage input and output---------------------------------------------------

    // CDB_OUT_PACKET [`N_way-1:0] cdb_out_packet;

	//---------physical register file---------------------------------------------------
	logic  [`N_way-1:0][`Preg_LEN-1:0]wr_idx;    // write index
	logic  [`N_way-1:0][`XLEN-1:0] wr_data;            // write data
	logic  [`N_way-1:0]wr_en;        //from complete 
	logic [`N_way-1:0][`XLEN-1:0] rd_rs1_out,rd_rs2_out;
	logic [`N_way-1:0]retire_illegal;
	logic [`N_way-1:0]retire_halt;
	logic halt_flag;
	logic halt_flag_tmp;
	EXCEPTION_CODE   pipeline_error_status_tmp;
	assign pipeline_error_status_tmp =  |retire_illegal             ? ILLEGAL_INST :
	                                	|retire_halt                ? HALTED_ON_WFI :
	                                // (mem2proc_response==4'h0)  ? LOAD_ACCESS_FAULT :
	                                	NO_ERROR;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//							Missing Logic, Modified on Dec 5 4:21pm 											 //
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	logic stall_IS_MSHR;
	logic sq_empty;

	always_ff@(posedge clock)begin
		if(reset)
			pipeline_error_status <= `SD NO_ERROR;
		else
			pipeline_error_status <= `SD pipeline_error_status_tmp;
	end

	always_comb begin
		halt_flag_tmp = 0;
		retire_illegal = 0;
		retire_halt = 0;
		pipeline_completed_insts = 0;
		complete_branch_count = 0;
		for(int i =0;i<`N_way;i++)begin
			if(ROB_retire_out[i].Retire_enable) begin
				retire_illegal[i] = ROB_retire_out[i].illegal;
				retire_halt[i] = ROB_retire_out[i].halt;
				if(retire_halt[i])begin
					halt_flag_tmp = 1;
					break;
				end
				pipeline_completed_insts = pipeline_completed_insts + 1;
				if(ROB_retire_out[i].is_branch)begin
					complete_branch_count = complete_branch_count + 1;
				end
			end
		end
	end

	always_ff @(posedge clock) begin
		if (reset) begin 
			halt_flag <= `SD 0;
		end
		else if(halt_flag)begin
			halt_flag <= `SD halt_flag;
		end
		else begin
			halt_flag <= `SD halt_flag_tmp;
		end
	end // always

	always_comb begin
		for(int i =0;i<`N_way;i++)begin
			// pipeline_commit_wr_idx[i] = ex_com_packet[i].dest_reg_idx;
			if(ROB_retire_out[i].valid)begin
				pipeline_commit_wr_idx[i] = ROB_retire_out[i].Rd_Areg;
				pipeline_commit_wr_data[i] = ROB_retire_out[i].Rd_Preg_value;
				pipeline_commit_wr_en[i] = ROB_retire_out[i].valid ;
				pipeline_commit_NPC[i] = ROB_retire_out[i].NPC;
			end
			else begin
				pipeline_commit_wr_idx[i] = ROB_retire_out[i].Rd_Areg;
				pipeline_commit_wr_data[i] = ROB_retire_out[i].Rd_Preg_value;
				pipeline_commit_wr_en[i] = 0;
				pipeline_commit_NPC[i] = ROB_retire_out[i].NPC;
			end
		end
	end

	always_comb begin
		complete_mis_branch_count = 0;
		complete_mis_branch_count = clean_brat_en;
	end
	
	// assign proc2mem_command =
	//      (proc2Dmem_command == BUS_NONE) ? BUS_LOAD : proc2Dmem_command;
	// assign proc2mem_addr =
	//      (proc2Dmem_command == BUS_NONE) ? proc2Imem_addr : proc2Dmem_addr;
	// //if it's an instruction, then load a double word (64 bits)
	// assign proc2mem_size =
	//      (proc2Dmem_command == BUS_NONE) ? DOUBLE : proc2Dmem_size;
	// assign proc2mem_data = {32'b0, proc2Dmem_data};
	logic I_grant;
	logic D_grant;
	always_comb begin
		I_grant = 0;
		D_grant = 0;
		I_grant = |I_gnt_bus;
		D_grant = |D_gnt_bus;
		proc2mem_command_out = 0;
		proc2mem_addr_out = 0;
		proc2mem_data_out = 0;

		if(D_grant)begin
			proc2mem_command_out = Dproc2mem_command;
			proc2mem_addr_out = Dproc2mem_addr;
			proc2mem_data_out = Dproc2mem_data;
		end
		else if(I_grant)begin
			proc2mem_command_out = Iproc2mem_command;
			proc2mem_addr_out = Iproc2mem_addr;
			proc2mem_data_out = 0;
		end
	end
	// assign proc2mem_command_out = proc2mem_command;
	//     //  (proc2mem_command == BUS_NONE) ? BUS_LOAD : proc2mem_command;
	// assign proc2mem_addr_out =
	//      (proc2mem_command == BUS_NONE) ? proc2mem_addr : proc2mem_addr;
	// //if it's an instruction, then load a double word (64 bits)
	// // assign proc2mem_size =
	// //      (proc2Dmem_command == BUS_NONE) ? DOUBLE : proc2Dmem_size;
	// // assign proc2mem_data_out = {32'b0, proc2mem_data};
	// assign proc2mem_data_out = proc2mem_data;


	//////////////////////////////////////////////////
//                                              //
//                  arbiter		               //
//                                              //
//////////////////////////////////////////////////
	arbiter arbiter_0(
			.clock(clock),                  // system clock
			.reset(reset),                  // system reset
			.req(request_bus),
			.I_req(Irequest_bus),
			.mem2proc_response(mem2proc_response),

			.I_grant(I_gnt_bus),
			.grant(D_gnt_bus)
	);

	//////////////////////////////////////////////////
//                                              //
//                  Icache		               //
//                                              //
//////////////////////////////////////////////////
	ICache_ctrl ICache_ctrl_0 (
		.clock(clock),
		.reset(reset),

		////////////from Icache///////////////
		.Icache_miss(Icache_miss),  // load inst miss in the d cache

		.miss_PC(miss_PC), //from I cache
		///////////from mem////////////////
		.mem2proc_response(mem2proc_response),// 0 = can't accept, other=tag of transaction
		.mem2proc_data(mem2proc_data),    // data resulting from a load
		.mem2proc_tag(mem2proc_tag),     // 0 = no value, other=tag of transaction
		//////////from arbiter////////////
		.gnt_bus(I_gnt_bus),
		// branch clean
		.clean_brat_en(clean_brat_en),              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
		/////////////output//////////////
		//--------------------output for memory----------------------------------------//
		.proc2mem_addr_out(Iproc2mem_addr),    // address for current command
		// output  logic [63:0] proc2mem_data_out,    // address for current command
		.proc2mem_command_out(Iproc2mem_command),
		//--------------------output for I-cache----------------------------------------//
		.block_addr_mshr_out(Iblock_addr_mshr_out),
		.block_data_mshr_out(Iblock_data_mshr_out),         
		//--------------------output for arbiter--------------------------------------//
		.request_bus(Irequest_bus),                            //output to arbiter 

		.mshr_out_valid(Imshr_out_valid),
		///////for debug/////////////////////////////
		.mshr(i_mshr)
	);
	ICache ICache_0(
		.clock(clock),
		.reset(reset),

		////////////from Icache///////////////
		// .current_PC(current_PC),  //from fetch
		.if_packet2Icache(if_packet2Icache),
		//////////from MSHR///////////////

		.block_data_mshr_in(Iblock_data_mshr_out),
		.block_addr_mshr_in(Iblock_addr_mshr_out),
		.mshr_out_valid(Imshr_out_valid),


		.Icache_hit(Icache_hit),   // load inst hit in the i cache
		.Icache_miss(Icache_miss),  // load inst miss in the i cache
		.icache2fetch_inst(icache2fetch_inst),

		.miss_PC(miss_PC), //to mshr
		.i_cache(i_cache) //for print
);

//////////////////////////////////////////////////
//                                              //
//                  Retire-Stage                //
//                                              //
//////////////////////////////////////////////////

	always_comb begin
		for(int i=0;i<`N_way;i++)begin
			if(ROB_retire_out[i].Retire_enable) begin
				retire_NPC[i]        = ROB_retire_out[i].NPC;
				retire_IR[i]     = ROB_retire_out[i].inst;
				retire_valid_inst[i] = ROB_retire_out[i].valid;
			end
			else begin
				retire_NPC[i]        = 0;
				retire_IR[i]     = 0;
				retire_valid_inst[i] = 0;
			end
		end
	end
//////////////////////////////////////////////////
//                                              //
//                  IF-Stage                    //
//                                              //
//////////////////////////////////////////////////
	
	//these are debug signals that are now included in the packet,
	// //breaking them out to support the legacy debug modes
	always_comb begin
		for(int i=0;i<`N_way;i++)begin
			if_NPC_out[i]        = if_packet_out[i].NPC;
			if_IR_out[i]     = if_packet_out[i].inst;
			if_valid_inst_out[i] = if_packet_out[i].valid;
		end
	end
	// if_stage if_stage_0 (
	// 	// Inputs
	// 	.clock (clock),
	// 	.reset (reset),
	// 	.mem_wb_valid_inst(mem_wb_valid_inst),
	// 	.ex_mem_take_branch(ex_mem_packet.take_branch),
	// 	.ex_mem_target_pc(ex_mem_packet.alu_result),
	// 	.Imem2proc_data(mem2proc_data),
		
	// 	// Outputs
	// 	.proc2Imem_addr(proc2Imem_addr),
	// 	.if_packet_out(if_packet)
	// );

	Fetch fetch_0(
	////////////input/////////////////////////////////////
		.clock(clock),                  // system clock
		.reset(reset || halt_flag),                  // system reset

	//////////from ex/////////////////
		.misprediction_ex(mis_bp),                                     //input[`N_way-1:0] misprediction_ex,
		.target_pc_ex(target_PC_bp_out),//input[`XLEN-1:0]   target_pc_ex,
	///////from bp////////
		.taken_bp(branch_prediction),              // from bp 1 for taken, 0 for not taken
		.target_pc(target_pc),        // target pc if misprediction_ntaken

	//////////from BRAT and Dispatcher///////////////
		.brat_full_stall(brat_full_stall),
		.brat_full_back_pc(brat_full_back_pc),
		.flag_back_pc(flag_back_pc),
		.back2fetch_pc(back2fetch_pc),
	///////////from I$ or memory fake fetch////////////////////////////////
		.Imem2proc_data(icache2fetch_inst),          // Data coming back from instruction-memory
		.Icache_miss(Icache_miss),
    	.miss_PC(miss_PC),
	/////////////////////output////////////////////////////////
		.if_packet2Icache(if_packet2Icache),
		.proc2Imem_addr(proc2Imem_addr),    // Address sent to Instruction memory
		.if_packet_out (if_packet_out)        // Output data packet from IF going to ID, see sys_defs for signal information 
	);
	always_comb begin
		for(int i=0;i<`N_way;i=i+1)begin
			pre_pc_valid[i]=if_packet_out[i].valid;
		end
	end


// always_comb begin
// 	for(int i=0;i<`ALU_num;i++)begin
// 		c_btb_packet[i].calculated_target = ex_packet_out[i+`MUL_num].alu_result;
// 		c_btb_packet[i].if_cond = pre_alu_is_out[i].cond_branch;
// 		c_btb_packet[i].branch_pc = pre_alu_is_out[i].PC;
// 		c_btb_packet[i].if_uncond = pre_alu_is_out[i].uncond_branch;
// 		c_btb_packet[i].c_branch_taken= ex_packet_out[i+`MUL_num].take_branch;
// 	end
// end
	BP BP_0(
		////////input///////////////////////////////
		.clock(clock),
		.reset(reset || halt_flag),
		///////maybe from pc////////
		.fetch_pc(proc2Imem_addr),        //maybe from prefetcher
		.pre_pc_valid(pre_pc_valid),              //maybe miss
		////////from complete stage////////           
		.c_btb_packet(c_btb_packet) ,                  /////input from complete stage to btb  
		///////////output//////////////
		.target_pc(target_pc),
		.branch_prediction(branch_prediction),
		///////////////////just for test//////////////
		.test_target_pc(test_target_pc),
		.test_branch_prediction(test_branch_prediction),
		.test_btb(test_btb),
		.test_bht(test_bht),
		.test_pht(test_pht) 
	);
//////////////////////////////////////////////////
//                                              //
//            IF/DP Pipeline Register           //
//                                              //
//////////////////////////////////////////////////

	assign if_dp_enable = 1'b1; // always enabled
	// synopsys sync_set_reset "reset"

	always_comb begin
		for(int i=0;i<`N_way;i++)begin
			if_dp_NPC[i]        = if_dp_packet[i].NPC;
			if_dp_IR[i]     = if_dp_packet[i].inst;
			if_dp_valid_inst[i] = if_dp_packet[i].valid;
		end
	end


	always_ff @(posedge clock) begin
		if (reset || halt_flag) begin 
			for(int i=0; i<`N_way;i++)begin
				if_dp_packet[i].inst  <= `SD `NOP;
				if_dp_packet[i].valid <= `SD `FALSE;
				if_dp_packet[i].NPC   <= `SD 0;
				if_dp_packet[i].PC    <= `SD 0;
				if_dp_packet[i].BP_predicted_taken <=`SD 0;
				if_dp_packet[i].BP_predicted_target_PC <=`SD 0;
			end
		end
		else begin
			if (if_dp_enable) begin
				if_dp_packet<= `SD if_packet_out; 
			end // if (if_id_enable)	
		end
	end // always


   	always_comb begin
		freelist_table_to_BRAT_in = 0;
		Freelist_table_BRAT = 0;
		head_BRAT = 0;
		tail_BRAT = 0;
		for(int i=0;i<`N_way;i++)begin
			freelist_table_to_BRAT_in[i].freelist_table_to_BRAT = Freelist_table_to_BRAT[i];
			freelist_table_to_BRAT_in[i].freelist_head_to_BRAT = freelist_head_to_BRAT[i];
			freelist_table_to_BRAT_in[i].freelist_tail_to_BRAT = freelist_tail_to_BRAT[i];

		end
		Freelist_table_BRAT = brat2fl_rollback.freelist_table_to_BRAT;
		head_BRAT = brat2fl_rollback.freelist_head_to_BRAT;
		tail_BRAT = brat2fl_rollback.freelist_tail_to_BRAT;
   	end
//////////////////////////////////////////////////
//                                              //
//                  Dispatch-Stage              //
//                                              //
//////////////////////////////////////////////////
	Dispatcher DP_0(	
	//////////////////////////input/////////////////////////////
	.clock(clock),              // system clock
	.reset(reset),              // system reset
	.if_id_packet_in(if_dp_packet),        //from if stage to instruction decoder
	.num_avail_rs(avail_rs),				//available num of entries in rob, 0 ? 1? the reason of setting									
	.num_avail_rob(ROB_available_size_out),			//available num in rob
	.num_avail_fl(freelist_available_num_out),            //available num in freelist
	// .num_avail_lsq(num_avail_lsq),        //dont care now
	.sq_empty(sq_empty), 
	// .sq_available_num(num_avail_lsq),
	// .avail_num_b_mask(avail_num_b_mask),
	////////output////////////
   	// .brat_full_stall(brat_full_stall),                  ///when brat is full, stall pipeline
////////////////for fetech////////////////////////
	.flag_back_pc(flag_back_pc),
	.back2fetch_pc(back2fetch_pc),                         //for fetching inst in next cycle if there is a structure hazard in rs,rob,fl or lsq
	.dp_rob_packet_out(dp_rob_packet_out), // dispatch_in_packet to connected_ROB_RS
	.dp_brat_packet_out(dp_brat_packet_out)
    );


	BRAT	BRAT_0(
////////////input////////////////
        .clock(clock),
        .reset(reset  || halt_flag),
        //////////////from other///////////////////////////
        .misprediction(mis_bp),
        .if_branch_ex(is_branch), ///from complete stage or ex
        .b_mask_bit_branch_ex(clean_bit_brat_num),// input[$clog2(`width_b_mask)-1:0]    last_b_mask_branch,     
        .rob_tail_brat_in(branch_tail),
        .freelist_table_to_BRAT_in(freelist_table_to_BRAT_in),
        .rat_brat_in(RAT_table_to_BRAT),
		.num_avail_lsq(num_avail_lsq),
		.SQ_tail_BRAT(SQ_tail_BRAT),
		.reset_sq(reset_sq),
		.retire_head2rs_is(retire_head2rs_is),
        .retire_enable2rs_is(retire_enable2rs_is),
     /////////////from ex stage/////////////////////
        .clean_bit_brat_en(clean_bit_brat_en), //from ex stage
    //////////////////from dispatch stage//////////////////
        .dp_brat_in(dp_brat_packet_out),
		.brat_full_stall(brat_full_stall), 
		.brat_full_back_pc(brat_full_back_pc),
		.SQ_BP_mispredicted_tail(SQ_BP_mispredicted_tail),
		.dp_rob_packet(dp_rob_packet_out),
// ///////////from rob connected//////
       .Rd_old_Preg_BRAT(Rd_old_Preg_BRAT),
	   .cdb_out_packet(cdb_out_packet),
////////////////output///////////////
////////////////for recovery//////////////////////
        .clean_brat_en(clean_brat_en),              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
        .clean_brat_num(clean_brat_num),
        .brat2fl_rollback(brat2fl_rollback),
        .brat2rat_rollback(brat2rat_rollback),
        .brat2rob_rollback(brat2rob_rollback),
////////////////for dispatch////////////////////////
        // .avail_num_b_mask(avail_num_b_mask),
///////////////for rs//////////////////////////////
        .brat2rs_out(brat2rs_out),                                           //////
/////////////// for rob////////////////////////////
		.brat_rob_packet_out(brat_rob_packet_out),
        .brat2rob_clean_bit(brat2rob_clean_bit),  
///////////////////////for test////////////////////////////////
       	.test_bart(test_bart),
        .recver(recver),
        .test_b_mask_reg_out(test_b_mask_reg_out)
		
	);

//////////////////////////////////////////////////
//                                              //
//            connected_ROB_RS           //
//                                              //
//////////////////////////////////////////////////


	assign BP_mispredicted_tail = brat2rob_rollback.rob_tail_brat;
	assign BP_mispredicted_tail_valid = clean_brat_en;

	always_comb begin
		for(int i=0;i<`ALU_num;i++) begin
			BP_notmispredicted_tail[i] = brat2rob_clean_bit[i].rob_tail_brat;
			BP_notmispredicted_tail_valid[i] = clean_bit_brat_en[i];
		end
	end
	connected_ROB_RS connected_ROB_RS_0(
		// Inputs
		.clock             (clock),
		.reset             (reset ),
		.dispatch_in_packet(brat_rob_packet_out),//from dispatch
		.cdb_connectedrob_in_packet(cdb_out_packet), //from cdb
		.BP_mispredicted_tail(BP_mispredicted_tail), //from BRAT
		.BP_mispredicted_tail_valid(BP_mispredicted_tail_valid),
		.BP_notmispredicted_tail(BP_notmispredicted_tail), //clear_bit_en tail
        .BP_notmispredicted_tail_valid(BP_notmispredicted_tail_valid),//clear_bit_en

		//output
		.branch_tail(branch_tail), //To bp
		.freelist_available_num_out(freelist_available_num_out), //To dispatch
		.ROB_available_size_out(ROB_available_size_out),

		.RRAT_table(RRAT_table), //to print
		.Freelist_table(Freelist_table),
		.ROB_table(ROB_table),
		.RAT_table(RAT_table),
		.rs_out_table(rs_out_table),

		//RS--------------------------------------------
		//input
		.dp_rs_packet_in(brat2rs_out),

        .clean_brat_num(clean_brat_num),  //from brat
        .clean_bit_brat_num(clean_bit_brat_num),  //which bit should clean when clean_bit_brat_en[i] is 1 
		//////input from issuebuffer/////////////////
        .issue_buffer_alu_avail(issue_buffer_alu_avail),									/// if alu and mul busy
        .issue_buffer_mul_avail(issue_buffer_mul_avail),
		.issue_buffer_load_avail(issue_buffer_load_avail),
		//output 
		// .rs_out_table(rs_out_table),
		.rs_is_packet_out(rs_is_packet_out),
		.avail_rs(avail_rs),
		
		// input from BRAT
    	.Freelist_table_BRAT(Freelist_table_BRAT),
    	.head_BRAT(head_BRAT),
    	.tail_BRAT(tail_BRAT),
    	.rat_brat(brat2rat_rollback),
		
		// output to BRAT
		.Freelist_table_to_BRAT(Freelist_table_to_BRAT), // Copy to BRAT
    	.freelist_head_to_BRAT(freelist_head_to_BRAT),
    	.freelist_tail_to_BRAT(freelist_tail_to_BRAT),
		.RAT_table_to_BRAT(RAT_table_to_BRAT),
		.Rd_old_Preg_BRAT(Rd_old_Preg_BRAT),
		.ROB_retire_out(ROB_retire_out),



		 //LSQ D CACHE INPUT and output //////////////////////////////////////////////////////////////////////////////////////////
		 .ex_ld_packet_in(ex_ld_packet_in),
		 .load_SQ_tail_from_is(load_SQ_tail_to_SQ),
		 .load_SQ_tail_from_is_valid(load_SQ_tail_to_SQ_valid),
		//  .SQ_BP_mispredicted_tail_valid(SQ_BP_mispredicted_tail_valid),
		 .SQ_BP_mispredicted_tail(SQ_BP_mispredicted_tail),
		 .ex_out_packet_store(ex_out_packet_store),

		 .mem2proc_response(mem2proc_response),
		 .mem2proc_data(mem2proc_data),
		 .mem2proc_tag(mem2proc_tag),

		 .sq_memsize_stall(sq_memsize_stall),
		//  .sq_memsize_stall_tmp(sq_memsize_stall_tmp),
		 .gnt_bus(D_gnt_bus),
		 .retire_head2rs_is(retire_head2rs_is),
         .retire_enable2rs_is(retire_enable2rs_is),
		 .load_SQ_tail_to_is_valid(load_SQ_tail_to_is_valid),
		 .SQ_tail_BRAT(SQ_tail_BRAT),
		 .reset_sq(reset_sq),
		 .ex_ld_packet_to_execute(ex_ld_packet_to_execute),
		//  .stop_is_en_mshr(stop_is_en_mshr),
		 .stop_is_en(stop_is_en),
		 .stop_is_st_en(stop_is_st_en),
		 .stall_IS_MSHR(stall_IS_MSHR),
		//  .sq_empty(sq_empty),
		 .sq_available_num(num_avail_lsq),
		 .sq_empty(sq_empty), 
		 .store_queue(store_queue),
		 .proc2mem_addr_out(Dproc2mem_addr),
		 .proc2mem_data_out(Dproc2mem_data),
		 .proc2mem_command_out(Dproc2mem_command),
		 .request_bus(request_bus),
		 .d_cache(d_cache),
		 .mshr(mshr)
		 
		 //LSQ D CACHE INPUT and output //////////////////////////////////////////////////////////////////////////////////////////
	);
//////////////////////////////////////////////////
//                                              //
//            RS/IS Pipeline Register           //
//                                              //
//////////////////////////////////////////////////


	always_comb begin
		for(int i=0;i<`N_way;i++)begin
			rs_is_NPC[i]        = rs_is_packet_out[i].NPC;
			rs_is_IR[i]     = rs_is_packet_out[i].inst;
			rs_is_valid_inst[i] = rs_is_packet_out[i].valid;
		end
	end
	
	
//////////////////////////////////////////////////
//                                              //
//                  IS-Stage                    //
//                                              //
//////////////////////////////////////////////////



	Issue_Stage issue_stage_0(
		///////////input///////////
		.clock(clock),
		.reset(reset  || halt_flag),
		.rs_is_packet_in(rs_is_packet_out),
		.alu_busy(alu_busy_bits), 
		.mul_busy(mul_busy_bits), 
		.preg1_value(rd_rs1_out),
		.preg2_value(rd_rs2_out),
		.stall_IS_MSHR(stall_IS_MSHR),            //stall issue from MSHR
		.sq_memsize_stall(sq_memsize_stall),
		.stop_is_en(stop_is_en),
		.stop_is_st_en(stop_is_st_en),
    	.ready_issue_lsq(load_SQ_tail_to_is_valid),
		// .load_SQ_tail_to_SQ()
		.retire_head2rs_is(retire_head2rs_is),
        .retire_enable2rs_is(retire_enable2rs_is),
		.load_SQ_tail_to_SQ(load_SQ_tail_to_SQ),
		.load_SQ_tail_to_SQ_valid(load_SQ_tail_to_SQ_valid),
		////////brat///////////////////
		.clean_brat_en(clean_brat_en),              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
		.clean_brat_num(clean_brat_num),  //from brat
		.clean_bit_brat_en(clean_bit_brat_en),          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
		.clean_bit_num_brat_ex(clean_bit_brat_num),
		///////////output///////////
		.preg1_index(preg1_index),
		.preg2_index(preg2_index),
		.avail_alu_is_out(issue_buffer_alu_avail),
		.avail_mul_is_out(issue_buffer_mul_avail),
		.avail_load_is_out(issue_buffer_load_avail),
		.pre_alu_is_out(pre_alu_is_out),
		.pre_mul_is_out(pre_mul_is_out),
		.pre_load_is_ex_out(pre_load_is_ex_out),
		.pre_store_is_ex_out(pre_store_is_ex_out),
		.test_alu_is(test_alu_is),
		.test_mul_is(test_mul_is),
		.test_load_is(test_load_is),
		.test_store_is(test_store_is)

	);


//////////////////////////////////////////////////
//                                              //
//            IS/EX Pipeline Register           //
//                                              //
//////////////////////////////////////////////////
	always_comb begin
		for(int i=0;i<`ALU_num;i++)begin
			is_ex_NPC_alu[i]        = pre_alu_is_out[i].NPC;
			is_ex_IR_alu[i]     = pre_alu_is_out[i].inst;
			is_ex_valid_inst_alu[i] = pre_alu_is_out[i].valid;
		end
		for(int i=0;i<`MUL_num;i++)begin
			is_ex_NPC_mul[i]        = pre_mul_is_out[i].NPC;
			is_ex_IR_mul[i]     = pre_mul_is_out[i].inst;
			is_ex_valid_inst_mul[i] = pre_mul_is_out[i].valid;
		end
		is_ex_NPC_load        = pre_load_is_ex_out.NPC;
		is_ex_IR_load     = pre_load_is_ex_out.inst;
		is_ex_valid_inst_load = pre_load_is_ex_out.valid;

		is_ex_NPC_store        = pre_store_is_ex_out.NPC;
		is_ex_IR_store     = pre_store_is_ex_out.inst;
		is_ex_valid_inst_store = pre_store_is_ex_out.valid;
	end



//////////////////////////////////////////////////
//                                              //
//                  EX-Stage                    //
//                                              //
//////////////////////////////////////////////////
    
    
	ex_stage ex_stage_0(
		// Input
		.clock(clock),               // system clock
		.reset(reset  || halt_flag),               // system reset
		.is_ex_alu_packet_in(pre_alu_is_out), 
		.is_ex_mul_packet_in(pre_mul_is_out),
		.is_ex_load_packet_in(pre_load_is_ex_out), 
		.is_ex_store_packet_in(pre_store_is_ex_out),
		.ex_ld_packet_to_execute(ex_ld_packet_to_execute),
		// .sq_memsize_stall(sq_memsize_stall),
		// .sq_memsize_stall_tmp(sq_memsize_stall_tmp),

		.clean_brat_en(clean_brat_en),
		.clean_brat_num(clean_brat_num),
		// Output
		.ex_packet_out_N(ex_packet_out_N),
		.ex_ld_packet_out(ex_ld_packet_in),  //to SQ and d cache
		.ex_out_packet_store(ex_out_packet_store),

		.alu_busy_bits(alu_busy_bits),
		.mul_busy_bits(mul_busy_bits),
		// For Debug
		.ex_packet_out(ex_packet_out),

		.mis_bp(mis_bp),
		.target_PC_bp_out(target_PC_bp_out),
		.is_branch(is_branch),

		.clean_bit_brat_en(clean_bit_brat_en),
		.clean_bit_brat_num(clean_bit_brat_num),
		.c_btb_packet(c_btb_packet)

		
        // .ex_out_bit(ex_out_bit)
	);


//////////////////////////////////////////////////
//                                              //
//           EX/COM Pipeline Register           //
//                                              //
//////////////////////////////////////////////////
	

	always_comb begin
		for(int i=0;i<`N_way;i++)begin
			ex_com_NPC[i]        = ex_com_packet[i].NPC;
			ex_com_IR[i]     = ex_com_packet[i].inst;
			ex_com_valid_inst[i] = ex_com_packet[i].valid;
		end
	end
	assign ex_com_enable = 1'b1; // always enabled
	// synopsys sync_set_reset "reset"
	always_ff @(posedge clock) begin
		if (reset || halt_flag) begin
			for(int i=0;i<`N_way;i++)begin
				ex_com_packet[i].alu_result <= `SD 0;  // result from alu
				ex_com_packet[i].NPC <= `SD 0; //pc + 4
				ex_com_packet[i].take_branch <= `SD 0; // is this a taken branch?
				ex_com_packet[i].inst <= `SD `NOP;
				//pass throughs from decode stage
				ex_com_packet[i].rs2_value <= `SD 0;
				ex_com_packet[i].rd_mem <= `SD 0; 
				ex_com_packet[i].wr_mem <= `SD 0;
				ex_com_packet[i].dest_reg_idx <= `SD 0;      //
				ex_com_packet[i].halt <= `SD 0;
				ex_com_packet[i].illegal <= `SD 0; 
				ex_com_packet[i].csr_op <= `SD 0; 
				ex_com_packet[i].valid <= `SD 0;
				ex_com_packet[i].mem_size <= `SD 0; // byte, half-word or word

				ex_com_packet[i].is_b_mask <= `SD 0;
				ex_com_packet[i].b_mask_bit_branch <= `SD 0;
			end
		end else begin
			if (ex_com_enable)   begin
				ex_com_packet <= `SD ex_packet_out_N;
			end // if
		end // else: !if(reset)
	end // always

//////////////////////////////////////////////////
//                                              //
//                  COM-Stage                    //
//                                              //
//////////////////////////////////////////////////


	complete_stage complete_stage_0(
		//input
		.clock(clock),                // system clock
		.reset(reset),                // system reset
		.com_packet_in(ex_com_packet),
        // .ex_out_bit(ex_out_bit),

		.clean_brat_en(clean_brat_en),                                  //From BRAT
		.clean_brat_num(clean_brat_num),
		.clean_bit_brat_en(clean_bit_brat_en),                //From execute
		.clean_bit_brat_num(clean_bit_brat_num),
		//output
        // .complete_packet_out(complete_packet_out),
		.cdb_out_packet(cdb_out_packet)
	);

//Physical register file


	always_comb begin
		wr_idx = 0;
		wr_data = 0;
		wr_en = 0;
		for(int i=0;i<`N_way;i++)begin
			wr_en[i] = cdb_out_packet[i].Rd_Preg_ready_bit_CDB;
			wr_idx[i] = cdb_out_packet[i].Rd_Preg_CDB;
			wr_data[i] = cdb_out_packet[i].Preg_result;
		end
	end

	physical_regfile physical_regfile_0(
        .clock(clock),
		.reset(reset),
        .rd_rs1_idx(preg1_index), 	//read rs1 index
		.rd_rs2_idx(preg2_index),
        .wr_idx(wr_idx),    // write index
        .wr_data(wr_data),            // write data
        .wr_en(wr_en),        //from complete 


        .rd_rs1_out(rd_rs1_out),
		.rd_rs2_out(rd_rs2_out),    // read data
        .registers(registers)    // 32, 32-bit Registers
      );
  







// //////////////////////////////////////////////////
// //                                              //
// //                 MEM-Stage                    //
// //                                              //
// //////////////////////////////////////////////////
// 	mem_stage mem_stage_0 (// Inputs
// 		.clock(clock),
// 		.reset(reset),
// 		.ex_mem_packet_in(ex_mem_packet),
// 		.Dmem2proc_data(mem2proc_data[`XLEN-1:0]),
		
// 		// Outputs
// 		.mem_result_out(mem_result_out),
// 		.proc2Dmem_command(proc2Dmem_command),
// 		.proc2Dmem_size(proc2Dmem_size),
// 		.proc2Dmem_addr(proc2Dmem_addr),
// 		.proc2Dmem_data(proc2Dmem_data)
// 	);


// //////////////////////////////////////////////////
// //                                              //
// //           MEM/WB Pipeline Register           //
// //                                              //
// //////////////////////////////////////////////////
// 	assign mem_wb_enable = 1'b1; // always enabled
// 	// synopsys sync_set_reset "reset"
// 	always_ff @(posedge clock) begin
// 		if (reset) begin
// 			mem_wb_NPC          <= `SD 0;
// 			mem_wb_IR           <= `SD `NOP;
// 			mem_wb_halt         <= `SD 0;
// 			mem_wb_illegal      <= `SD 0;
// 			mem_wb_valid_inst   <= `SD 0;
// 			mem_wb_dest_reg_idx <= `SD `ZERO_REG;
// 			mem_wb_take_branch  <= `SD 0;
// 			mem_wb_result       <= `SD 0;
// 		end else begin
// 			if (mem_wb_enable) begin
// 				// these are forwarded directly from EX/MEM latches
// 				mem_wb_NPC          <= `SD ex_mem_packet.NPC;
// 				mem_wb_IR           <= `SD ex_mem_IR;
// 				mem_wb_halt         <= `SD ex_mem_packet.halt;
// 				mem_wb_illegal      <= `SD ex_mem_packet.illegal;
// 				mem_wb_valid_inst   <= `SD ex_mem_packet.valid;
// 				mem_wb_dest_reg_idx <= `SD ex_mem_packet.dest_reg_idx;
// 				mem_wb_take_branch  <= `SD ex_mem_packet.take_branch;
// 				// these are results of MEM stage
// 				mem_wb_result       <= `SD mem_result_out;
// 			end // if
// 		end // else: !if(reset)
// 	end // always


// //////////////////////////////////////////////////
// //                                              //
// //                  WB-Stage                    //
// //                                              //
// //////////////////////////////////////////////////
// 	wb_stage wb_stage_0 (
// 		// Inputs
// 		.clock(clock),
// 		.reset(reset),
// 		.mem_wb_NPC(mem_wb_NPC),
// 		.mem_wb_result(mem_wb_result),
// 		.mem_wb_dest_reg_idx(mem_wb_dest_reg_idx),
// 		.mem_wb_take_branch(mem_wb_take_branch),
// 		.mem_wb_valid_inst(mem_wb_valid_inst),
		
// 		// Outputs
// 		.reg_wr_data_out(wb_reg_wr_data_out),
// 		.reg_wr_idx_out(wb_reg_wr_idx_out),
// 		.reg_wr_en_out(wb_reg_wr_en_out)
// 	);

endmodule  // module verisimple
`endif // __PIPELINE_V__

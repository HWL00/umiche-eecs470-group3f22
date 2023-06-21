module connected_ROB_RS(input clock, input reset, 
    input Dispatch_TO_ConnectedROB_PACKET [`N_way-1:0] dispatch_in_packet,//from dispatch
    input CDB_OUT_PACKET [`N_way-1:0] cdb_connectedrob_in_packet, //from cdb
    input [`ROB_LEN:0]BP_mispredicted_tail, //from BRAT clear_en  tail ROB
    input BP_mispredicted_tail_valid,  //clear_en 
    input [`ALU_num-1:0][`ROB_LEN:0]BP_notmispredicted_tail, //clear_bit_en tail
    input [`ALU_num-1:0]BP_notmispredicted_tail_valid, //clear_bit_en 

    //----------------RS input 
    input BRAT_RS_PACKET [`N_way-1:0] dp_rs_packet_in,                                  //from brat now
    input [$clog2(`N_way):0]    issue_buffer_alu_avail,									/// if alu and mul busy
	input [$clog2(`N_way):0]     issue_buffer_mul_avail,
    input [$clog2(`N_way):0]     issue_buffer_load_avail,
	input [$clog2(`b_mask_reg_width)-1:0]clean_brat_num,
	input  [`ALU_num-1:0][$clog2(`b_mask_reg_width)-1:0]clean_bit_brat_num,


    //branch input from BRAT
    input Freelist_PACKET [`Freelist_size-1:0]Freelist_table_BRAT,
    input [`Freelist_LEN:0] head_BRAT,
    input [`Freelist_LEN:0] tail_BRAT,
    input RAT_PACKET rat_brat,

    //LSQ D CACHE INPUT and output //////////////////////////////////////////////////////////////////////////////////////////
    input EX_COM_PACKET ex_ld_packet_in,   //from execute
    input  [`LOAD_IB_Depth-1:0][`SQ_LEN:0]load_SQ_tail_from_is,   //load from rs to check ready
    input [`LOAD_IB_Depth-1:0]load_SQ_tail_from_is_valid,    //load from rs to check ready
    // input  SQ_BP_mispredicted_tail_valid,   //from BRAT  connected BP_mispredicted_tail_valid   pipeline clean_brat_en
    input [`SQ_LEN:0]SQ_BP_mispredicted_tail,  //from BRAT
    input reset_sq,
    input EX_COM_PACKET ex_out_packet_store,

    ///MEM/////////////////////////////////////
    input [3:0] mem2proc_response,// 0 = can't accept, other=tag of transaction
    input [63:0] mem2proc_data,    // data resulting from a load
    input [3:0] mem2proc_tag,     // 0 = no value, other=tag of transaction
    //////////from arbiter////////////
    input [`MSHR_Depth-1:0] gnt_bus,

    output logic [`LOAD_IB_Depth-1:0]load_SQ_tail_to_is_valid,
    output [`SQ_LEN:0]retire_head2rs_is,
    output retire_enable2rs_is,
     //BRAT//////////////////////////////////////////
    output logic [`N_way-1:0][`SQ_LEN:0]SQ_tail_BRAT,
    output EX_COM_PACKET ex_ld_packet_to_execute, //with load address forwarding
    // output logic load_hit_sq,
    // output  logic stop_is_en_mshr,
    ///To Issue Buffer
    output logic stop_is_en,
    output logic stop_is_st_en,
    output logic sq_memsize_stall, //to execute
    // output logic sq_memsize_stall_tmp,
    // output EX_COM_PACKET ex_ld_packet_to_ex;
    // output logic  ld_Dcache_hit_out,

    // To dispatch
    output logic  [`SQ_LEN:0] sq_available_num,
    output logic sq_empty, 
    output SQ_PACKET [`SQ_size-1:0]store_queue, //For print
    //--------------------output for memory----------------------------------------//
    output logic [`XLEN-1:0] proc2mem_addr_out,    // address for current command
    output logic [63:0] proc2mem_data_out,    // address for current command
    output BUS_COMMAND   proc2mem_command_out,
    //--------------------output for arbiter--------------------------------------//
    output logic [`MSHR_Depth-1:0] request_bus,
	output D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] d_cache,
	//for print
	output MSHR_ENTRY[`MSHR_Depth:1] mshr,
    output logic stall_IS_MSHR,
    // output logic sq_empty,
    //end LSQ  D cache /////////////////////////////////////////////////////////////////////////////////////////////

    //branch output to BRAT
	output Freelist_PACKET [`N_way-1:0][`Freelist_size-1:0]Freelist_table_to_BRAT, // Copy to BRAT
    output [`N_way-1:0][`Freelist_LEN:0]freelist_head_to_BRAT,
    output [`N_way-1:0][`Freelist_LEN:0]freelist_tail_to_BRAT,
	output RAT_PACKET [`N_way-1:0] RAT_table_to_BRAT,
    output logic [`N_way-1:0] [`ROB_LEN:0] branch_tail, //ROB To bp

    output [`N_LEN:0] freelist_available_num_out, //To dispatch
    output [`N_LEN:0] ROB_available_size_out,
    // output ConnectedROB_TO_RS_PACKET[`N_way-1:0] connectedrob_to_rs_packet, //To RS
    output RRAT_PACKET [`Areg_num-1:0]RRAT_table, //to print
    output Freelist_PACKET [`Freelist_size-1:0]Freelist_table,
    output ROB_PACKET [`ROB_size-1:0]ROB_table,
    output RAT_PACKET RAT_table,

    //rs out------------------------------------------------------------
    output rs_table [`RS_depth-1:0] rs_out_table,
    output RS_IS_PACKET [`N_way-1:0] rs_is_packet_out,
    output [$clog2(`N_way) :0] avail_rs,

    output logic [`N_way-1:0][`Preg_LEN-1:0]Rd_old_Preg_BRAT,
    output ROB_RETIRE_PACKET [`N_way-1:0]ROB_retire_out
    );


    RAT_IN_PACKET [`N_way-1:0]  rat_in_packet;
    RAT_OUT_PACKET [`N_way-1:0] rat_out_packet;
    
    ROB_IN_PACKET [`N_way-1:0] rob_in_packet;
    ROB_OUT_PACKET [`N_way-1:0] rob_out_packet; 
    
    logic [`ROB_LEN:0]ROB_available_size;
    logic [`ROB_LEN:0]ROB_head;    //for debug
    logic [`ROB_LEN:0]ROB_tail;   //for debug  tail is empty, the line before tail is the last inst

    Freelist_IN_PACKET [`N_way-1:0]freelist_in_packet;
    Freelist_OUT_PACKET [`N_way-1:0] freelist_out_packet;
    
    logic [`Freelist_LEN:0]freelist_available_num;
    logic [`Freelist_LEN:0]freelist_head;
    logic [`Freelist_LEN:0]freelist_tail;

    RRAT_IN_PACKET [`N_way-1:0]rrat_in_packet;

//-------------------------------------RS--------------------------------------------------------------------

	///////////From maptable//////////////
	logic  [`N_way-1:0][$clog2(`Preg_num)-1:0] rs_preg1_in;
    logic  [`N_way-1:0][$clog2(`Preg_num)-1:0] rs_preg2_in;
                             ///tag1,tag2 ///
	logic  [`N_way-1:0]  rs_preg1_ready_in;                                                      //if tag1,tage2 ready or not
    logic  [`N_way-1:0]  rs_preg2_ready_in;

	////////////From freelist////////////
	logic  [`N_way-1:0][$clog2(`Preg_num)-1:0] rs_p_rd_in;                    //tag for rd which from freelist
																			//if freelist empty

	/////////From  CDB //////////////////
	logic  [`N_way-1:0][$clog2(`Preg_num)-1:0] rs_cdb_tag;				//from cdb, comparing tag with tag1 and tag2
	logic  [`N_way-1:0] rs_cdb_valid;

    logic  [`RS_depth-1:0][`SQ_LEN:0]rs_load_SQ_tail_to_SQ;   //load from rs to check ready
    logic [`RS_depth-1:0]rs_load_SQ_tail_to_SQ_valid;    //load from rs to check ready
    logic [`RS_depth-1:0]load_SQ_tail_to_rs_valid;


    //LSQ Dcache
    // EX_COM_PACKET ex_ld_packet_in;
    //lsq///////
    LSQ_IN_Packet [`N_way-1:0]lsq_in_packet;  //from dispatch
    // logic load_hit_sq;
    // output logic  ld_Dcache_hit_out,
    //rs//////////////////////////////////////
    // logic [`RS_depth-1:0][`SQ_LEN:0]load_SQ_tail_from_rs;   //load from rs to check ready
    // logic [`RS_depth-1:0]load_SQ_tail_from_rs_valid;    //load from rs to check ready

    //RAT//////////////////////////////////////////
    // RAT_OUT_PACKET [`N_way-1:0] rat_out_packet;
    //ROB//////////////////////////////////////////
    // ROB_OUT_PACKET [`N_way-1:0] rob_out_packet;
    // ROB_RETIRE_PACKET [`N_way-1:0]ROB_retire_out;

    //BRAT//////////////////////////////////////////
    // logic SQ_BP_mispredicted_tail_valid;   //from BRAT  connected BP_mispredicted_tail_valid   pipeline clean_brat_en
    // logic [`SQ_LEN:0]SQ_BP_mispredicted_tail;  //from BRAT

    ///ex/////////////////////////////////////////////
    // EX_COM_PACKET ex_out_packet_store;  //ALU packet for store
    // EX_COM_PACKET ex_out_packet_load_lsq;

    // ///MEM/////////////////////////////////////
    // logic [3:0] mem2proc_response;// 0 = can't accept, other=tag of transaction
    // logic [63:0] mem2proc_data;    // data resulting from a load
    // logic [3:0] mem2proc_tag;     // 0 = no value, other=tag of transaction
    // //////////from arbiter////////////
    // logic [`MSHR_Depth-1:0] gnt_bus;
	
	// OUTPUT
	// logic [`LOAD_IB_Depth-1:0]load_SQ_tail_to_rs_valid; //load to rs ready bit if all store are valid from head and saved sq tail 
    logic [`N_way-1:0][`SQ_LEN:0]SQ_tail_rs;        //To RS dispatch
    //ROB//////////////////////////////////////////
    logic [`ROB_LEN:0]ROB_store_tail_ready; //To ROB to write store ready bit
    logic ROB_store_tail_valid;
    logic [`N_way-1:0] [`ROB_LEN:0]ROB_tail_rs;
    // //BRAT//////////////////////////////////////////
    // logic [`N_way-1][`SQ_LEN:0]SQ_tail_BRAT;             //To BRAT
    //ex////////////////////////////////////////
    // EX_COM_PACKET ex_out_packet_load_new; //with load address forwarding
    // logic load_hit_sq;
    // logic stop_is_en_mshr;
    // ///To Issue Buffer
    // logic stop_is_en;

    //To execute
    // EX_COM_PACKET ex_ld_packet_to_ex;
    // logic  ld_Dcache_hit_out;

    // // To dispatch
    // logic  [`SQ_LEN:0] sq_available_num;
    // SQ_PACKET [`SQ_size-1:0]store_queue; //For print
    // //--------------------output for memory----------------------------------------//
    // logic [`XLEN-1:0] proc2mem_addr_out;    // address for current command
    // logic [63:0] proc2mem_data_out;    // address for current command
    // BUS_COMMAND   proc2mem_command_out;
    // //--------------------output for arbiter--------------------------------------//
    // logic [`MSHR_Depth-1:0] request_bus;
	// D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] d_cache;
	// //for print
	// MSHR_ENTRY[`MSHR_Depth:1] mshr;

    logic halt_flag;
    always_comb begin
        halt_flag = 0;
        for(int i=0;i<`N_way;i++)begin
            //D cache lsq
            lsq_in_packet[i].Dispatch_enable = dp_rs_packet_in[i].valid;
            lsq_in_packet[i].inst = dp_rs_packet_in[i].inst;
            lsq_in_packet[i].is_branch = dp_rs_packet_in[i].is_branch;
            lsq_in_packet[i].rd_mem = dp_rs_packet_in[i].rd_mem;
            lsq_in_packet[i].wr_mem = dp_rs_packet_in[i].wr_mem;
            lsq_in_packet[i].halt = dp_rs_packet_in[i].halt;
            lsq_in_packet[i].illegal = dp_rs_packet_in[i].illegal;
            lsq_in_packet[i].csr_op = dp_rs_packet_in[i].csr_op;
            lsq_in_packet[i].valid = dp_rs_packet_in[i].valid;
            lsq_in_packet[i].NPC = dp_rs_packet_in[i].NPC;
            lsq_in_packet[i].PC = dp_rs_packet_in[i].PC;
            lsq_in_packet[i].is_b_mask = dp_rs_packet_in[i].b_mask_in;
            lsq_in_packet[i].b_mask_bit_branch = dp_rs_packet_in[i].b_mask_bit_branch;

            
            //update freelist in BRAT
            Rd_old_Preg_BRAT[i] = rob_out_packet[i].Rd_old_Preg_RRAT;
            //rob in
            rob_in_packet[i].Rd_old_Preg_RAT = rat_out_packet[i].Rd_old_Preg_ROB;
            rob_in_packet[i].Rd_Preg_Freelist = freelist_out_packet[i].Rd_Preg_out;
            rob_in_packet[i].Dispatch_enable = dispatch_in_packet[i].Dispatch_enable;//FROM dispatch
            rob_in_packet[i].Rd_Preg_CDB = cdb_connectedrob_in_packet[i].Rd_Preg_CDB;
            rob_in_packet[i].Rd_Preg_CDB_valid = cdb_connectedrob_in_packet[i].Rd_Preg_ready_bit_CDB;
            rob_in_packet[i].ROB_tail = cdb_connectedrob_in_packet[i].ROB_tail;
            rob_in_packet[i].Rd_Preg_value = cdb_connectedrob_in_packet[i].Preg_result;
            rob_in_packet[i].inst = dispatch_in_packet[i].inst;
            rob_in_packet[i].Rd_Areg = dispatch_in_packet[i].Rd_Areg;

            rob_in_packet[i].is_branch = dispatch_in_packet[i].is_branch;
            rob_in_packet[i].rd_mem  = dispatch_in_packet[i].rd_mem;
    		rob_in_packet[i].wr_mem   = dispatch_in_packet[i].wr_mem;
            rob_in_packet[i].cond_branch = dispatch_in_packet[i].cond_branch;
			rob_in_packet[i].uncond_branch = dispatch_in_packet[i].uncond_branch;
			rob_in_packet[i].csr_op = dispatch_in_packet[i].csr_op;
			rob_in_packet[i].halt = dispatch_in_packet[i].halt;
			rob_in_packet[i].illegal = dispatch_in_packet[i].illegal;
			rob_in_packet[i].valid = dispatch_in_packet[i].valid;
			rob_in_packet[i].NPC  = dispatch_in_packet[i].NPC;
    		rob_in_packet[i].PC   = dispatch_in_packet[i].PC;


            //rob out output
            branch_tail[i] = rob_out_packet[i].branch_tail;

            //rrat in
            rrat_in_packet[i].Rd_old_Preg_ROB = rob_out_packet[i].Rd_old_Preg_RRAT;  //FROM ROB to RRAT
            rrat_in_packet[i].Rd_Preg_ROB = rob_out_packet[i].Rd_Preg_RRAT; 
            rrat_in_packet[i].Retire_enable = rob_out_packet[i].Retire_enable;

            //freelist in
            freelist_in_packet[i].Rd_old_Preg_ROB = rob_out_packet[i].Rd_old_Preg_RRAT;  //From ROB to Freelist
            freelist_in_packet[i].Retire_enable = rob_out_packet[i].Retire_enable;
            freelist_in_packet[i].Dispatch_enable = dispatch_in_packet[i].Dispatch_enable;//FROM dispatch
            freelist_in_packet[i].Dispatch_Rd_available = dispatch_in_packet[i].Dispatch_Rd_available;
            freelist_in_packet[i].is_branch = dispatch_in_packet[i].is_branch;
            freelist_in_packet[i].Rd_Areg = dispatch_in_packet[i].Rd_Areg;
            //rat in
            rat_in_packet[i].Rs1_Areg = dispatch_in_packet[i].Rs1_Areg;      //FROM dispatch
            rat_in_packet[i].Rs2_Areg = dispatch_in_packet[i].Rs2_Areg;//FROM dispatch
            rat_in_packet[i].Rd_Areg = dispatch_in_packet[i].Rd_Areg;//FROM dispatch
            rat_in_packet[i].Rd_Preg = freelist_out_packet[i].Rd_Preg_out; //from freelist
            rat_in_packet[i].Dispatch_enable = dispatch_in_packet[i].Dispatch_enable; //FROM dispatch
            rat_in_packet[i].is_branch = dispatch_in_packet[i].is_branch;
            rat_in_packet[i].Set_ready_bit = cdb_connectedrob_in_packet[i].Rd_Preg_CDB;
            rat_in_packet[i].Set_ready_bit_enable = cdb_connectedrob_in_packet[i].Rd_Preg_ready_bit_CDB;

            rs_preg1_in[i] = rat_out_packet[i].Rs1_Preg_RS;
            rs_preg2_in[i] = rat_out_packet[i].Rs2_Preg_RS;
            rs_preg1_ready_in[i] = rat_out_packet[i].Rs1_Preg_ready_RS;
            rs_preg2_ready_in[i] = rat_out_packet[i].Rs2_Preg_ready_RS;
            rs_p_rd_in[i] = freelist_out_packet[i].Rd_Preg_out; 
            ROB_tail_rs[i] = rob_out_packet[i].ROB_tail;

            rs_cdb_tag[i] = cdb_connectedrob_in_packet[i].Rd_Preg_CDB;
            rs_cdb_valid[i] = cdb_connectedrob_in_packet[i].Rd_Preg_ready_bit_CDB;
            halt_flag = halt_flag | ROB_retire_out[i].halt;
        end
    end

	Freelist freelist_ins(
		// Inputs
		.clock             (clock),
		.reset             (reset),
		.rollback_brat_en(BP_mispredicted_tail_valid),
	    .Freelist_table_BRAT(Freelist_table_BRAT),
		.head_BRAT(head_BRAT),
		.tail_BRAT(tail_BRAT),
		.freelist_in_packet(freelist_in_packet),
		.freelist_out_packet(freelist_out_packet),
		.Freelist_table(Freelist_table),
		.freelist_available_num_out(freelist_available_num_out),
		.head(freelist_head),
		.tail(freelist_tail),
		.freelist_available_num(freelist_available_num),
		.Freelist_table_to_BRAT(Freelist_table_to_BRAT),
		.freelist_head_to_BRAT(freelist_head_to_BRAT),
		.freelist_tail_to_BRAT(freelist_tail_to_BRAT)
	);


    RAT RAT_ins(
		// Inputs
		.clock             (clock),
		.reset             (reset),
		.rat_in_packet(rat_in_packet),
		.rollback_brat_en(BP_mispredicted_tail_valid),
		.rat_brat(rat_brat),
      	.rat_out_packet(rat_out_packet),
		.RAT_table(RAT_table),
		.RAT_table_to_BRAT(RAT_table_to_BRAT)
	);


    ROB ROB_ins(
		// Inputs
		.clock             (clock),
		.reset             (reset),
		.rob_in_packet(rob_in_packet),
		.BP_mispredicted_tail(BP_mispredicted_tail), //clear_en tail
        .BP_mispredicted_tail_valid(BP_mispredicted_tail_valid),  //clear_en
        .BP_notmispredicted_tail(BP_notmispredicted_tail), //clear_bit_en tail
        .BP_notmispredicted_tail_valid(BP_notmispredicted_tail_valid),//clear_bit_en
		.rob_out_packet(rob_out_packet),
		.ROB_table(ROB_table),
		.ROB_available_size_out(ROB_available_size_out),
		.head(ROB_head),
		.tail(ROB_tail),
		.ROB_available_size(ROB_available_size),
        .ROB_retire_out(ROB_retire_out),
        .ROB_store_tail_ready(ROB_store_tail_ready),
        .ROB_store_tail_valid(ROB_store_tail_valid)
	);



    RRAT RRAT_ins(
		// Inputs
		.clock             (clock),
		.reset             (reset),
		.rrat_in_packet(rrat_in_packet),
		.RRAT_table(RRAT_table)
	);




    rs_entry  rs_ins(
		// Inputs
		.clock             (clock),
		.reset             (reset),
        .dp_rs_packet_in(dp_rs_packet_in),                                //define in sys_def.sv
        .ROB_tail(ROB_tail_rs),
	///////////From maptable//////////////
        .preg1_in(rs_preg1_in),
        .preg2_in(rs_preg2_in),                             ///tag1,tag2 ///
        .preg1_ready_in(rs_preg1_ready_in),
        .preg2_ready_in(rs_preg2_ready_in),                                                      //if tag1,tage2 ready or not
        ////////////From freelist////////////
        .p_rd_in(rs_p_rd_in),                    //tag for rd which from freelist

        /////////From  CDB //////////////////
        .cdb_tag(rs_cdb_tag),				//from cdb, comparing tag with tag1 and tag2
        .cdb_valid(rs_cdb_valid),

        //////input from execution/////////////////

        .clean_brat_en(BP_mispredicted_tail_valid),              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
        .clean_brat_num(clean_brat_num),  //from brat
        .clean_bit_brat_en(BP_notmispredicted_tail_valid),          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
        .clean_bit_num_brat_ex(clean_bit_brat_num),  //which bit should clean when clean_bit_brat_en[i] is 1 
	//////input from issuebuffer/////////////////

        .issue_buffer_alu_avail(issue_buffer_alu_avail),									/// if alu and mul busy
        .issue_buffer_mul_avail(issue_buffer_mul_avail),
        .issue_buffer_load_avail(issue_buffer_load_avail),
    /////////////output//////////////////////
        .rs_out_table_print(rs_out_table),
        .rs_is_packet_out(rs_is_packet_out),             //issue to execution stage

        //////RS_full? //////
        .avail_rs(avail_rs),                      //  available numbers of entries in rs
        //sq/////////////
        .retire_head2rs_is(retire_head2rs_is),
        .retire_enable2rs_is(retire_enable2rs_is),
        .load_SQ_tail_to_rs_valid(load_SQ_tail_to_rs_valid), //input
        .SQ_tail_rs(SQ_tail_rs),
        .load_SQ_tail_to_SQ(rs_load_SQ_tail_to_SQ),         //output
		.load_SQ_tail_to_SQ_valid(rs_load_SQ_tail_to_SQ_valid),
        .halt_flag(halt_flag)

	);

    connected_lsq_dcache connected_lsq_dcache_0(
		// INPUT
		.clock(clock),
		.reset(reset),
		// .ld_valid(ld_valid),
		.ex_ld_packet_in(ex_ld_packet_in),
		.lsq_in_packet(lsq_in_packet),

		.load_SQ_tail_from_is(load_SQ_tail_from_is),  //from is
		.load_SQ_tail_from_is_valid(load_SQ_tail_from_is_valid),

        .load_SQ_tail_from_rs(rs_load_SQ_tail_to_SQ),  //from rs
		.load_SQ_tail_from_rs_valid(rs_load_SQ_tail_to_SQ_valid),

		.rat_out_packet(rat_out_packet),
		.rob_out_packet(rob_out_packet),
		.ROB_retire_out(ROB_retire_out),
		.SQ_BP_mispredicted_tail_valid(BP_mispredicted_tail_valid),
		.SQ_BP_mispredicted_tail(SQ_BP_mispredicted_tail),
		.ex_out_packet_store(ex_out_packet_store),

		.mem2proc_response(mem2proc_response),
		.mem2proc_data(mem2proc_data),
		.mem2proc_tag(mem2proc_tag),
		.gnt_bus(gnt_bus),
		
		.clean_brat_en(BP_mispredicted_tail_valid),
		.clean_brat_num(clean_brat_num),
		.clean_bit_brat_en(BP_notmispredicted_tail_valid),
		.clean_bit_num_brat_ex(clean_bit_brat_num),
		// OUTPUT
		.load_SQ_tail_to_is_valid(load_SQ_tail_to_is_valid),
        .load_SQ_tail_to_rs_valid(load_SQ_tail_to_rs_valid),


        .retire_head2rs_is(retire_head2rs_is),
        .retire_enable2rs_is(retire_enable2rs_is),
		.SQ_tail_rs(SQ_tail_rs),
		.ROB_store_tail_ready(ROB_store_tail_ready),
		.ROB_store_tail_valid(ROB_store_tail_valid),
		.SQ_tail_BRAT(SQ_tail_BRAT),
        .reset_sq(reset_sq),
		.ex_ld_packet_to_execute(ex_ld_packet_to_execute),
		// .load_hit_sq(load_hit_sq),
		// .stop_is_en_mshr(stop_is_en_mshr),
		.stop_is_en(stop_is_en),
        .stop_is_st_en(stop_is_st_en),

        .sq_memsize_stall(sq_memsize_stall),
        // .sq_memsize_stall_tmp(sq_memsize_stall_tmp),
		// .ex_ld_packet_to_ex(ex_ld_packet_to_ex),
		// .ld_Dcache_hit_out(ld_Dcache_hit_out),
		.sq_available_num(sq_available_num),
        .sq_empty(sq_empty), 
		.store_queue(store_queue),
		.proc2mem_addr_out(proc2mem_addr_out),
		.proc2mem_data_out(proc2mem_data_out),
		.proc2mem_command_out(proc2mem_command_out),
		.request_bus(request_bus),
		.mshr(mshr),
		.d_cache(d_cache),
        .stall_IS_MSHR(stall_IS_MSHR),
        .halt_flag(halt_flag)
        // .sq_empty(sq_empty)
	);

endmodule


`timescale 1ns/100ps
module connected_lsq_dcache(

    input clock,
    input reset,
    input halt_flag,
    ///////////from ex_stage////////////
    // input ld_valid,                                     //rd_mem

    input EX_COM_PACKET ex_ld_packet_in,
    //lsq///////
    input LSQ_IN_Packet [`N_way-1:0]lsq_in_packet,  //from dispatch

    //rs//////////////////////////////////////
    input [`LOAD_IB_Depth-1:0][`SQ_LEN:0]load_SQ_tail_from_is,   //load from rs to check ready
    input [`LOAD_IB_Depth-1:0]load_SQ_tail_from_is_valid,    //load from rs to check ready

    input [`RS_depth-1:0][`SQ_LEN:0]load_SQ_tail_from_rs,   //load from rs to check ready
    input [`RS_depth-1:0]load_SQ_tail_from_rs_valid,    //load from rs to check ready

    //RAT//////////////////////////////////////////
    input RAT_OUT_PACKET [`N_way-1:0] rat_out_packet,
    //ROB//////////////////////////////////////////
    input ROB_OUT_PACKET [`N_way-1:0] rob_out_packet,
    input ROB_RETIRE_PACKET [`N_way-1:0]ROB_retire_out,

    //BRAT//////////////////////////////////////////
    input SQ_BP_mispredicted_tail_valid,   //from BRAT  connected BP_mispredicted_tail_valid   pipeline clean_brat_en
    input [`SQ_LEN:0]SQ_BP_mispredicted_tail,  //from BRAT
    input reset_sq,

    ///ex/////////////////////////////////////////////
    input EX_COM_PACKET ex_out_packet_store,  //ALU packet for store
    
    
    // input EX_COM_PACKET ex_out_packet_load_lsq,

    ///MEM/////////////////////////////////////
    input [3:0] mem2proc_response,// 0 = can't accept, other=tag of transaction
    input [63:0] mem2proc_data,    // data resulting from a load
    input [3:0] mem2proc_tag,     // 0 = no value, other=tag of transaction
    //////////from arbiter////////////
    input [`MSHR_Depth-1:0] gnt_bus,

    // branch clean
    input   clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
    input [$clog2(`width_b_mask)-1:0]   clean_brat_num,  //from brat
    input  [`ALU_num-1:0]clean_bit_brat_en,          /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
    input	 [`ALU_num-1:0][$clog2(`width_b_mask)-1:0] clean_bit_num_brat_ex,  //which bit should clean when clean_bit_brat_en[i] is 1 


    //rs//////////////////////////////////////
    output logic [`LOAD_IB_Depth-1:0]load_SQ_tail_to_is_valid, //load to rs ready bit if all store are valid from head and saved sq tail 
    output logic [`RS_depth-1:0]load_SQ_tail_to_rs_valid,
    output logic [`N_way-1:0][`SQ_LEN:0]SQ_tail_rs,        //To RS dispatch
    output logic [`SQ_LEN:0]retire_head2rs_is,
    output logic retire_enable2rs_is,
    //ROB//////////////////////////////////////////
    output logic [`ROB_LEN:0]ROB_store_tail_ready, //To ROB to write store ready bit
    output logic ROB_store_tail_valid,
    //BRAT//////////////////////////////////////////
    output logic [`N_way-1:0][`SQ_LEN:0]SQ_tail_BRAT,             //To BRAT
    //ex////////////////////////////////////////
    // output EX_COM_PACKET ex_out_packet_load_new, //with load address forwarding
    // output logic load_hit_sq,
    // output logic stop_is_en_mshr,
    output logic sq_memsize_stall,
    // output logic sq_memsize_stall_tmp,
    ///To Issue Buffer
    output logic stop_is_en,
    output logic stop_is_st_en,

    //To execute
    // output  EX_COM_PACKET ex_ld_packet_to_ex,
    output  EX_COM_PACKET ex_ld_packet_to_execute,
    output logic  ld_Dcache_hit_out,

    // To dispatch
    output logic  [`SQ_LEN:0] sq_available_num,
    output logic sq_empty,
    
    output SQ_PACKET [`SQ_size-1:0]store_queue, //For print

    //--------------------output for memory----------------------------------------//
    output  logic [`XLEN-1:0] proc2mem_addr_out,    // address for current command
    output  logic [63:0] proc2mem_data_out,    // address for current command
    output  BUS_COMMAND   proc2mem_command_out,
    //--------------------output for arbiter--------------------------------------//
    output  logic [`MSHR_Depth-1:0] request_bus,
    // for print
    output MSHR_ENTRY[`MSHR_Depth:1] mshr,
    output D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] d_cache,
    output logic stall_IS_MSHR
    // output logic sq_empty
);
    logic load_hit_sq;
    // logic stop_is_en_mshr;
    logic [2*`XLEN-1:0]block_data_mshr_out;
    logic [`XLEN-1:0]  block_addr_mshr_out;
    logic dirty_mshr_out;
    logic mshr_out_valid;
    logic [$clog2(`MSHR_Depth):0]avail_MSHR;

    EX_COM_PACKET ex_ld_packet_to_ex;
    EX_COM_PACKET ex_out_packet_load_new;
    EX_COM_PACKET ex_ld_packet_to_mshr_out;
    EX_COM_PACKET ex_ld_packet_out;

    SQ_OUT_PACKET sq_packet_mshr_out;
    SQ_OUT_PACKET sq_out_packet;

    // logic  ld_Dcache_hit_out;
    logic st_Dcache_hit_out;
    logic ld_Dcache_miss_out;
    logic st_Dcache_miss_out;
    logic evicting_en_out;        // this block is dirty and need to write back to MEM
    logic [`XLEN-1:0]  evicting_addr_out;
    logic [2*`XLEN-1:0]  evicting_data_out;

    logic stop_sq_retire_en;
    logic ld_cache_hit_mask_mshr;
    logic st_cache_hit_mask_mshr;


// ex_out_packet_load_new //lsq    load_hit_sq
// ex_ld_packet_to_ex //d cache   ld_Dcache_hit_out
// ex_ld_packet_out //mshr   mshr_out_valid
    always_comb begin
        ex_ld_packet_to_execute = 0;
        if(load_hit_sq)begin
            ex_ld_packet_to_execute = ex_out_packet_load_new;
        end
        else if(ld_Dcache_hit_out)begin
            ex_ld_packet_to_execute = ex_ld_packet_to_ex;
        end
        else if(stall_IS_MSHR)
            ex_ld_packet_to_execute = ex_ld_packet_out;
    end

     LSQ lsq_0(.clock(clock), .reset(reset),.halt_flag(halt_flag),
        //dispatch//////////////////////////////////////
        .lsq_in_packet(lsq_in_packet),  //from dispatch
        .sq_available_num(sq_available_num),        //To brat
        .sq_empty(sq_empty),   //To dispatch
        //rs//////////////////////////////////////
        .load_SQ_tail_from_is(load_SQ_tail_from_is),   //load from rs to check ready
        .load_SQ_tail_from_is_valid(load_SQ_tail_from_is_valid),    //load from rs to check ready
        .load_SQ_tail_from_rs(load_SQ_tail_from_rs),   //load from rs to check ready
        .load_SQ_tail_from_rs_valid(load_SQ_tail_from_rs_valid),    //load from rs to check ready

        .load_SQ_tail_to_is_valid(load_SQ_tail_to_is_valid), //load to rs ready bit if all store are valid from head and saved sq tail 
        .load_SQ_tail_to_rs_valid(load_SQ_tail_to_rs_valid),
        .SQ_tail_rs(SQ_tail_rs),        //To RS dispatch
        .retire_head2rs_is(retire_head2rs_is),
        .retire_enable2rs_is(retire_enable2rs_is),
        //RAT//////////////////////////////////////////
        .rat_out_packet(rat_out_packet),
        //ROB//////////////////////////////////////////
        .rob_out_packet(rob_out_packet),
        .ROB_retire_out(ROB_retire_out),

        .ROB_store_tail_ready(ROB_store_tail_ready), //To ROB to write store ready bit
        .ROB_store_tail_valid(ROB_store_tail_valid),
        //BRAT//////////////////////////////////////////
        .SQ_BP_mispredicted_tail_valid(SQ_BP_mispredicted_tail_valid),   //from BRAT  connected BP_mispredicted_tail_valid   pipeline clean_brat_en
        .SQ_BP_mispredicted_tail(SQ_BP_mispredicted_tail),  //from BRAT
        .SQ_tail_BRAT(SQ_tail_BRAT),             //To BRAT
        .reset_sq(reset_sq),
        ///ex/////////////////////////////////////////////
        .ex_out_packet_store(ex_out_packet_store),  //ALU packet for store
        
        .ex_out_packet_load(ex_ld_packet_in),

        .ex_out_packet_load_new(ex_out_packet_load_new), //with load address forwarding
        //D Cache///////////////////////////////////
        .stop_sq_retire_en(stop_sq_retire_en),
        .load_hit_sq(load_hit_sq), // to lsq
        .sq_memsize_stall(sq_memsize_stall),
        // .sq_memsize_stall_tmp(sq_memsize_stall_tmp),

        .sq_out_packet(sq_out_packet), //store To D cache

        .store_queue(store_queue) //For print
        // .sq_empty(sq_empty)
    );


  

    Dcache dcache_0(
    //////////////input//////////////////
        .clock(clock), .reset(reset),
        ///////////from ex_stage////////////
        // input[`XLEN-1:0] ld_inst_addr,                         //store target address or load address
        // .ld_valid(ld_valid),                                     //rd_mem
        // input MEM_SIZE ld_mem_size,                         //inst.r.funct3
        .ex_ld_packet_in(ex_ld_packet_in),

        ///////////from LSQ///////////////
        // .lsq2Dcache_addr(lsq2Dcache_addr),
        // .lsq2Dcache_data(lsq2Dcache_data),
        // .lsq2st_valid(lsq2st_valid),
        // .st_mem_size(st_mem_size),                          //inst.r.funct3
        .sq_packet_in(sq_out_packet),
        .load_hit_sq(load_hit_sq),
        //////////from MSHR///////////////

        .block_data_mshr_in(block_data_mshr_out),
        .block_addr_mshr_in(block_addr_mshr_out),
        .dirty_mshr_in(dirty_mshr_out),
        .mshr_out_valid(mshr_out_valid),
        .avail_MSHR(avail_MSHR),
        .st_cache_hit_mask_mshr(st_cache_hit_mask_mshr),
        .ld_cache_hit_mask_mshr(ld_cache_hit_mask_mshr),
        /////////////output//////////////////////
        ///To mshr
        .ex_ld_packet_to_mshr_out(ex_ld_packet_to_mshr_out),
        .sq_packet_mshr_out(sq_packet_mshr_out),
        // .lsq2st_valid_mshr_out(lsq2st_valid_mshr_out),
        // .lsq2Dcache_addr_mshr_out(lsq2Dcache_addr_mshr_out),
        // .lsq2Dcache_data_mshr_out(lsq2Dcache_data_mshr_out),
        // .st_mem_size_mshr_out(st_mem_size_mshr_out),         

        .ld_Dcache_hit_out(ld_Dcache_hit_out),
        .st_Dcache_hit_out(st_Dcache_hit_out),
        .ld_Dcache_miss_out(ld_Dcache_miss_out),
        .st_Dcache_miss_out(st_Dcache_miss_out), 
        .evicting_en_out(evicting_en_out),         // this block is dirty and need to write back to MEM
        .evicting_addr_out(evicting_addr_out), 
        .evicting_data_out(evicting_data_out),
        //To execute
        .ex_ld_packet_to_ex(ex_ld_packet_to_ex), //hit
        //to lsq
        .stop_sq_retire_en(stop_sq_retire_en),
        //to issue buffer
        .stop_is_en(stop_is_en),
        .stop_is_st_en(stop_is_st_en),
        .d_cache(d_cache)
    );



 Dcache_ctrl Dcache_ctrl_0( ////////////////// include MSHR///////////////////
//////////////input//////////////
    .clock(clock), .reset(reset),

    ////////////from cache///////////////
    // input  ld_valid, 
    .ld_Dcache_hit(ld_Dcache_hit_out),   // load inst hit in the d cache
    .ld_Dcache_miss(ld_Dcache_miss_out),  // load inst miss in the d cache

    .ex_ld_packet2mshr(ex_ld_packet_in),


    .sq_packet2mshr(sq_out_packet),

    .ex_ld_packet_in(ex_ld_packet_to_mshr_out),
    .sq_packet_in(sq_packet_mshr_out),

    //.lsq2st_valid(lsq2st_valid),     //from cache !!
    .st_Dcache_hit(st_Dcache_hit_out),   // store inst hit in the d cache
    .st_Dcache_miss(st_Dcache_miss_out),  // storeinst miss in the d cache
    // .st_addr(st_addr),
    // .st_data(st_data),
    // .st_mem_size(st_mem_size),

    /////////from cache evicting/////////////
    .evicting_en(evicting_en_out),
    .evicting_addr(evicting_addr_out), 
    .evicting_data(evicting_data_out), 


    //.ld_Dcache_hit_data(ld_Dcache_hit_data),           ////cachemem_data

    ///////////from mem////////////////
    .mem2proc_response(mem2proc_response),// 0 = can't accept, other=tag of transaction
    .mem2proc_data(mem2proc_data),    // data resulting from a load
    .mem2proc_tag(mem2proc_tag),     // 0 = no value, other=tag of transaction
    //////////from arbiter////////////
    .gnt_bus(gnt_bus),
    .clean_brat_en(clean_brat_en),
    .clean_brat_num(clean_brat_num),
    .clean_bit_brat_en(clean_bit_brat_en),
    .clean_bit_num_brat_ex(clean_bit_num_brat_ex),



    // branch clean

    /////////////output//////////////
    //--------------------output to memory----------------------------------------//
    .proc2mem_addr_out(proc2mem_addr_out),    // address for current command
    .proc2mem_data_out(proc2mem_data_out),    // address for current command
    .proc2mem_command_out(proc2mem_command_out),
    //--------------------output to arbiter--------------------------------------//
    .request_bus(request_bus),                                  //output to arbiter 
    //--------------------output for ex in next cycle----------------------------//
    // output logic [`Preg_LEN-1:0]   ld_rd_preg_mshr_out,
    // output logic [`XLEN-1:0]    ld_value_mshr_out,
    .ex_ld_packet_out(ex_ld_packet_out),
    // .stop_is_en_mshr(stop_is_en_mshr),
    //------------------------full stall-----------------------------------------//
    .avail_MSHR(avail_MSHR),
    //--------------------output to d-cache----------------------------//
    .block_data_mshr_out(block_data_mshr_out),
    .block_addr_mshr_out(block_addr_mshr_out),
    .dirty_mshr_out(dirty_mshr_out),
    .mshr_out_valid(mshr_out_valid),
    .st_cache_hit_mask_mshr(st_cache_hit_mask_mshr),
    .ld_cache_hit_mask_mshr(ld_cache_hit_mask_mshr),
    .mshr(mshr),
    .stall_IS_MSHR(stall_IS_MSHR)
    );


endmodule
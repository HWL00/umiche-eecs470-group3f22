`timescale 1ns/100ps
 module Dcache_ctrl( ////////////////// include MSHR///////////////////
//////////////input//////////////
input clock,
input reset,
input EX_COM_PACKET ex_ld_packet2mshr,
input SQ_OUT_PACKET sq_packet2mshr,

////////////from cache/////////////// 
input  ld_Dcache_hit,   // load inst hit in the d cache
input  ld_Dcache_miss,  // load inst miss in the d cache

input EX_COM_PACKET ex_ld_packet_in,
input SQ_OUT_PACKET sq_packet_in,

input  st_Dcache_hit,   // store inst hit in the d cache
input  st_Dcache_miss,  // storeinst miss in the d cache

/////////from cache evicting/////////////
input evicting_en,
input [`XLEN-1:0]  evicting_addr, 
input [2*`XLEN-1:0]  evicting_data, 


///////////from mem////////////////
input [3:0] mem2proc_response,// 0 = can't accept, other=tag of transaction
input [63:0] mem2proc_data,    // data resulting from a load
input [3:0] mem2proc_tag,     // 0 = no value, other=tag of transaction
//////////from arbiter////////////
input [`MSHR_Depth-1:0] gnt_bus,

// branch clean
input   clean_brat_en,              ///  clean_brat_en is 1, delete everything in the pipeline which has that b_mask_bit
input [$clog2(`width_b_mask)-1:0]   clean_brat_num,  //from brat
input  [`ALU_num-1:0]clean_bit_brat_en,     //[3:0]     /// did not misprediction,we just set all ba_mask[last_b_mask_branch] to be 0
input	 [`ALU_num-1:0][$clog2(`width_b_mask)-1:0] clean_bit_num_brat_ex,  //which bit should clean when clean_bit_brat_en[i] is 1 

/////////////output//////////////
//--------------------output for memory----------------------------------------//
output  logic [`XLEN-1:0] proc2mem_addr_out,    // address for current command
output  logic [63:0] proc2mem_data_out,    // address for current command
output  BUS_COMMAND   proc2mem_command_out,
//--------------------output for arbiter--------------------------------------//
output  logic [`MSHR_Depth-1:0] request_bus,                                  //output to arbiter 
//--------------------output for ex in next cycle----------------------------//

output EX_COM_PACKET ex_ld_packet_out,
//------------------------full stall-----------------------------------------//
output logic [$clog2(`MSHR_Depth):0]avail_MSHR,
//--------------------output for d-cache----------------------------//
output logic [2*`XLEN-1:0] block_data_mshr_out,
output logic [`XLEN-1:0]  block_addr_mshr_out,
output logic dirty_mshr_out,
output logic mshr_out_valid,
output logic stall_IS_MSHR,
output logic st_cache_hit_mask_mshr,
output logic ld_cache_hit_mask_mshr,
//--FOR PRINT
output MSHR_ENTRY[`MSHR_Depth:1] mshr

);
// MSHR_FSM state,nx_state;
// logic[`MSHR_Depth-1:0] request_bus;
EXAMPLE_CACHE_BLOCK cache_type;

logic nx_stall_IS_MSHR;
logic load_index_depend_en;
logic store_index_depend_en;
logic[$clog2(`MSHR_Depth):0] load_link_entry_num;
logic[$clog2(`MSHR_Depth):0] store_link_entry_num;
logic[$clog2(`MSHR_Depth):0] evict_link_entry_num;
MSHR_ENTRY[`MSHR_Depth:1] nx_mshr;

logic store_addr_depend_en;
logic load_addr_depend_en;
logic evict_addr_depend_en;

logic [`MSHR_Depth:1][`XLEN-1:0] pre_proc2mem_addr_out;    // address for current command
logic [`MSHR_Depth:1][63:0] pre_proc2mem_data_out;    // address for current command
BUS_COMMAND [`MSHR_Depth:1]   pre_proc2mem_command_out;

logic evict_wr_en;
logic store_wr_en;
logic load_wr_en;

 logic[$clog2(`MSHR_Depth):0] wr_mshr_pointer;
 logic[$clog2(`MSHR_Depth):0] wr_mshr_pointer_evict;
 logic[$clog2(`MSHR_Depth):0] wr_mshr_pointer_st;
 logic[$clog2(`MSHR_Depth):0] wr_mshr_pointer_ld;

logic[$clog2(`MSHR_Depth):0] complete_entry;
// logic [`MSHR_Depth:1][15:0]evict_counter,nx_evict_counter;
MSHR_IN_PACKET [2:0] mshr_in_packet;

logic st_evict_hit;
logic ld_evict_hit;
// logic [`XLEN-1:0]st_data_tmp;
///////////////////writing////////////////////////////// 
always_comb begin
    st_evict_hit = 0;
    ld_evict_hit = 0;

    mshr_in_packet = 0;
    //evicting
    mshr_in_packet[0].valid = evicting_en;
    mshr_in_packet[0].alu_result = evicting_addr;
    mshr_in_packet[0].evict_data = evicting_data;
    mshr_in_packet[0].rs2_value = 0;
    mshr_in_packet[0].index_addr = mshr_in_packet[0].alu_result[`Cache_Index+`block_offset_bit-1:`block_offset_bit];
    mshr_in_packet[0].tag_addr = mshr_in_packet[0].alu_result[`XLEN-1:`Cache_Index+`block_offset_bit];
    //store
    mshr_in_packet[1].valid = sq_packet_in.address_value_valid;
    mshr_in_packet[1].wr_mem = sq_packet_in.wr_mem;
    mshr_in_packet[1].alu_result = sq_packet_in.store_address;
    mshr_in_packet[1].rs2_value = sq_packet_in.value;
    mshr_in_packet[1].evict_data = 0;
    mshr_in_packet[1].inst = sq_packet_in.inst;
    mshr_in_packet[1].NPC = sq_packet_in.NPC;
    // mshr_in_packet[1].PC = sq_packet_in.PC;

    mshr_in_packet[1].rd_mem = sq_packet_in.rd_mem;
    mshr_in_packet[1].mem_size = sq_packet_in.mem_size;
    mshr_in_packet[1].index_addr = mshr_in_packet[1].alu_result[`Cache_Index+`block_offset_bit-1:`block_offset_bit];
    mshr_in_packet[1].tag_addr = mshr_in_packet[1].alu_result[`XLEN-1:`Cache_Index+`block_offset_bit];

    //load

    mshr_in_packet[2].alu_result = ex_ld_packet_in.alu_result;
    mshr_in_packet[2].NPC = ex_ld_packet_in.NPC;
    mshr_in_packet[2].take_branch = ex_ld_packet_in.take_branch;
    mshr_in_packet[2].inst = ex_ld_packet_in.inst;
    mshr_in_packet[2].rs2_value = ex_ld_packet_in.rs2_value;
    mshr_in_packet[2].evict_data = 0;
    mshr_in_packet[2].rd_mem = ex_ld_packet_in.rd_mem;

    mshr_in_packet[2].wr_mem = ex_ld_packet_in.wr_mem;
    mshr_in_packet[2].dest_reg_idx = ex_ld_packet_in.dest_reg_idx;
    mshr_in_packet[2].halt = ex_ld_packet_in.halt;
    mshr_in_packet[2].illegal = ex_ld_packet_in.illegal;
    mshr_in_packet[2].csr_op = ex_ld_packet_in.csr_op;
    mshr_in_packet[2].valid = ex_ld_packet_in.valid;
    mshr_in_packet[2].mem_size = ex_ld_packet_in.mem_size;
    mshr_in_packet[2].is_b_mask = ex_ld_packet_in.is_b_mask;
    mshr_in_packet[2].b_mask_bit_branch = ex_ld_packet_in.b_mask_bit_branch;
    mshr_in_packet[2].SQ_tail = ex_ld_packet_in.SQ_tail;
    mshr_in_packet[2].ROB_tail = ex_ld_packet_in.ROB_tail;
    mshr_in_packet[2].index_addr = mshr_in_packet[2].alu_result[`Cache_Index+`block_offset_bit-1:`block_offset_bit];
    mshr_in_packet[2].tag_addr = mshr_in_packet[2].alu_result[`XLEN-1:`Cache_Index+`block_offset_bit];

    if(mshr_in_packet[2].alu_result[31:3] == mshr_in_packet[0].alu_result[31:3] && mshr_in_packet[2].valid && mshr_in_packet[0].valid)begin
        ld_evict_hit = 1;
    end
    if(mshr_in_packet[1].alu_result[31:3] == mshr_in_packet[0].alu_result[31:3] && mshr_in_packet[1].valid && mshr_in_packet[0].valid)begin
        st_evict_hit = 1;
    end
    //    if(ex_ld_packet_in.rd_mem)begin    //if this ld inst
    //     load_index_addr=ex_ld_packet_in.alu_result[`Cache_Index+`block_offset_bit-1:`block_offset_bit];
    //     load_tag_addr=ex_ld_packet_in.alu_result[`XLEN-1:`Cache_Index+`block_offset_bit];
    // end
    // if(sq_packet_in.address_value_valid)begin
    //     store_index_addr=sq_packet_in.store_address[`Cache_Index+`block_offset_bit-1:`block_offset_bit];
    //     store_tag_addr=sq_packet_in.store_address[`XLEN-1:`Cache_Index+`block_offset_bit];
    // end
    // if(evicting_en)begin
    //     evict_index_addr=evicting_addr[`Cache_Index+`block_offset_bit-1:`block_offset_bit];
    //     evict_tag_addr=evicting_addr[`XLEN-1:`Cache_Index+`block_offset_bit];
    // end

end
// logic[`Cache_Index-1:0] current_index;
// logic[`XLEN-1:lsb_Cache_tag] current_tag;
// logic changed_addr;
// assign{current_tag,current_index } = proc2Dcache_addr[`XLEN-1:offset];
always_ff @(posedge clock)begin
    if(reset)begin
        mshr<= `SD 'd0;
        stall_IS_MSHR<=`SD 0;
        // for(int i=1;i<`MSHR_Depth+1;i++) begin
        //     evict_counter[i] <= `SD `MEM_LATENCY_IN_CYCLES; 
        // end
    end
    else begin
        mshr<= `SD nx_mshr;
        stall_IS_MSHR<=`SD nx_stall_IS_MSHR;
        // for(int i=1;i<`MSHR_Depth+1;i++) begin
        //     if(nx_evict_counter[i]==0)begin
        //         evict_counter[i] <= `SD`MEM_LATENCY_IN_CYCLES;
        //     end
        //     else begin
        //         evict_counter[i] <= `SD nx_evict_counter[i] - 1;
        //     end
        // end
        
    end
end

always_comb begin
    nx_mshr=mshr;

    wr_mshr_pointer_ld = 0;
    wr_mshr_pointer_st = 0;
    wr_mshr_pointer_evict = 0;
    load_addr_depend_en=1'b0;
    store_addr_depend_en=1'b0;
    evict_addr_depend_en = 1'b0;
    load_index_depend_en=1'b0;
    store_index_depend_en=1'b0;
    // link_entry_num='d0;
    // evict_link_entry_num = 'd0;
    pre_proc2mem_addr_out='d0;
    pre_proc2mem_data_out='d0;
    pre_proc2mem_command_out='d0;
    store_wr_en = 1'b1;
    load_wr_en = 1'b1;
    evict_wr_en = 1'b1;
    // stop_is_en_mshr = 1'b0;
    block_addr_mshr_out = 0;
    block_data_mshr_out = 0;
    dirty_mshr_out = 0;
    mshr_out_valid = 0;

    load_link_entry_num = 0;
    store_link_entry_num= 0;
    evict_link_entry_num= 0;
    
    ex_ld_packet_out = 0;
    proc2mem_command_out = 0;
    proc2mem_data_out = 0;
    proc2mem_addr_out = 0;
    request_bus = 0;
    wr_mshr_pointer=0;


     nx_stall_IS_MSHR = 0;
    //  st_data_tmp = 0;
    

    if(clean_brat_en)begin
        for(int i=1; i<`MSHR_Depth+1; i=i+1)begin
            if(nx_mshr[i].is_b_mask[clean_brat_num])begin
                nx_mshr[nx_mshr[i].link_entry].linked_idx_en=1'b0;
                nx_mshr[nx_mshr[i].link_entry].linked_addr_en=1'b0;
                nx_mshr[i]=0;
                
            end
        end
    end

    for(int j=0;j<`ALU_num;j=j+1)begin 
        if(clean_bit_brat_en[j])begin 
            for(int i=1; i<`MSHR_Depth+1; i=i+1)begin
                nx_mshr[i].is_b_mask[clean_bit_num_brat_ex[j]]=1'b0;
            end
        end
    end
    // st_cache_hit_mask_mshr = 0;
    // ld_cache_hit_mask_mshr = 0;

    // ///check hit in mshr/////////////////////////////////////////////
    // for(int i=0; i<`MSHR_Depth;i++)begin
    //     if(nx_mshr[i].MSHR_state!=STORE_COMPLETE && nx_mshr[i].MSHR_addr[`XLEN-1:3]==sq_packet2mshr.store_address[`XLEN-1:3] && nx_mshr[i].valid)begin
    //         st_cache_hit_mask_mshr = 1;
    //         break;
            
    //     end

    //     // if(nx_mshr[i].MSHR_state!=LOAD_COMPLETE && nx_mshr[i].MSHR_addr[`XLEN-1:3]==ex_ld_packet2mshr.alu_result[`XLEN-1:3]&& nx_mshr[i].valid)begin
    //     //     ld_cache_hit_mask_mshr = 1;
    //     // end
    // end

    // for(int i=0; i<`MSHR_Depth;i++)begin
    //     // if(nx_mshr[i].MSHR_state!=STORE_COMPLETE && nx_mshr[i].MSHR_addr[`XLEN-1:3]==sq_packet2mshr.store_address[`XLEN-1:3] && nx_mshr[i].valid)begin
    //     //     st_cache_hit_mask_mshr = 1;
            
    //     // end

    //     if(nx_mshr[i].MSHR_state!=LOAD_COMPLETE && nx_mshr[i].MSHR_addr[`XLEN-1:3]==ex_ld_packet2mshr.alu_result[`XLEN-1:3] && nx_mshr[i].valid)begin //&& nx_mshr[i].valid
    //         ld_cache_hit_mask_mshr = 1;
    //         break;
    //     end
    // end
/////////////output///////////////////////////
//request////////////////////////////////////////////////////////////////////
    for(int i=`MSHR_Depth; i>0;i--)begin
        case(nx_mshr[i].MSHR_state )
                LOAD_MISS_WAITTING_BUS:     begin                     
                                                    request_bus[i-1]=1'b1;
                                                    pre_proc2mem_addr_out[i]= {nx_mshr[i].MSHR_addr[`XLEN-1:3],3'd0};
                                                    pre_proc2mem_command_out[i]= nx_mshr[i].CMD;
                                                    pre_proc2mem_data_out[i] = 0;
                                            end

                STORE_MISS_WAITTING_BUS:    begin     
                                                    request_bus[i-1]=1'b1;
                                                    pre_proc2mem_addr_out[i]= {nx_mshr[i].MSHR_addr[`XLEN-1:3],3'd0};
                                                    pre_proc2mem_command_out[i]= nx_mshr[i].CMD;
                                                    pre_proc2mem_data_out[i] = 0;
                                            end
                WAIT_EVICT              :   begin  
                                                    request_bus[i-1]=1'b1;
                                                    pre_proc2mem_addr_out[i]= {nx_mshr[i].MSHR_addr[`XLEN-1:3],3'd0};
                                                    pre_proc2mem_command_out[i]= nx_mshr[i].CMD;
                                                    pre_proc2mem_data_out[i]= nx_mshr[i].MSHR_data;       
                                            end
        endcase
    end

      
    for(int i=`MSHR_Depth;i>0;i--)begin
        if(gnt_bus[i-1]) begin
            proc2mem_command_out = pre_proc2mem_command_out[i];
            proc2mem_addr_out = pre_proc2mem_addr_out[i];
            proc2mem_data_out = pre_proc2mem_data_out[i];
        end
    end
/////////////output///////////////////////////
    complete_entry = 0;
    for(int i=`MSHR_Depth;i>0;i--)begin
        case(nx_mshr[i].MSHR_state)//change to last mshr_state. stall ld of Issue buffer issue
            LOAD_COMPLETE:begin
                complete_entry = i;
                block_addr_mshr_out = nx_mshr[i].MSHR_addr;
                block_data_mshr_out = nx_mshr[i].MSHR_data;
                dirty_mshr_out = nx_mshr[i].dirty;
                mshr_out_valid = 1;
                // stall_IS_MSHR = 1;
                ex_ld_packet_out.dest_reg_idx = nx_mshr[i].ld_rd_preg;
                cache_type.byte_level = nx_mshr[i].MSHR_data;
                cache_type.half_level = nx_mshr[i].MSHR_data;
                cache_type.word_level = nx_mshr[i].MSHR_data;
                case (nx_mshr[i].size_type)
                        BYTE: begin
							ex_ld_packet_out.alu_result = {24'b0, cache_type.byte_level[nx_mshr[i].MSHR_addr[2:0]]};
                        end
                        HALF: begin
							ex_ld_packet_out.alu_result = {16'b0, cache_type.half_level[nx_mshr[i].MSHR_addr[2:1]]};
                        end
                        WORD: begin
							ex_ld_packet_out.alu_result=  cache_type.word_level[nx_mshr[i].MSHR_addr[2]];
                        end
                        default:begin
							ex_ld_packet_out.alu_result =  cache_type.word_level[nx_mshr[i].MSHR_addr[2]];
                        end
					endcase
                ex_ld_packet_out.take_branch = nx_mshr[i].take_branch;
                ex_ld_packet_out.rs2_value= nx_mshr[i].rs2_value;
                ex_ld_packet_out.rd_mem= nx_mshr[i].rd_mem;
                ex_ld_packet_out.wr_mem= nx_mshr[i].wr_mem;
                ex_ld_packet_out.halt= nx_mshr[i].halt;
                ex_ld_packet_out.illegal= nx_mshr[i].illegal;
                ex_ld_packet_out.csr_op= nx_mshr[i].csr_op;
                ex_ld_packet_out.valid= nx_mshr[i].valid;
                ex_ld_packet_out.is_b_mask= nx_mshr[i].is_b_mask;
                ex_ld_packet_out.b_mask_bit_branch= nx_mshr[i].b_mask_bit_branch;
                ex_ld_packet_out.NPC = nx_mshr[i].NPC;
                ex_ld_packet_out.inst = nx_mshr[i].inst;
                ex_ld_packet_out.mem_size = nx_mshr[i].size_type;
                ex_ld_packet_out.ROB_tail = nx_mshr[i].ROB_tail;
                // stop_is_en_mshr = 1'b1;
                nx_mshr[i]='d0;
                nx_mshr[i].MSHR_state=IDLE;
                break;
            end
            STORE_COMPLETE:begin
                complete_entry = i;
                cache_type.byte_level = nx_mshr[i].MSHR_data;
                cache_type.half_level = nx_mshr[i].MSHR_data;
                cache_type.word_level = nx_mshr[i].MSHR_data;
                block_addr_mshr_out = nx_mshr[i].MSHR_addr;
                dirty_mshr_out = 1;
                mshr_out_valid = 1;
                case (nx_mshr[i].size_type) 
                        BYTE: begin
                            cache_type.byte_level[nx_mshr[i].MSHR_addr[2:0]] = nx_mshr[i].st_data[7:0];
                            block_data_mshr_out = cache_type.byte_level;
                        end
                        HALF: begin
                            // assert(sq_packet_in.store_address[0] == 0);
                            cache_type.half_level[nx_mshr[i].MSHR_addr[2:1]] = nx_mshr[i].st_data[15:0];
                            block_data_mshr_out = cache_type.half_level;
                        end
                        WORD: begin
                            // assert(sq_packet_in.store_address[1:0] == 0);
                            cache_type.word_level[nx_mshr[i].MSHR_addr[2]] = nx_mshr[i].st_data[31:0];
                            block_data_mshr_out = cache_type.word_level;
                        end
                        default: begin
                            // assert(sq_packet_in.store_address[1:0] == 0);
                            cache_type.byte_level[nx_mshr[i].MSHR_addr[2]] = nx_mshr[i].st_data[31:0];
                            block_data_mshr_out = cache_type.word_level;
                        end
                endcase
                nx_mshr[i]='d0;
                nx_mshr[i].MSHR_state=IDLE;
                break;
                
            end
            EVICT_COMPLETE:begin
                complete_entry = i;
                nx_mshr[i]='d0;
                nx_mshr[i].MSHR_state=IDLE;
                break;

            end
        endcase
        mshr_out_valid = 0;
    end
    avail_MSHR = 'd0;
    for (int i=1 ; i<`MSHR_Depth+1; i=i+1)begin
        if(!nx_mshr[i].mshr_valid)begin
            avail_MSHR = avail_MSHR + 1'b1;
        end

    end
    avail_MSHR = (avail_MSHR>'d3)?'d3:avail_MSHR;


    st_cache_hit_mask_mshr = 0;
    ld_cache_hit_mask_mshr = 0;

    ///check hit in mshr/////////////////////////////////////////////
    for(int i=1; i<`MSHR_Depth+1;i++)begin
        if(nx_mshr[i].MSHR_addr[`XLEN-1:3]==sq_packet2mshr.store_address[`XLEN-1:3] && nx_mshr[i].mshr_valid)begin
            st_cache_hit_mask_mshr = 1;
            break;
            
        end
    end

    for(int i=1; i<`MSHR_Depth+1;i++)begin
        if(nx_mshr[i].MSHR_addr[`XLEN-1:3]==ex_ld_packet2mshr.alu_result[`XLEN-1:3] && nx_mshr[i].mshr_valid)begin //&& nx_mshr[i].valid
            ld_cache_hit_mask_mshr = 1;
            break;
        end
    end

///////////////////FSM//////////////////////////////    
 
    // nx_evict_counter = evict_counter;

    for(int i=`MSHR_Depth; i>0;i--)begin
        case(nx_mshr[i].MSHR_state )
                LOAD_MISS_WAITTING_BUS:     begin                     
                                                if(gnt_bus[i-1] && mem2proc_response!=0)begin
                                                    nx_mshr[i].MSHR_state=LOAD_MISS_IN_USE;
                                                    nx_mshr[i].mem_tag=mem2proc_response;
                                                    nx_mshr[i].linked_idx_en = 1'b0;
                                                end 
                                            end

                STORE_MISS_WAITTING_BUS:    begin     
                                                if(gnt_bus[i-1] && mem2proc_response!=0)begin
                                                    nx_mshr[i].MSHR_state=STORE_MISS_IN_USE;
                                                    nx_mshr[i].mem_tag=mem2proc_response;
                                                    nx_mshr[i].linked_idx_en = 1'b0;
                                                end 
                                            end
                
                
                LOAD_MISS_IN_USE        :   begin   
                                                if(nx_mshr[i].mem_tag == mem2proc_tag && mem2proc_tag !=0)begin
                                                    nx_mshr[i].MSHR_state=LOAD_COMPLETE;
                                                    nx_mshr[i].linked_addr_en = 1'b0;
                                                    nx_mshr[i].linked_idx_en = 1'b0;
                                                    nx_mshr[i].mem_tag='d0;
                                                    nx_mshr[i].MSHR_data=mem2proc_data;
                                                end
                                                else begin
                                                    nx_mshr[i].MSHR_state=LOAD_MISS_IN_USE;
                                                    nx_mshr[i].MSHR_data='d0;
                                                end
                                            end               
                STORE_MISS_IN_USE       :   begin

                                                if(nx_mshr[i].mem_tag == mem2proc_tag && mem2proc_tag !=0)begin
                                                    nx_mshr[i].MSHR_state=STORE_COMPLETE;
                                                    nx_mshr[i].linked_addr_en = 1'b0;
                                                    nx_mshr[i].linked_idx_en = 1'b0;
                                                    nx_mshr[i].mem_tag='d0;
                                                    nx_mshr[i].MSHR_data=mem2proc_data;
                                                end
                                                else begin
                                                    nx_mshr[i].MSHR_state=STORE_MISS_IN_USE;
                                                    nx_mshr[i].mem_tag=nx_mshr[i].mem_tag;
                                                    nx_mshr[i].MSHR_data='d0;
                                                end
                                            end


                LOAD_COMPLETE           :   begin
                                                
                                                if(nx_mshr[i].linked_idx_en)begin
                                                    for(int j=1; j<`MSHR_Depth+1;j++)begin
                                                        if(nx_mshr[j].link_entry==i)begin
                                                            nx_mshr[i].linked_idx_en=1'b0;                                                            
                                                        end
                                                    end

                                                end

                                              
                                            end

                STORE_COMPLETE          :   begin
                                                if(nx_mshr[i].linked_idx_en)begin
                                                    for(int j=1; j<`MSHR_Depth+1;j++)begin
                                                        if(nx_mshr[j].link_entry==i)begin
                                                            nx_mshr[i].linked_idx_en=1'b0;                                                            
                                                        end
                                                    end

                                                end

                                                
                                            end
                
                WAIT_EVICT              :   begin  
                                                if(gnt_bus[i-1] && mem2proc_response!=0)begin
                                                    nx_mshr[i].MSHR_state = EVICT_COMPLETE;
                                                    // nx_mshr[i].MSHR_state=EVICTING;
                                                    // nx_mshr[i].mem_tag=mem2proc_response;
                                                    // nx_evict_counter[i] = `MEM_LATENCY_IN_CYCLES; 
                                                end 
                                            end

                EVICTING                :   begin
                                                nx_mshr[i].MSHR_state=EVICT_COMPLETE;
                                                // if(nx_mshr[i].mem_tag == mem2proc_tag)begin
                                                // if(nx_evict_counter[i]==0)begin
                                                //     nx_mshr[i].MSHR_state=EVICT_COMPLETE;
                                                //     nx_mshr[i].linked_addr_en = 1'b0;
                                                //     nx_mshr[i].linked_idx_en = 1'b0;
                                                //     nx_mshr[i].mem_tag='d0;
                                                    
                                                // end
                                                // else begin
                                                //     nx_mshr[i].MSHR_state=EVICTING;
                                                //     // nx_mshr[i].MSHR_data='d0;
                                                // end
                                            end

                EVICT_COMPLETE          :   begin
                                                if(nx_mshr[i].linked_idx_en)begin
                                                    for(int j=1; j<`MSHR_Depth+1;j++)begin
                                                        if(nx_mshr[j].link_entry==i)begin
                                                            nx_mshr[i].linked_idx_en=1'b0;                                                            
                                                        end
                                                    end
                                                end
                                                // nx_mshr[i]='d0;
                                                // nx_mshr[i].MSHR_state=IDLE;

                                            end



                ADDR_DEPEND             :   begin   
                                                // if(nx_mshr[i].link_entry!=0)begin
                                                    if(nx_mshr[nx_mshr[i].link_entry].linked_addr_en==0)begin
                                                        if(nx_mshr[i].if_load) begin
                                                            nx_mshr[i].MSHR_state=LOAD_COMPLETE;
                                                            nx_mshr[i].linked_addr_en=0;
                                                            nx_mshr[i].linked_idx_en=0;
                                                            nx_mshr[i].dirty=nx_mshr[nx_mshr[i].link_entry].dirty;
                                                            if(nx_mshr[nx_mshr[i].link_entry].if_store)begin
                                                                cache_type.byte_level = nx_mshr[nx_mshr[i].link_entry].MSHR_data;
                                                                cache_type.half_level = nx_mshr[nx_mshr[i].link_entry].MSHR_data;
                                                                cache_type.word_level = nx_mshr[nx_mshr[i].link_entry].MSHR_data;
                                                                case (nx_mshr[nx_mshr[i].link_entry].size_type) 
                                                                        BYTE: begin
                                                                            cache_type.byte_level[nx_mshr[nx_mshr[i].link_entry].MSHR_addr[2:0]] = nx_mshr[nx_mshr[i].link_entry].st_data[7:0];
                                                                            nx_mshr[i].MSHR_data = cache_type.byte_level;
                                                                        end
                                                                        HALF: begin
                                                                            cache_type.half_level[nx_mshr[nx_mshr[i].link_entry].MSHR_addr[2:1]] = nx_mshr[nx_mshr[i].link_entry].st_data[15:0];
                                                                            nx_mshr[i].MSHR_data = cache_type.half_level;
                                                                        end
                                                                        WORD: begin
                                                                            cache_type.word_level[nx_mshr[nx_mshr[i].link_entry].MSHR_addr[2]] = nx_mshr[nx_mshr[i].link_entry].st_data[31:0];
                                                                            nx_mshr[i].MSHR_data = cache_type.word_level;
                                                                        end
                                                                        default: begin
                                                                            cache_type.byte_level[nx_mshr[nx_mshr[i].link_entry].MSHR_addr[2]] = nx_mshr[nx_mshr[i].link_entry].st_data[31:0];
                                                                            nx_mshr[i].MSHR_data = cache_type.word_level;
                                                                        end
                                                                endcase
                                                            end
                                                            else begin
                                                                nx_mshr[i].MSHR_data=nx_mshr[nx_mshr[i].link_entry].MSHR_data;
                                                            end
                                                        end
                                                        if(nx_mshr[i].if_store)begin
                                                            nx_mshr[i].MSHR_state=STORE_COMPLETE;
                                                            nx_mshr[i].dirty=nx_mshr[nx_mshr[i].link_entry].dirty;
                                                            nx_mshr[i].linked_addr_en=0;
                                                            nx_mshr[i].linked_idx_en=0;
                                                            if(nx_mshr[nx_mshr[i].link_entry].if_store)begin
                                                                cache_type.byte_level = nx_mshr[nx_mshr[i].link_entry].MSHR_data;
                                                                cache_type.half_level = nx_mshr[nx_mshr[i].link_entry].MSHR_data;
                                                                cache_type.word_level = nx_mshr[nx_mshr[i].link_entry].MSHR_data;
                                                                case (nx_mshr[nx_mshr[i].link_entry].size_type) 
                                                                        BYTE: begin
                                                                            cache_type.byte_level[nx_mshr[nx_mshr[i].link_entry].MSHR_addr[2:0]] = nx_mshr[nx_mshr[i].link_entry].st_data[7:0];
                                                                            nx_mshr[i].MSHR_data = cache_type.byte_level;
                                                                        end
                                                                        HALF: begin
                                                                            cache_type.half_level[nx_mshr[nx_mshr[i].link_entry].MSHR_addr[2:1]] = nx_mshr[nx_mshr[i].link_entry].st_data[15:0];
                                                                            nx_mshr[i].MSHR_data = cache_type.half_level;
                                                                        end
                                                                        WORD: begin
                                                                            cache_type.word_level[nx_mshr[nx_mshr[i].link_entry].MSHR_addr[2]] = nx_mshr[nx_mshr[i].link_entry].st_data[31:0];
                                                                            nx_mshr[i].MSHR_data = cache_type.word_level;
                                                                        end
                                                                        default: begin
                                                                            cache_type.byte_level[nx_mshr[nx_mshr[i].link_entry].MSHR_addr[2]] = nx_mshr[nx_mshr[i].link_entry].st_data[31:0];
                                                                            nx_mshr[i].MSHR_data = cache_type.word_level;
                                                                        end
                                                                endcase
                                                            end
                                                            else begin
                                                            nx_mshr[i].MSHR_data=nx_mshr[nx_mshr[i].link_entry].MSHR_data;
                                                            end
                                                        end
                                                    // end
                                                end
                                            end


                INDEX_DEPEND            :   begin
                                                if(nx_mshr[nx_mshr[i].link_entry].linked_idx_en==0)begin
                                                    if(nx_mshr[i].if_load) begin
                                                        nx_mshr[i].MSHR_state=LOAD_MISS_WAITTING_BUS;
                                                    end
                                                    if(nx_mshr[i].if_store)begin
                                                        nx_mshr[i].MSHR_state=STORE_MISS_WAITTING_BUS;
                                                    end
                                                end
                                            end
                default                 :   begin
                                                nx_mshr[i]=0;
                                                nx_mshr[i].MSHR_state=IDLE;
                                            end
        endcase
    end// end for loop, case(state)
  


    for(int j=`MSHR_Depth; j>0;j--)begin
        if(mshr_in_packet[0].valid &&                                                                      //evict and evict depend
                mshr_in_packet[0].index_addr==nx_mshr[j].MSHR_addr[`Cache_Index+`block_offset_bit-1:`block_offset_bit] && 
                mshr_in_packet[0].tag_addr == nx_mshr[j].MSHR_addr[`XLEN-1:`Cache_Index+`block_offset_bit] && 
                nx_mshr[j].if_evict)begin
                    nx_mshr[j] = 0;
                end 

            
    end

     //////////////////////writing pointer///////////////////////
    for (int i=`MSHR_Depth; i>0;i--) begin
        if(nx_mshr[i].MSHR_state==IDLE )begin
           wr_mshr_pointer=wr_mshr_pointer+1;
        end
    end
        //////////////////compressing/////////////////////





    for (int i=1; i<`MSHR_Depth; i=i+1) begin
        if(!nx_mshr[i+1].mshr_valid && nx_mshr[i].mshr_valid)begin
            for (int j=i ;j>=1; j=j-1)begin
                
                nx_mshr[j+1] = nx_mshr[j];
                // nx_mshr[j].mshr_valid = 1'b0;
                nx_mshr[j] = 0;
                // nx_evict_counter[j+1] = nx_evict_counter[j];
                if(nx_mshr[j+1].link_entry!=0 && nx_mshr[j+1].link_entry<complete_entry)begin
                    nx_mshr[j+1].link_entry = nx_mshr[j+1].link_entry + 1;
                    // if(nx_mshr[j+1].link_entry>`MSHR_Depth)begin
                    //     nx_mshr[j+1].link_entry = 0;
                    // end
                end
                if(!nx_mshr[nx_mshr[j+1].link_entry].mshr_valid)
                    nx_mshr[j+1].link_entry = 0;
            end
        end
    end

   
//    for(int i=0; i< 3;i++)begin
        if(mshr_in_packet[0].valid)begin
            
            wr_mshr_pointer_evict=wr_mshr_pointer;
            wr_mshr_pointer=wr_mshr_pointer-1'b1;
        end
        if(mshr_in_packet[1].valid)begin
            
            wr_mshr_pointer_st=wr_mshr_pointer;
            wr_mshr_pointer=wr_mshr_pointer-1'b1;
        end
        if(mshr_in_packet[2].valid)begin
            
            wr_mshr_pointer_ld=wr_mshr_pointer;
            // wr_mshr_pointer=wr_mshr_pointer-1'b1;
        end



//    end




    
    for(int j=`MSHR_Depth; j>0;j--)begin
        //load
            if(mshr_in_packet[2].valid &&                                        //address depend include evicting
            mshr_in_packet[2].index_addr==nx_mshr[j].MSHR_addr[`Cache_Index+`block_offset_bit-1:`block_offset_bit] && 
            mshr_in_packet[2].tag_addr == nx_mshr[j].MSHR_addr[`XLEN-1:`Cache_Index+`block_offset_bit] && 
            !nx_mshr[j].linked_addr_en && 
            
             nx_mshr[j].mshr_valid)begin  //nx_mshr[j].MSHR_state!= LOAD_COMPLETE && nx_mshr[j].MSHR_state!= STORE_COMPLETE  &&
                load_addr_depend_en=1'b1;
                load_link_entry_num=j;
            end

            else if(mshr_in_packet[2].valid &&                                                        //index depend no evicting
            mshr_in_packet[2].index_addr==nx_mshr[j].MSHR_addr[`Cache_Index+`block_offset_bit-1:`block_offset_bit] && 
            mshr_in_packet[2].tag_addr  != nx_mshr[j].MSHR_addr[`XLEN-1:`Cache_Index+`block_offset_bit] && 
            !nx_mshr[j].linked_idx_en &&
            (nx_mshr[j].MSHR_state== LOAD_MISS_WAITTING_BUS || 
            nx_mshr[j].MSHR_state== STORE_MISS_WAITTING_BUS) &&
            !load_addr_depend_en  && nx_mshr[j].mshr_valid)begin
                load_index_depend_en=1'b1;
                load_link_entry_num=j;
                if(nx_mshr[load_link_entry_num].if_evict)begin
                    load_index_depend_en = 0;
                    load_link_entry_num = 0;
                end
                
            end
        //store
            if(mshr_in_packet[1].valid &&                                        //address depend include evicting
            mshr_in_packet[1].index_addr==nx_mshr[j].MSHR_addr[`Cache_Index+`block_offset_bit-1:`block_offset_bit] && 
            mshr_in_packet[1].tag_addr == nx_mshr[j].MSHR_addr[`XLEN-1:`Cache_Index+`block_offset_bit] && 
            !nx_mshr[j].linked_addr_en && 
            nx_mshr[j].mshr_valid)begin   //                                            nx_mshr[j].MSHR_state!= LOAD_COMPLETE && 
                                                                                            //nx_mshr[j].MSHR_state!= STORE_COMPLETE  && 
                store_addr_depend_en=1'b1;
                store_link_entry_num=j;
                
            end

            else if(mshr_in_packet[1].valid &&                                                        //index depend no evicting
            mshr_in_packet[1].index_addr==nx_mshr[j].MSHR_addr[`Cache_Index+`block_offset_bit-1:`block_offset_bit] && 
            mshr_in_packet[1].tag_addr != nx_mshr[j].MSHR_addr[`XLEN-1:`Cache_Index+`block_offset_bit] && 
            !nx_mshr[j].linked_idx_en &&
            (nx_mshr[j].MSHR_state== LOAD_MISS_WAITTING_BUS || 
            nx_mshr[j].MSHR_state== STORE_MISS_WAITTING_BUS) &&
            !store_addr_depend_en  && nx_mshr[j].mshr_valid)begin
                store_index_depend_en=1'b1;
                store_link_entry_num=j;
                if(nx_mshr[store_link_entry_num].if_evict)begin
                    store_index_depend_en = 0;
                    store_link_entry_num = 0;
                end
                
            end
            
            if(mshr_in_packet[1].valid && mshr_in_packet[2].valid &&
            mshr_in_packet[1].index_addr == mshr_in_packet[2].index_addr &&
            mshr_in_packet[1].tag_addr == mshr_in_packet[2].tag_addr && !nx_mshr[j].mshr_valid
            )begin
                if(mshr_in_packet[0].valid)begin
                    load_addr_depend_en=1'b1;
                    load_link_entry_num=j-1;
                    break;
                end
                else begin
                    load_addr_depend_en=1'b1;
                    load_link_entry_num=j;
                    break;
                end
            end
            else if(mshr_in_packet[1].valid && mshr_in_packet[2].valid &&
            mshr_in_packet[1].index_addr == mshr_in_packet[2].index_addr &&
            mshr_in_packet[1].tag_addr != mshr_in_packet[2].tag_addr && !nx_mshr[j].mshr_valid &&
            !load_addr_depend_en
            )begin
                if(mshr_in_packet[0].valid)begin
                    load_index_depend_en=1'b1;
                    load_link_entry_num=j-1;
                    break;
                end
                else begin
                    load_index_depend_en=1'b1;
                    load_link_entry_num=j;
                    break;
                end
            end   
    end




        if(mshr_in_packet[0].valid)begin
            // for(int i=`MSHR_Depth; i>0;i--)begin
                // if(nx_mshr[i].MSHR_state==IDLE)begin

                    nx_mshr[wr_mshr_pointer_evict].MSHR_state=WAIT_EVICT;
                    nx_mshr[wr_mshr_pointer_evict].CMD= BUS_STORE;
                    nx_mshr[wr_mshr_pointer_evict].size_type=DOUBLE;
                    nx_mshr[wr_mshr_pointer_evict].MSHR_addr=mshr_in_packet[0].alu_result;
                    nx_mshr[wr_mshr_pointer_evict].MSHR_data=mshr_in_packet[0].evict_data;
                    nx_mshr[wr_mshr_pointer_evict].mshr_valid=1'b1; 
                    nx_mshr[wr_mshr_pointer_evict].inst='d0; 
                    nx_mshr[wr_mshr_pointer_evict].NPC='d0; 
                    nx_mshr[wr_mshr_pointer_evict].valid=1'b1; 
                    
                    nx_mshr[wr_mshr_pointer_evict].if_evict=1'b1;
                    // wr_mshr_pointer=wr_mshr_pointer-1'b1;

                    // break;
                // end
            // end
        end
        if(st_Dcache_miss && mshr_in_packet[1].valid)begin
            // for(int i=`MSHR_Depth; i>0;i--)begin
                // if(nx_mshr[i].MSHR_state==IDLE)begin
                    if(!st_evict_hit && (!store_addr_depend_en && !store_index_depend_en)   || (nx_mshr[load_link_entry_num].MSHR_state==LOAD_COMPLETE ||
                                                                            nx_mshr[load_link_entry_num].MSHR_state==STORE_COMPLETE ) && load_index_depend_en)begin //||
                            // nx_mshr[store_link_entry_num].MSHR_state==LOAD_COMPLETE ||
                            // nx_mshr[store_link_entry_num].MSHR_state==STORE_COMPLETE
                        nx_mshr[wr_mshr_pointer_st].MSHR_state= STORE_MISS_WAITTING_BUS;
                        nx_mshr[wr_mshr_pointer_st].CMD= BUS_LOAD;
                        nx_mshr[wr_mshr_pointer_st].size_type=mshr_in_packet[1].mem_size;
                        nx_mshr[wr_mshr_pointer_st].MSHR_addr=mshr_in_packet[1].alu_result;
                        nx_mshr[wr_mshr_pointer_st].st_data = mshr_in_packet[1].rs2_value;
                        nx_mshr[wr_mshr_pointer_st].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].inst=mshr_in_packet[1].inst; 
                        nx_mshr[wr_mshr_pointer_st].NPC=mshr_in_packet[1].NPC; 
                        nx_mshr[wr_mshr_pointer_st].valid=mshr_in_packet[1].valid; 
                        nx_mshr[wr_mshr_pointer_st].dirty = 1'b1;
                            
                        nx_mshr[wr_mshr_pointer_st].if_store=1'b1;

                    end
                    else if (!st_evict_hit && store_index_depend_en && !store_addr_depend_en && 
                            nx_mshr[store_link_entry_num].MSHR_state!=LOAD_COMPLETE &&
                            nx_mshr[store_link_entry_num].MSHR_state!=STORE_COMPLETE &&
                            !nx_mshr[store_link_entry_num].if_evict)begin
                        nx_mshr[wr_mshr_pointer_st].MSHR_state= INDEX_DEPEND;
                        nx_mshr[wr_mshr_pointer_st].CMD= BUS_LOAD;
                        nx_mshr[wr_mshr_pointer_st].size_type=mshr_in_packet[1].mem_size;
                        nx_mshr[wr_mshr_pointer_st].MSHR_addr=mshr_in_packet[1].alu_result;
                        nx_mshr[wr_mshr_pointer_st].st_data = mshr_in_packet[1].rs2_value;
                        nx_mshr[wr_mshr_pointer_st].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].inst=mshr_in_packet[1].inst; 
                        nx_mshr[wr_mshr_pointer_st].NPC=mshr_in_packet[1].NPC; 
                        nx_mshr[wr_mshr_pointer_st].dirty = 1'b1;
                        
                        nx_mshr[wr_mshr_pointer_st].if_store=1'b1;
                        nx_mshr[wr_mshr_pointer_st].link_entry=store_link_entry_num;
                        nx_mshr[store_link_entry_num].linked_idx_en=1;

                    end

                    else if (!st_evict_hit && !nx_mshr[store_link_entry_num].if_evict &&
                            store_addr_depend_en  
                            )begin                             ///&& nx_mshr[store_link_entry_num].MSHR_state!=LOAD_COMPLETE &&
                                                              //  nx_mshr[store_link_entry_num].MSHR_state!=STORE_COMPLETE
                        nx_mshr[wr_mshr_pointer_st].MSHR_state= ADDR_DEPEND;
                        nx_mshr[wr_mshr_pointer_st].CMD= BUS_LOAD;
                        nx_mshr[wr_mshr_pointer_st].size_type=mshr_in_packet[1].mem_size;
                        nx_mshr[wr_mshr_pointer_st].MSHR_addr=mshr_in_packet[1].alu_result;
                        nx_mshr[wr_mshr_pointer_st].st_data = mshr_in_packet[1].rs2_value;
                        nx_mshr[wr_mshr_pointer_st].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].inst=mshr_in_packet[1].inst; 
                        nx_mshr[wr_mshr_pointer_st].NPC=mshr_in_packet[1].NPC; 
                        nx_mshr[wr_mshr_pointer_st].dirty = 1'b1;
                        
                        nx_mshr[wr_mshr_pointer_st].if_store=1'b1;
                        nx_mshr[wr_mshr_pointer_st].link_entry=store_link_entry_num;
                        nx_mshr[store_link_entry_num].linked_addr_en=1;

                        case(nx_mshr[store_link_entry_num].MSHR_state)//change to last mshr_state. stall ld of Issue buffer issue
                            LOAD_COMPLETE:begin
                                nx_mshr[wr_mshr_pointer_st].MSHR_state= STORE_COMPLETE;
                                nx_mshr[wr_mshr_pointer_st].MSHR_data = nx_mshr[store_link_entry_num].MSHR_data;

                            end
                            STORE_COMPLETE:begin
                                nx_mshr[wr_mshr_pointer_st].MSHR_state= STORE_COMPLETE;
                                cache_type.byte_level = nx_mshr[store_link_entry_num].MSHR_data;
                                cache_type.half_level = nx_mshr[store_link_entry_num].MSHR_data;
                                cache_type.word_level = nx_mshr[store_link_entry_num].MSHR_data;
                                case (nx_mshr[store_link_entry_num].size_type) 
                                        BYTE: begin
                                            cache_type.byte_level[nx_mshr[store_link_entry_num].MSHR_addr[2:0]] = nx_mshr[store_link_entry_num].st_data[7:0];
                                            nx_mshr[wr_mshr_pointer_st].MSHR_data = cache_type.byte_level;
                                        end
                                        HALF: begin
                                            cache_type.half_level[nx_mshr[store_link_entry_num].MSHR_addr[2:1]] = nx_mshr[store_link_entry_num].st_data[15:0];
                                            nx_mshr[wr_mshr_pointer_st].MSHR_data = cache_type.half_level;
                                        end
                                        WORD: begin
                                            cache_type.word_level[nx_mshr[store_link_entry_num].MSHR_addr[2]] = nx_mshr[store_link_entry_num].st_data[31:0];
                                            nx_mshr[wr_mshr_pointer_st].MSHR_data = cache_type.word_level;
                                        end
                                        default: begin
                                            cache_type.byte_level[nx_mshr[store_link_entry_num].MSHR_addr[2]] = nx_mshr[store_link_entry_num].st_data[31:0];
                                            nx_mshr[wr_mshr_pointer_st].MSHR_data = cache_type.word_level;
                                        end
                                endcase
                                // if(nx_mshr[store_link_entry_num].MSHR_addr[2])begin
                                //     nx_mshr[wr_mshr_pointer_st].MSHR_data = {st_data_tmp[63:32],nx_mshr[store_link_entry_num].MSHR_data[31:0]};
                                // end
                                // else begin
                                //     nx_mshr[wr_mshr_pointer_st].MSHR_data = {nx_mshr[store_link_entry_num].MSHR_data[63:32],st_data_tmp[31:0]};
                                // end
                        end
                        endcase
                        end


                
                    else if(!st_evict_hit && nx_mshr[store_link_entry_num].if_evict &&
                            store_addr_depend_en)begin
                        nx_mshr[wr_mshr_pointer_st].MSHR_state= STORE_COMPLETE;
                        nx_mshr[wr_mshr_pointer_st].MSHR_data=nx_mshr[store_link_entry_num].MSHR_data;

                        nx_mshr[wr_mshr_pointer_st].CMD= BUS_NONE;
                        nx_mshr[wr_mshr_pointer_st].size_type=mshr_in_packet[1].mem_size;
                        nx_mshr[wr_mshr_pointer_st].MSHR_addr=mshr_in_packet[1].alu_result;
                        nx_mshr[wr_mshr_pointer_st].st_data = mshr_in_packet[1].rs2_value;
                        nx_mshr[wr_mshr_pointer_st].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].inst=mshr_in_packet[1].inst; 
                        nx_mshr[wr_mshr_pointer_st].NPC=mshr_in_packet[1].NPC; 
                        nx_mshr[wr_mshr_pointer_st].dirty = 1'b1;
                        
                        nx_mshr[wr_mshr_pointer_st].if_store=1'b1;

                        nx_mshr[wr_mshr_pointer_st].linked_addr_en = 1'b0;
                        nx_mshr[wr_mshr_pointer_st].linked_idx_en = 1'b0;

                    end
                    else if(st_evict_hit)begin
                        nx_mshr[wr_mshr_pointer_st].MSHR_state= STORE_COMPLETE;
                        nx_mshr[wr_mshr_pointer_st].MSHR_data=mshr_in_packet[0].evict_data;

                        nx_mshr[wr_mshr_pointer_st].CMD= BUS_NONE;
                        nx_mshr[wr_mshr_pointer_st].size_type=mshr_in_packet[1].mem_size;
                        nx_mshr[wr_mshr_pointer_st].MSHR_addr=mshr_in_packet[1].alu_result;
                        nx_mshr[wr_mshr_pointer_st].st_data = mshr_in_packet[1].rs2_value;
                        nx_mshr[wr_mshr_pointer_st].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_st].inst=mshr_in_packet[1].inst; 
                        nx_mshr[wr_mshr_pointer_st].NPC=mshr_in_packet[1].NPC; 
                        nx_mshr[wr_mshr_pointer_st].dirty = 1'b1;
                        
                        nx_mshr[wr_mshr_pointer_st].if_store=1'b1;

                        nx_mshr[wr_mshr_pointer_st].linked_addr_en = 1'b0;
                        nx_mshr[wr_mshr_pointer_st].linked_idx_en = 1'b0;
                    end
                    // break;
                    // wr_mshr_pointer=wr_mshr_pointer-1'b1;
                // end
            // end
        end

        if(ld_Dcache_miss && mshr_in_packet[2].valid)begin
            // for(int i=`MSHR_Depth; i>0;i--)begin
            //     if(nx_mshr[i].MSHR_state==IDLE)begin
                     if((!ld_evict_hit && !load_addr_depend_en && !load_index_depend_en) || (nx_mshr[load_link_entry_num].MSHR_state==LOAD_COMPLETE ||
                                                                            nx_mshr[load_link_entry_num].MSHR_state==STORE_COMPLETE ) && load_index_depend_en)begin      //|| 
                                                                            // nx_mshr[load_link_entry_num].MSHR_state==LOAD_COMPLETE ||
                                                                            // nx_mshr[load_link_entry_num].MSHR_state==STORE_COMPLETE
                        nx_mshr[wr_mshr_pointer_ld].MSHR_state=LOAD_MISS_WAITTING_BUS;
                        nx_mshr[wr_mshr_pointer_ld].CMD= BUS_LOAD;
                        nx_mshr[wr_mshr_pointer_ld].size_type=mshr_in_packet[2].mem_size;
                        nx_mshr[wr_mshr_pointer_ld].MSHR_addr=mshr_in_packet[2].alu_result; 
                        nx_mshr[wr_mshr_pointer_ld].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_ld].inst=mshr_in_packet[2].inst; 
                        nx_mshr[wr_mshr_pointer_ld].NPC=mshr_in_packet[2].NPC; 
                        nx_mshr[wr_mshr_pointer_ld].ROB_tail=mshr_in_packet[2].ROB_tail; 
                        
                        nx_mshr[wr_mshr_pointer_ld].if_load=1'b1;
                        nx_mshr[wr_mshr_pointer_ld].ld_rd_preg = mshr_in_packet[2].dest_reg_idx;
                        nx_mshr[wr_mshr_pointer_ld].take_branch = mshr_in_packet[2].take_branch;
                        nx_mshr[wr_mshr_pointer_ld].rs2_value= mshr_in_packet[2].rs2_value;
                        nx_mshr[wr_mshr_pointer_ld].rd_mem= mshr_in_packet[2].rd_mem;
                        nx_mshr[wr_mshr_pointer_ld].wr_mem= mshr_in_packet[2].wr_mem;
                        nx_mshr[wr_mshr_pointer_ld].halt= mshr_in_packet[2].halt;
                        nx_mshr[wr_mshr_pointer_ld].illegal= mshr_in_packet[2].illegal;
                        nx_mshr[wr_mshr_pointer_ld].csr_op= mshr_in_packet[2].csr_op;
                        nx_mshr[wr_mshr_pointer_ld].valid= mshr_in_packet[2].valid;
                        nx_mshr[wr_mshr_pointer_ld].is_b_mask= mshr_in_packet[2].is_b_mask;
                        nx_mshr[wr_mshr_pointer_ld].b_mask_bit_branch= mshr_in_packet[2].b_mask_bit_branch;
                        nx_mshr[wr_mshr_pointer_ld].dirty = 1'b0;

                    end
                    else if(!ld_evict_hit && load_index_depend_en && !load_addr_depend_en && 
                            nx_mshr[load_link_entry_num].MSHR_state!=LOAD_COMPLETE &&
                            nx_mshr[load_link_entry_num].MSHR_state!=STORE_COMPLETE &&
                            !nx_mshr[load_link_entry_num].if_evict)begin
                        nx_mshr[wr_mshr_pointer_ld].MSHR_state=INDEX_DEPEND;
                        nx_mshr[wr_mshr_pointer_ld].CMD= BUS_LOAD;
                        nx_mshr[wr_mshr_pointer_ld].size_type=mshr_in_packet[2].mem_size;
                        nx_mshr[wr_mshr_pointer_ld].MSHR_addr=mshr_in_packet[2].alu_result;
                        nx_mshr[wr_mshr_pointer_ld].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_ld].inst=mshr_in_packet[2].inst; 
                        nx_mshr[wr_mshr_pointer_ld].NPC=mshr_in_packet[2].NPC; 
                        
                        nx_mshr[wr_mshr_pointer_ld].if_load=1'b1;
                        nx_mshr[wr_mshr_pointer_ld].ld_rd_preg = mshr_in_packet[2].dest_reg_idx;
                        
                        nx_mshr[wr_mshr_pointer_ld].take_branch = mshr_in_packet[2].take_branch;
                        nx_mshr[wr_mshr_pointer_ld].rs2_value= mshr_in_packet[2].rs2_value;
                        nx_mshr[wr_mshr_pointer_ld].rd_mem= mshr_in_packet[2].rd_mem;
                        nx_mshr[wr_mshr_pointer_ld].wr_mem= mshr_in_packet[2].wr_mem;
                        nx_mshr[wr_mshr_pointer_ld].halt= mshr_in_packet[2].halt;
                        nx_mshr[wr_mshr_pointer_ld].illegal= mshr_in_packet[2].illegal;
                        nx_mshr[wr_mshr_pointer_ld].csr_op= mshr_in_packet[2].csr_op;
                        nx_mshr[wr_mshr_pointer_ld].valid= mshr_in_packet[2].valid;
                        nx_mshr[wr_mshr_pointer_ld].is_b_mask= mshr_in_packet[2].is_b_mask;
                        nx_mshr[wr_mshr_pointer_ld].b_mask_bit_branch= mshr_in_packet[2].b_mask_bit_branch;
                        nx_mshr[wr_mshr_pointer_ld].link_entry=load_link_entry_num;
                        nx_mshr[wr_mshr_pointer_ld].ROB_tail=mshr_in_packet[2].ROB_tail; 
                        nx_mshr[load_link_entry_num].linked_idx_en=1;
                        nx_mshr[wr_mshr_pointer_ld].dirty = 1'b0;

                    end
                    else if(!ld_evict_hit && !nx_mshr[load_link_entry_num].if_evict &&
                            load_addr_depend_en 
                            )begin                                     // && nx_mshr[load_link_entry_num].MSHR_state!=LOAD_COMPLETE &&
                                                                        //nx_mshr[load_link_entry_num].MSHR_state!=STORE_COMPLETE
                        nx_mshr[wr_mshr_pointer_ld].MSHR_state=ADDR_DEPEND;
                        nx_mshr[wr_mshr_pointer_ld].CMD= BUS_LOAD;
                        nx_mshr[wr_mshr_pointer_ld].size_type=mshr_in_packet[2].mem_size;
                        nx_mshr[wr_mshr_pointer_ld].MSHR_addr=mshr_in_packet[2].alu_result;
                        nx_mshr[wr_mshr_pointer_ld].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_ld].inst=mshr_in_packet[2].inst; 
                        nx_mshr[wr_mshr_pointer_ld].NPC=mshr_in_packet[2].NPC; 
                        
                        nx_mshr[wr_mshr_pointer_ld].if_load=1'b1;
                        nx_mshr[wr_mshr_pointer_ld].ld_rd_preg = mshr_in_packet[2].dest_reg_idx;
                        
                        nx_mshr[wr_mshr_pointer_ld].take_branch = mshr_in_packet[2].take_branch;
                        nx_mshr[wr_mshr_pointer_ld].rs2_value= mshr_in_packet[2].rs2_value;
                        nx_mshr[wr_mshr_pointer_ld].rd_mem= mshr_in_packet[2].rd_mem;
                        nx_mshr[wr_mshr_pointer_ld].wr_mem= mshr_in_packet[2].wr_mem;
                        nx_mshr[wr_mshr_pointer_ld].halt= mshr_in_packet[2].halt;
                        nx_mshr[wr_mshr_pointer_ld].illegal= mshr_in_packet[2].illegal;
                        nx_mshr[wr_mshr_pointer_ld].csr_op= mshr_in_packet[2].csr_op;
                        nx_mshr[wr_mshr_pointer_ld].valid= mshr_in_packet[2].valid;
                        nx_mshr[wr_mshr_pointer_ld].is_b_mask= mshr_in_packet[2].is_b_mask;
                        nx_mshr[wr_mshr_pointer_ld].b_mask_bit_branch= mshr_in_packet[2].b_mask_bit_branch;
                        nx_mshr[wr_mshr_pointer_ld].ROB_tail=mshr_in_packet[2].ROB_tail; 
                        nx_mshr[wr_mshr_pointer_ld].link_entry=load_link_entry_num;
                        nx_mshr[load_link_entry_num].linked_addr_en=1;
                        nx_mshr[wr_mshr_pointer_ld].dirty = 1'b0;

                        case(nx_mshr[load_link_entry_num].MSHR_state)//change to last mshr_state. stall ld of Issue buffer issue
                            LOAD_COMPLETE:begin
                                nx_mshr[wr_mshr_pointer_ld].MSHR_state= LOAD_COMPLETE;
                                nx_mshr[wr_mshr_pointer_ld].MSHR_data = nx_mshr[load_link_entry_num].MSHR_data;
                                nx_mshr[wr_mshr_pointer_ld].dirty = nx_mshr[load_link_entry_num].dirty;
                            end
                            STORE_COMPLETE:begin
                                nx_mshr[wr_mshr_pointer_ld].MSHR_state= LOAD_COMPLETE;
                                cache_type.byte_level = nx_mshr[load_link_entry_num].MSHR_data;
                                cache_type.half_level = nx_mshr[load_link_entry_num].MSHR_data;
                                cache_type.word_level = nx_mshr[load_link_entry_num].MSHR_data;

                                nx_mshr[wr_mshr_pointer_ld].dirty = nx_mshr[load_link_entry_num].dirty;
                                case (nx_mshr[load_link_entry_num].size_type) 
                                        BYTE: begin
                                            cache_type.byte_level[nx_mshr[load_link_entry_num].MSHR_addr[2:0]] = nx_mshr[load_link_entry_num].st_data[7:0];
                                            nx_mshr[wr_mshr_pointer_ld].MSHR_data = cache_type.byte_level;
                                        end
                                        HALF: begin
                                            cache_type.half_level[nx_mshr[load_link_entry_num].MSHR_addr[2:1]] = nx_mshr[load_link_entry_num].st_data[15:0];
                                            nx_mshr[wr_mshr_pointer_ld].MSHR_data = cache_type.half_level;
                                        end
                                        WORD: begin
                                            cache_type.word_level[nx_mshr[load_link_entry_num].MSHR_addr[2]] = nx_mshr[load_link_entry_num].st_data[31:0];
                                            nx_mshr[wr_mshr_pointer_ld].MSHR_data = cache_type.word_level;
                                        end
                                        default: begin
                                            cache_type.byte_level[nx_mshr[load_link_entry_num].MSHR_addr[2]] = nx_mshr[load_link_entry_num].st_data[31:0];
                                            nx_mshr[wr_mshr_pointer_ld].MSHR_data = cache_type.word_level;
                                        end
                                endcase
                                // if(nx_mshr[load_link_entry_num].MSHR_addr[2])begin
                                //     nx_mshr[wr_mshr_pointer_ld].MSHR_data = {st_data_tmp,nx_mshr[load_link_entry_num].MSHR_data[31:0]};
                                // end
                                // else begin
                                //     nx_mshr[wr_mshr_pointer_ld].MSHR_data = {nx_mshr[load_link_entry_num].MSHR_data[63:32],st_data_tmp};
                                // end
                        end
                    endcase

                    end
                    else if(!ld_evict_hit && nx_mshr[load_link_entry_num].if_evict && load_addr_depend_en) begin
                        nx_mshr[wr_mshr_pointer_ld].MSHR_state=LOAD_COMPLETE;
                        nx_mshr[wr_mshr_pointer_ld].linked_addr_en = 1'b0;
                        nx_mshr[wr_mshr_pointer_ld].linked_idx_en = 1'b0;
                        
                        nx_mshr[wr_mshr_pointer_ld].mem_tag='d0;
                        nx_mshr[wr_mshr_pointer_ld].MSHR_data=nx_mshr[load_link_entry_num].MSHR_data;

                        nx_mshr[wr_mshr_pointer_ld].CMD= BUS_NONE;
                        nx_mshr[wr_mshr_pointer_ld].size_type=mshr_in_packet[2].mem_size;
                        nx_mshr[wr_mshr_pointer_ld].MSHR_addr=mshr_in_packet[2].alu_result;
                        nx_mshr[wr_mshr_pointer_ld].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_ld].inst=mshr_in_packet[2].inst; 
                        nx_mshr[wr_mshr_pointer_ld].NPC=mshr_in_packet[2].NPC; 
                        
                        nx_mshr[wr_mshr_pointer_ld].if_load=1'b1;
                        nx_mshr[wr_mshr_pointer_ld].ld_rd_preg = mshr_in_packet[2].dest_reg_idx;
                        
                        nx_mshr[wr_mshr_pointer_ld].take_branch = mshr_in_packet[2].take_branch;
                        nx_mshr[wr_mshr_pointer_ld].rs2_value= mshr_in_packet[2].rs2_value;
                        nx_mshr[wr_mshr_pointer_ld].rd_mem= mshr_in_packet[2].rd_mem;
                        nx_mshr[wr_mshr_pointer_ld].wr_mem= mshr_in_packet[2].wr_mem;
                        nx_mshr[wr_mshr_pointer_ld].halt= mshr_in_packet[2].halt;
                        nx_mshr[wr_mshr_pointer_ld].illegal= mshr_in_packet[2].illegal;
                        nx_mshr[wr_mshr_pointer_ld].csr_op= mshr_in_packet[2].csr_op;
                        nx_mshr[wr_mshr_pointer_ld].valid= mshr_in_packet[2].valid;
                        nx_mshr[wr_mshr_pointer_ld].is_b_mask= mshr_in_packet[2].is_b_mask;
                        nx_mshr[wr_mshr_pointer_ld].b_mask_bit_branch= mshr_in_packet[2].b_mask_bit_branch;
                        nx_mshr[wr_mshr_pointer_ld].ROB_tail=mshr_in_packet[2].ROB_tail; 
                        nx_mshr[wr_mshr_pointer_ld].dirty = 1'b0;
                    end
                    else if(ld_evict_hit)begin
                        nx_mshr[wr_mshr_pointer_ld].MSHR_state=LOAD_COMPLETE;
                        nx_mshr[wr_mshr_pointer_ld].linked_addr_en = 1'b0;
                        nx_mshr[wr_mshr_pointer_ld].linked_idx_en = 1'b0;
                        nx_mshr[wr_mshr_pointer_ld].mem_tag='d0;
                        nx_mshr[wr_mshr_pointer_ld].MSHR_data=mshr_in_packet[0].evict_data;

                        nx_mshr[wr_mshr_pointer_ld].CMD= BUS_NONE;
                        nx_mshr[wr_mshr_pointer_ld].size_type=mshr_in_packet[2].mem_size;
                        nx_mshr[wr_mshr_pointer_ld].MSHR_addr=mshr_in_packet[2].alu_result;
                        nx_mshr[wr_mshr_pointer_ld].mshr_valid=1'b1; 
                        nx_mshr[wr_mshr_pointer_ld].inst=mshr_in_packet[2].inst; 
                        nx_mshr[wr_mshr_pointer_ld].NPC=mshr_in_packet[2].NPC; 
                        
                        nx_mshr[wr_mshr_pointer_ld].if_load=1'b1;
                        nx_mshr[wr_mshr_pointer_ld].ld_rd_preg = mshr_in_packet[2].dest_reg_idx;
                        
                        nx_mshr[wr_mshr_pointer_ld].take_branch = mshr_in_packet[2].take_branch;
                        nx_mshr[wr_mshr_pointer_ld].rs2_value= mshr_in_packet[2].rs2_value;
                        nx_mshr[wr_mshr_pointer_ld].rd_mem= mshr_in_packet[2].rd_mem;
                        nx_mshr[wr_mshr_pointer_ld].wr_mem= mshr_in_packet[2].wr_mem;
                        nx_mshr[wr_mshr_pointer_ld].halt= mshr_in_packet[2].halt;
                        nx_mshr[wr_mshr_pointer_ld].illegal= mshr_in_packet[2].illegal;
                        nx_mshr[wr_mshr_pointer_ld].csr_op= mshr_in_packet[2].csr_op;
                        nx_mshr[wr_mshr_pointer_ld].valid= mshr_in_packet[2].valid;
                        nx_mshr[wr_mshr_pointer_ld].is_b_mask= mshr_in_packet[2].is_b_mask;
                        nx_mshr[wr_mshr_pointer_ld].b_mask_bit_branch= mshr_in_packet[2].b_mask_bit_branch;
                        nx_mshr[wr_mshr_pointer_ld].ROB_tail=mshr_in_packet[2].ROB_tail; 
                        nx_mshr[wr_mshr_pointer_ld].dirty = 1'b0;

                    end
                    // break;
                end
        //     end
        // end
         for(int j=`MSHR_Depth; j>0;j--)begin
                    if(nx_mshr[j].mshr_valid && nx_mshr[j].MSHR_state==LOAD_COMPLETE)begin
                        nx_stall_IS_MSHR=1'b1;
                    end 
         end
end //end comb logic



// always_ff @(posedge clock)begin
//     if(reset)begin

//     end
//     else begin

//     end
// end

endmodule
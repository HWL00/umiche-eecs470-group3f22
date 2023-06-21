`timescale 1ns/100ps
module Dcache(
//////////////input//////////////////
input clock,
input reset,
///////////from ex_stage////////////
// input[`XLEN-1:0] ld_inst_addr,                         //store target address or load address
// input ld_valid,                                     //rd_mem
// input MEM_SIZE ld_mem_size,                         //inst.r.funct3
input EX_COM_PACKET ex_ld_packet_in,

input SQ_OUT_PACKET sq_packet_in,
input load_hit_sq,
//////////from MSHR///////////////

input [2*`XLEN-1:0] block_data_mshr_in,
input [`XLEN-1:0]  block_addr_mshr_in,
input dirty_mshr_in,
input mshr_out_valid,

input [$clog2(`MSHR_Depth):0]avail_MSHR,
input  st_cache_hit_mask_mshr,
input  ld_cache_hit_mask_mshr,
/////////////output//////////////////////
///To mshr
output EX_COM_PACKET ex_ld_packet_to_mshr_out,
output SQ_OUT_PACKET sq_packet_mshr_out,

// output logic lsq2st_valid_mshr_out,
// output logic[`XLEN-1:0] lsq2Dcache_addr_mshr_out,
// output logic [`XLEN-1:0] lsq2Dcache_data_mshr_out,
// output MEM_SIZE st_mem_size_mshr_out,         

output logic  ld_Dcache_hit_out,
output logic st_Dcache_hit_out,
output logic ld_Dcache_miss_out,
output logic st_Dcache_miss_out, 
output logic evicting_en_out,         // this block is dirty and need to write back to MEM
output logic [`XLEN-1:0]  evicting_addr_out, 
output logic [2*`XLEN-1:0]  evicting_data_out,
//To execute
output  EX_COM_PACKET ex_ld_packet_to_ex,
//to lsq
output logic stop_sq_retire_en,
//to issue buffer
output logic stop_is_en,
output logic stop_is_st_en,
output D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] d_cache

);
EX_COM_PACKET ex_ld_packet_to_mshr;
logic lsq2st_valid_mshr;
logic[`XLEN-1:0] lsq2Dcache_addr_mshr;
logic[`XLEN-1:0] lsq2Dcache_data_mshr;
MEM_SIZE st_mem_size_mshr;         

logic  ld_Dcache_hit;
logic st_Dcache_hit;
logic ld_Dcache_miss;
logic st_Dcache_miss;
logic evicting_en;         // this block is dirty and need to write back to MEM
logic [`XLEN-1:0]  evicting_addr; 
logic [2*`XLEN-1:0]  evicting_data;





logic[`XLEN-1:0] ld_Dcache_hit_data;
logic[`XLEN-1:0] pre_ld_Dcache_hit_data;
D_CACHE_BLOCK [`CACHE_Assoc-1:0][`Cache_depth-1:0] nx_d_cache;
logic[`CACHE_Assoc-1:0] pre_ld_Dcache_hit, pre_ld_Dcache_miss;
logic[`CACHE_Assoc-1:0] pre_st_Dcache_hit, pre_st_Dcache_miss;

logic[`Cache_Index-1:0] ld_inst_index;
logic[`block_offset_bit-1:0] ld_inst_block_offset;
// logic[`CACHE_Assoc-1:0] ld_assoc_offset;
logic[`XLEN-`lsb_Cache_tag-1:0] ld_inst_tag;

logic[`Cache_Index-1:0] st_inst_index;
logic[`block_offset_bit-1:0] st_inst_block_offset;
// logic[`CACHE_Assoc-1:0] ld_assoc_offset;
logic[`XLEN-`lsb_Cache_tag-1:0] st_inst_tag;

logic[`Cache_Index-1:0] wr_inst_index;
logic[`block_offset_bit-1:0] wr_inst_block_offset;
logic[`XLEN-`lsb_Cache_tag-1:0] wr_inst_tag;

EXAMPLE_CACHE_BLOCK cache_type;
logic[$clog2(`CACHE_Assoc)-1:0] wr_lru_num;
logic [$clog2(`CACHE_Assoc)-1:0] wr_assoc_num;
logic[$clog2(`CACHE_Assoc)-1:0] ld_hit_lru_num;
logic [$clog2(`CACHE_Assoc)-1:0] ld_hit_assoc_num;
// logic [$clog2(`Cache_Index)-1:0] ld_hit_index_num;

logic[$clog2(`CACHE_Assoc)-1:0] st_hit_lru_num;
logic [$clog2(`CACHE_Assoc)-1:0] st_hit_assoc_num;
// logic [$clog2(`Cache_Index)-1:0] st_hit_index_num;

// logic [$clog2(`CACHE_Assoc)-1:0] wr_assoc_num;
logic mshr_out_hit;
logic ld_st_hit;
logic hit_in_other;

////////////////////////combinational logic//////////////////////////////
assign{ld_inst_tag,ld_inst_index,ld_inst_block_offset}=ex_ld_packet_in.alu_result;
assign{st_inst_tag,st_inst_index,st_inst_block_offset}=sq_packet_in.store_address;
assign{wr_inst_tag,wr_inst_index,wr_inst_block_offset}=block_addr_mshr_in;
always_comb begin
    
    nx_d_cache=d_cache;
    evicting_en = 0;
    evicting_addr = 0;
    evicting_data = 0;

    wr_assoc_num = 0;

    // st_hit_index_num = 0;
    st_hit_assoc_num = 0;
    st_hit_lru_num = 0;
    // ld_hit_index_num = 0;
    ld_hit_assoc_num = 0;
    ld_hit_lru_num = 0;
    wr_lru_num = 0;

    ex_ld_packet_to_mshr = 0;
    ex_ld_packet_to_ex = 0;

    stop_is_en= 0;
    stop_is_st_en=1'b0;
    stop_sq_retire_en = 0;

    mshr_out_hit = 0;

    ////////////hit or miss//////////////

    ld_Dcache_hit=1'b0;
    ld_Dcache_miss=1'b1;
    ld_Dcache_hit_data='d0;
    lsq2st_valid_mshr = 0;

    st_Dcache_hit='d0;
    st_Dcache_miss=1'b1;
    ld_st_hit = 1'b0;
    hit_in_other = 1'b0;

    lsq2Dcache_data_mshr = 0;
    lsq2Dcache_addr_mshr = 0;
    st_mem_size_mshr = 0;
    evicting_data_out = 0;
    ex_ld_packet_to_mshr_out = 0;
    evicting_addr_out = 0;

    if(ex_ld_packet_in.rd_mem && sq_packet_in.address_value_valid  && (ex_ld_packet_in.mem_size == sq_packet_in.mem_size)  && 
        ex_ld_packet_in.alu_result ==sq_packet_in.store_address
           && !load_hit_sq)begin
                                                                                                                    //  st_inst_index == ld_inst_index &&
                                                                                                                        // st_inst_tag == ld_inst_tag &&
                                                                                                                        // ld_inst_block_offset == st_inst_block_offset 
            ld_st_hit = 1'b1; 
            ld_Dcache_hit = 1'b1;
            ld_Dcache_miss = 1'b0;
            ex_ld_packet_to_ex = ex_ld_packet_in;

            // cache_type.byte_level = 
            // cache_type.half_level = sq_packet_in.value;
            // cache_type.word_level = sq_packet_in.value;
            // case (ex_ld_packet_in.mem_size)
            //     BYTE: begin
            //         ld_Dcache_hit_data = {24'b0, cache_type.byte_level[ex_ld_packet_in.alu_result[2:0]]};
            //     end
            //     HALF: begin
            //         ld_Dcache_hit_data = {16'b0, cache_type.half_level[ex_ld_packet_in.alu_result[2:1]]};
            //     end
            //     WORD: begin
            //         ld_Dcache_hit_data=  cache_type.word_level[ex_ld_packet_in.alu_result[2]];
            //     end
            //     default:begin
            //         ld_Dcache_hit_data =  cache_type.word_level[ex_ld_packet_in.alu_result[2]];
            //     end
            //     // DOUBLE:
            //     // 	loaded_data[i] = unified_memory[proc2mem_addr[`XLEN-1:3]];
            // endcase
            ex_ld_packet_to_ex.alu_result = sq_packet_in.value;
            // ex_ld_packet_to_ex.rs2_value = sq_packet_in.value;
    end
    hit_in_other = ld_st_hit || load_hit_sq;
    // inst_index=inst_addr[`Cache_Index+`block_offset_bit+`CACHE_Assoc-1:`block_offset_bit+`CACHE_Assoc];   //block 8 byte ,2 assoc   2bits for offset
    // inst_block_offset=inst_addr[`block_offset_bit-1:0]; 
    // inst_tag=inst_addr[`XLEN-1:`Cache_Index+`block_offset_bit];

    // st_inst_index=lsq2Dcache_addr[`Cache_Index+`block_offset_bit+`CACHE_Assoc-1:`block_offset_bit+`CACHE_Assoc];   //block 8 byte ,2 assoc   2bits for offset
    // st_inst_block_offset=lsq2Dcache_addr[`block_offset_bit+`CACHE_Assoc-1:`CACHE_Assoc]; 
    // st_inst_assoc_offset=lsq2Dcache_addr[`CACHE_Assoc-1:0];
    // st_inst_tag=lsq2Dcache_addr[`XLEN-1:`Cache_Index+`block_offset_bit+`CACHE_Assoc];


 /////////////write////////////////
    for(int i=0;i<`CACHE_Assoc;i++)begin
        if(nx_d_cache[i][wr_inst_index].tag == wr_inst_tag && mshr_out_valid && nx_d_cache[i][wr_inst_index].block_valid )begin
            wr_assoc_num=i;
            wr_lru_num = nx_d_cache[i][wr_inst_index].LRU_num;
            nx_d_cache[i][wr_inst_index].tag = wr_inst_tag;
            nx_d_cache[i][wr_inst_index].block_data = block_data_mshr_in;
            nx_d_cache[i][wr_inst_index].LRU_num = 'd0;
            nx_d_cache[i][wr_inst_index].dirty = dirty_mshr_in;
            nx_d_cache[i][wr_inst_index].block_valid = 1'b1;
            mshr_out_hit = 1'b1;
        end
    end

 for(int i=0;i<`CACHE_Assoc;i++)begin
    if(!mshr_out_hit) begin
        if(nx_d_cache[i][wr_inst_index].LRU_num=={$clog2(`CACHE_Assoc){1'b1}} && mshr_out_valid)begin
            wr_assoc_num=i;
            wr_lru_num = nx_d_cache[i][wr_inst_index].LRU_num;
            if(nx_d_cache[i][wr_inst_index].block_valid && nx_d_cache[i][wr_inst_index].dirty)begin
                evicting_en = 1;
                evicting_addr = {nx_d_cache[i][wr_inst_index].tag,wr_inst_index,3'd0};
                evicting_data = nx_d_cache[i][wr_inst_index].block_data;
            
                nx_d_cache[i][wr_inst_index].tag = wr_inst_tag;
                nx_d_cache[i][wr_inst_index].block_data = block_data_mshr_in;
                nx_d_cache[i][wr_inst_index].LRU_num = 'd0;
                nx_d_cache[i][wr_inst_index].dirty = dirty_mshr_in;
                nx_d_cache[i][wr_inst_index].block_valid = 1'b1;
            end
            else begin
                evicting_en = 0;
            
                nx_d_cache[i][wr_inst_index].tag = wr_inst_tag;
                nx_d_cache[i][wr_inst_index].block_data = block_data_mshr_in;
                nx_d_cache[i][wr_inst_index].LRU_num = 0;
                nx_d_cache[i][wr_inst_index].dirty = dirty_mshr_in;
                nx_d_cache[i][wr_inst_index].block_valid = 1'b1;
            end
        end
    end
 end

//  for(int i=0;i<`CACHE_Assoc;i++)begin
//     if(i!=wr_assoc_num  && mshr_out_valid && !mshr_out_hit)begin
//         nx_d_cache[i][wr_inst_index].LRU_num = nx_d_cache[i][wr_inst_index].LRU_num+1'b1;
//     end
// end

// for(int i=0;i<`CACHE_Assoc;i++)begin
//     if(i!=wr_assoc_num  && nx_d_cache[i][wr_inst_index].LRU_num<wr_lru_num && mshr_out_valid)begin
//         nx_d_cache[i][wr_inst_index].LRU_num = nx_d_cache[i][wr_inst_index].LRU_num+1;
//     end
//     else begin
//         nx_d_cache[i][wr_inst_index].LRU_num = nx_d_cache[i][wr_inst_index].LRU_num;
//     end
// end

for(int i=0;i<`CACHE_Assoc;i++)begin
    if(i!=wr_assoc_num  && nx_d_cache[i][wr_inst_index].LRU_num<wr_lru_num && mshr_out_valid)begin
        nx_d_cache[i][wr_inst_index].LRU_num = nx_d_cache[i][wr_inst_index].LRU_num+1;
    end
    else begin
        nx_d_cache[i][wr_inst_index].LRU_num = nx_d_cache[i][wr_inst_index].LRU_num;
    end
end
 
////////////////store hit and miss/////////////////////////   
for(int i=0;i<`CACHE_Assoc;i++)begin
    // for(int j=0;j<`Cache_depth;j++)begin
        if(!st_cache_hit_mask_mshr && nx_d_cache[i][st_inst_index].tag==st_inst_tag && sq_packet_in.address_value_valid && nx_d_cache[i][st_inst_index].block_valid)begin // 
                // st_hit_index_num = j;
                st_hit_assoc_num = i;
                st_hit_lru_num = nx_d_cache[i][st_inst_index].LRU_num;
                st_Dcache_hit=1'b1;
                st_Dcache_miss=1'b0;
                lsq2st_valid_mshr = 1'b0;
                nx_d_cache[i][st_inst_index].dirty=1'b1;
                nx_d_cache[i][st_inst_index].LRU_num = 0;
                // nx_d_cache[i][j].block_data[st_inst_block_offset]=;
                cache_type.byte_level = nx_d_cache[i][st_inst_index].block_data;
                cache_type.half_level = nx_d_cache[i][st_inst_index].block_data;
                cache_type.word_level = nx_d_cache[i][st_inst_index].block_data;
                case (sq_packet_in.mem_size) 
                        BYTE: begin
							cache_type.byte_level[sq_packet_in.store_address[2:0]] = sq_packet_in.value[7:0];
                            nx_d_cache[i][st_inst_index].block_data = cache_type.byte_level;
                        end
                        HALF: begin
							// assert(sq_packet_in.store_address[0] == 0);
							cache_type.half_level[sq_packet_in.store_address[2:1]] = sq_packet_in.value[15:0];
                            nx_d_cache[i][st_inst_index].block_data = cache_type.half_level;
                        end
                        WORD: begin
							// assert(sq_packet_in.store_address[1:0] == 0);
							cache_type.word_level[sq_packet_in.store_address[2]] = sq_packet_in.value[31:0];
                            nx_d_cache[i][st_inst_index].block_data = cache_type.word_level;
                        end
                        default: begin
							// assert(sq_packet_in.store_address[1:0] == 0);
							cache_type.byte_level[sq_packet_in.store_address[2]] = sq_packet_in.value[31:0];
                            nx_d_cache[i][st_inst_index].block_data = cache_type.word_level;
                        end
				endcase
        end
        else if(!st_Dcache_hit && sq_packet_in.address_value_valid)begin ///writing to MSHR
                st_Dcache_hit=1'b0;
                st_Dcache_miss=1'b1;
                lsq2st_valid_mshr = 1'b1;
                lsq2Dcache_addr_mshr = sq_packet_in.store_address;
                lsq2Dcache_data_mshr = sq_packet_in.value;
                st_mem_size_mshr = sq_packet_in.mem_size;
        end
    // end
end

for(int i=0;i<`CACHE_Assoc;i++)begin
    if(i!=st_hit_assoc_num  && nx_d_cache[i][st_inst_index].LRU_num<st_hit_lru_num && st_Dcache_hit)begin
        nx_d_cache[i][st_inst_index].LRU_num = nx_d_cache[i][st_inst_index].LRU_num+1;
    end
    else begin
        nx_d_cache[i][st_inst_index].LRU_num = nx_d_cache[i][st_inst_index].LRU_num;
    end
end


///////////////////load hit or miss//////////////////////////////
for(int i=0;i<`CACHE_Assoc;i++)begin
    // for(int j=0;j<`Cache_depth;j++)begin
      if(!ld_cache_hit_mask_mshr && nx_d_cache[i][ld_inst_index].tag==ld_inst_tag && ex_ld_packet_in.rd_mem && nx_d_cache[i][ld_inst_index].block_valid && !hit_in_other)begin //
                // ld_hit_index_num = j;
                ld_hit_assoc_num = i;
                ld_hit_lru_num = nx_d_cache[i][ld_inst_index].LRU_num;
                cache_type.byte_level = nx_d_cache[i][ld_inst_index].block_data;
                cache_type.half_level = nx_d_cache[i][ld_inst_index].block_data;
                cache_type.word_level = nx_d_cache[i][ld_inst_index].block_data;
                // pre_ld_Dcache_hit[i]=1'b1;
                ld_Dcache_hit = 1'b1;
                ld_Dcache_miss = 1'b0;
                ex_ld_packet_to_ex = ex_ld_packet_in;
                nx_d_cache[i][ld_inst_index].LRU_num = 0;
                // pre_ld_Dcache_miss[i]=1'b0;
                // pre_hit_loading_block_data[i]=nx_d_cache[i][j].block_data;
                case (ex_ld_packet_in.mem_size)
                        BYTE: begin
							ld_Dcache_hit_data = {24'b0, cache_type.byte_level[ex_ld_packet_in.alu_result[2:0]]};
                        end
                        HALF: begin
							// assert(ex_ld_packet_in.alu_result[0] == 0);
							ld_Dcache_hit_data = {16'b0, cache_type.half_level[ex_ld_packet_in.alu_result[2:1]]};
                        end
                        WORD: begin
							// assert(ex_ld_packet_in.alu_result[1:0] == 0);
							ld_Dcache_hit_data=  cache_type.word_level[ex_ld_packet_in.alu_result[2]];
                        end
                        default:begin
							// assert(ex_ld_packet_in.alu_result[1:0] == 0);
							ld_Dcache_hit_data =  cache_type.word_level[ex_ld_packet_in.alu_result[2]];
                        end
						// DOUBLE:
						// 	loaded_data[i] = unified_memory[proc2mem_addr[`XLEN-1:3]];
					endcase
                ex_ld_packet_to_ex.alu_result = ld_Dcache_hit_data;
                ex_ld_packet_to_mshr.rd_mem = 1'b0;
                ex_ld_packet_to_mshr.valid = 1'b0;
        end
        else if(!ld_Dcache_hit && ex_ld_packet_in.rd_mem && !hit_in_other)begin ///writing to MSHR
            ld_Dcache_hit=1'b0;
            ld_Dcache_miss=1'b1;
            ex_ld_packet_to_mshr = ex_ld_packet_in;
        end
    // end
end

for(int i=0;i<`CACHE_Assoc;i++)begin
    if(i!=ld_hit_assoc_num  && nx_d_cache[i][ld_inst_index].LRU_num<ld_hit_lru_num && ld_Dcache_hit)begin
        nx_d_cache[i][ld_inst_index].LRU_num = nx_d_cache[i][ld_inst_index].LRU_num+1;
    end
    else begin
        nx_d_cache[i][ld_inst_index].LRU_num = nx_d_cache[i][ld_inst_index].LRU_num;
    end
end

if(avail_MSHR=='d3)begin
    ex_ld_packet_to_mshr_out = ex_ld_packet_to_mshr;
    sq_packet_mshr_out.address_value_valid=lsq2st_valid_mshr;
    sq_packet_mshr_out.store_address=lsq2Dcache_addr_mshr;
    sq_packet_mshr_out.value=lsq2Dcache_data_mshr;
    sq_packet_mshr_out.mem_size=st_mem_size_mshr;
    sq_packet_mshr_out.inst = sq_packet_in.inst;
    sq_packet_mshr_out.PC = sq_packet_in.PC;
    sq_packet_mshr_out.NPC = sq_packet_in.NPC;
    sq_packet_mshr_out.wr_mem = sq_packet_in.wr_mem;
    sq_packet_mshr_out.rd_mem = sq_packet_in.rd_mem;

    ld_Dcache_hit_out=ld_Dcache_hit;
    st_Dcache_hit_out=st_Dcache_hit;
    ld_Dcache_miss_out=ld_Dcache_miss;
    st_Dcache_miss_out=st_Dcache_miss;

    evicting_en_out=evicting_en;         // this block is dirty and need to write back to MEM
    evicting_addr_out=evicting_addr;
    evicting_data_out=evicting_data;
end
else if(avail_MSHR=='d2)begin
    ex_ld_packet_to_mshr_out = 0;

    sq_packet_mshr_out.address_value_valid=lsq2st_valid_mshr;
    sq_packet_mshr_out.store_address=lsq2Dcache_addr_mshr;
    sq_packet_mshr_out.value=lsq2Dcache_data_mshr;
    sq_packet_mshr_out.mem_size=st_mem_size_mshr;
    sq_packet_mshr_out.inst = sq_packet_in.inst;
    sq_packet_mshr_out.PC = sq_packet_in.PC;
    sq_packet_mshr_out.NPC = sq_packet_in.NPC;
    sq_packet_mshr_out.wr_mem = sq_packet_in.wr_mem;
    sq_packet_mshr_out.rd_mem = sq_packet_in.rd_mem;

    ld_Dcache_hit_out=0;
    st_Dcache_hit_out=st_Dcache_hit;
    ld_Dcache_miss_out=0;
    st_Dcache_miss_out=st_Dcache_miss;

    stop_sq_retire_en = 1'b0;           //stop store retire
    stop_is_en = 1'b1;                  //stop load is

    evicting_en_out=evicting_en;         // this block is dirty and need to write back to MEM
    evicting_addr_out=evicting_addr;
    evicting_data_out=evicting_data;

end
else if(avail_MSHR=='d1)begin
    ex_ld_packet_to_mshr_out.rd_mem = 1'b0;
    ex_ld_packet_to_mshr_out.valid = 1'b0;
    ex_ld_packet_to_mshr_out = 0;
    sq_packet_mshr_out.address_value_valid=0;
    sq_packet_mshr_out.store_address=0;
    sq_packet_mshr_out.value=0;
    sq_packet_mshr_out.mem_size=0;
    sq_packet_mshr_out.inst = 0;
    sq_packet_mshr_out.PC = 0;
    sq_packet_mshr_out.NPC = 0;
    sq_packet_mshr_out.wr_mem = 0;
    sq_packet_mshr_out.rd_mem = 0;
    stop_sq_retire_en = 1'b1;
    stop_is_en = 1'b1;  //stop load issue
    stop_is_st_en=1'b1;

    ld_Dcache_hit_out=0;
    st_Dcache_hit_out=0;
    ld_Dcache_miss_out=0;
    st_Dcache_miss_out=0;

    evicting_en_out=evicting_en;         // this block is dirty and need to write back to MEM
    evicting_addr_out=evicting_addr;
    evicting_data_out=evicting_data;
end
else begin
    ex_ld_packet_to_mshr_out.rd_mem = 1'b0;
    ex_ld_packet_to_mshr_out.valid = 1'b0;
    sq_packet_mshr_out.address_value_valid=0;
    sq_packet_mshr_out.store_address=0;
    sq_packet_mshr_out.value=0;
    sq_packet_mshr_out.mem_size=0;
    sq_packet_mshr_out.inst = 0;
    sq_packet_mshr_out.PC = 0;
    sq_packet_mshr_out.NPC = 0;
    sq_packet_mshr_out.wr_mem = 0;
    sq_packet_mshr_out.rd_mem = 0;
    stop_sq_retire_en = 1'b1;
    stop_is_en = 1'b1;
    stop_is_st_en=1'b1;

    ld_Dcache_hit_out=0;
    st_Dcache_hit_out=0;
    ld_Dcache_miss_out=0;
    st_Dcache_miss_out=0;

    evicting_en_out=1'b0; 

end




end//end comb_logic

/////////////////////////sequential logic////////////////////////////////
always_ff @(posedge clock)begin
    if(reset)begin
        // d_cache<=`SD 'd0;
        for(int i=0;i<`CACHE_Assoc;i++)begin
            for(int j=0;j<`Cache_depth;j++)begin
                d_cache[i][j].block_valid <=`SD 1'b0;
                d_cache[i][j].dirty <=`SD 1'b0;
                d_cache[i][j].LRU_num <=`SD i;
                d_cache[i][j].block_data <=`SD 'd0;
                d_cache[i][j].tag <=`SD 'd0;
            end
        end
    end
    else begin
        d_cache<=`SD nx_d_cache;
    end
end

endmodule
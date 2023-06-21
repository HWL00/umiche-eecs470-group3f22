/*
 *  pipe_print.c - Print instructions as they pass through the verisimple
 *                 pipeline.  Must compile with the '+vc' vcs flag.
 *
 *  Doug MacKay <dmackay@umich.edu> Fall 2003
 *
 *  Updated for RISC-V by C Jones, Winter 2019
 */

#include <stdio.h>

#define NOOP_INST 0x00000013

static int cycle_count = 0;
static FILE* ppfile = NULL;
static FILE* ppfile_connected = NULL;
static FILE* ppfile_physical = NULL;
static FILE* ppfile_lsq_dcache = NULL;

//------pipeline print-----------------------------------------------------------------------------
void print_header(char* str)
{
  if (ppfile == NULL)
    ppfile = fopen("pipeline.out", "w");

  fprintf(ppfile, "%s", str);
}

void print_cycles()
{
  /* we'll enforce the printing of a header */
  if (ppfile != NULL)
    fprintf(ppfile, "\n cycle: %5d", cycle_count);
}


void print_stage(char* div, int inst, int npc, int valid_inst)
{
  int opcode, funct3, funct7, funct12;
  char *str;
  
  if(!valid_inst)
    str = "-";
  else if(inst==NOOP_INST)
    str = "nop";
  else {
    opcode = inst & 0x7f;
    funct3 = (inst>>12) & 0x7;
    funct7 = inst>>25;
    funct12 = inst>>20; // for system instructions
    // See the RV32I base instruction set table
    switch (opcode) {
    case 0x37: str = "lui"; break;
    case 0x17: str = "auipc"; break;
    case 0x6f: str = "jal"; break;
    case 0x67: str = "jalr"; break;
    case 0x63: // branch
      switch (funct3) {
      case 0b000: str = "beq"; break;
      case 0b001: str = "bne"; break;
      case 0b100: str = "blt"; break;
      case 0b101: str = "bge"; break;
      case 0b110: str = "bltu"; break;
      case 0b111: str = "bgeu"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x03: // load
      switch (funct3) {
      case 0b000: str = "lb"; break;
      case 0b001: str = "lh"; break;
      case 0b010: str = "lw"; break;
      case 0b100: str = "lbu"; break;
      case 0b101: str = "lhu"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x23: // store
      switch (funct3) {
      case 0b000: str = "sb"; break;
      case 0b001: str = "sh"; break;
      case 0b010: str = "sw"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x13: // immediate
      switch (funct3) {
      case 0b000: str = "addi"; break;
      case 0b010: str = "slti"; break;
      case 0b011: str = "sltiu"; break;
      case 0b100: str = "xori"; break;
      case 0b110: str = "ori"; break;
      case 0b111: str = "andi"; break;
      case 0b001:
        if (funct7 == 0x00) str = "slli";
        else str = "invalid";
        break;
      case 0b101:
        if (funct7 == 0x00) str = "srli";
        else if (funct7 == 0x20) str = "srai";
        else str = "invalid";
        break;
      }
      break;
    case 0x33: // arithmetic
      switch (funct7 << 4 | funct3) {
      case 0x000: str = "add"; break;
      case 0x200: str = "sub"; break;
      case 0x001: str = "sll"; break;
      case 0x002: str = "slt"; break;
      case 0x003: str = "sltu"; break;
      case 0x004: str = "xor"; break;
      case 0x005: str = "srl"; break;
      case 0x205: str = "sra"; break;
      case 0x006: str = "or"; break;
      case 0x007: str = "and"; break;
      // M extension
      case 0x010: str = "mul"; break;
      case 0x011: str = "mulh"; break;
      case 0x012: str = "mulhsu"; break;
      case 0x013: str = "mulhu"; break;
      case 0x014: str = "div"; break;  // unimplemented
      case 0x015: str = "divu"; break; // unimplemented
      case 0x016: str = "rem"; break;  // unimplemented
      case 0x017: str = "remu"; break; // unimplemented
      default: str = "invalid"; break;
      }
      break;
    case 0x0f: str = "fence"; break; // unimplemented, imprecise 
    case 0x73:
      switch (funct3) {
      case 0b000:
        // unimplemented, somewhat inaccurate :(
        switch (funct12) {
        case 0x000: str = "ecall"; break;
        case 0x001: str = "ebreak"; break;
        case 0x105: str = "wfi"; break; // we just mostly care about this
        default: str = "system"; break;
        }
        break;
      case 0b001: str = "csrrw"; break;
      case 0b010: str = "csrrs"; break;
      case 0b011: str = "csrrc"; break;
      case 0b101: str = "csrrwi"; break;
      case 0b110: str = "csrrsi"; break;
      case 0b111: str = "csrrci"; break;
      default: str = "invalid"; break;
      }
      break;
    default: str = "invalid"; break;
    }
  }

  if (ppfile != NULL)
    fprintf(ppfile, "%s%4x:%-8s", div, npc, str);
}

void print_close()
{
  fprintf(ppfile, "\n");
  fclose(ppfile);
  ppfile = NULL;
}
//------------------Physical register file-----------------------------------------------------------------
void print_header_physical(char* str)
{
  if (ppfile_physical == NULL)
    ppfile_physical = fopen("Physical_register_file.out", "w");
  fprintf(ppfile_physical, "%s\n", str);
}


void print_cycles_physical()
{
  /* we'll enforce the printing of a header */
   if (ppfile_physical == NULL)
    ppfile_physical = fopen("Physical_register_file.out", "w");

  fprintf(ppfile_physical, "cycle: %5d \n", cycle_count-1);
}

void print_close_physical()
{
  fprintf(ppfile_physical, "\n");
  fclose(ppfile_physical);
  ppfile_physical = NULL;
}

void print_physical(int i, int value)
{

  if (ppfile_physical == NULL)
    ppfile_physical = fopen("Physical_register_file.out", "w");
  fprintf(ppfile_physical, " | \t %8d \t| \t %8d \t|\n",i, value);
}
//------connected ROB RS print-----------------------------------------------------------------------------


void print_header_connected(char* str)
{
  if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");
  fprintf(ppfile_connected, "%s\n", str);
}


void print_cycles_connected()
{
  /* we'll enforce the printing of a header */
   if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");

  fprintf(ppfile_connected, "cycle: %5d \n", cycle_count++-1);
}

void print_stage_connected(int inst, int valid_inst)
{
  int opcode, funct3, funct7, funct12;
  char *str;
  
  if(!valid_inst)
    str = "-";
  else if(inst==NOOP_INST)
    str = "nop";
  else {
    opcode = inst & 0x7f;
    funct3 = (inst>>12) & 0x7;
    funct7 = inst>>25;
    funct12 = inst>>20; // for system instructions
    // See the RV32I base instruction set table
    switch (opcode) {
    case 0x37: str = "lui"; break;
    case 0x17: str = "auipc"; break;
    case 0x6f: str = "jal"; break;
    case 0x67: str = "jalr"; break;
    case 0x63: // branch
      switch (funct3) {
      case 0b000: str = "beq"; break;
      case 0b001: str = "bne"; break;
      case 0b100: str = "blt"; break;
      case 0b101: str = "bge"; break;
      case 0b110: str = "bltu"; break;
      case 0b111: str = "bgeu"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x03: // load
      switch (funct3) {
      case 0b000: str = "lb"; break;
      case 0b001: str = "lh"; break;
      case 0b010: str = "lw"; break;
      case 0b100: str = "lbu"; break;
      case 0b101: str = "lhu"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x23: // store
      switch (funct3) {
      case 0b000: str = "sb"; break;
      case 0b001: str = "sh"; break;
      case 0b010: str = "sw"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x13: // immediate
      switch (funct3) {
      case 0b000: str = "addi"; break;
      case 0b010: str = "slti"; break;
      case 0b011: str = "sltiu"; break;
      case 0b100: str = "xori"; break;
      case 0b110: str = "ori"; break;
      case 0b111: str = "andi"; break;
      case 0b001:
        if (funct7 == 0x00) str = "slli";
        else str = "invalid";
        break;
      case 0b101:
        if (funct7 == 0x00) str = "srli";
        else if (funct7 == 0x20) str = "srai";
        else str = "invalid";
        break;
      }
      break;
    case 0x33: // arithmetic
      switch (funct7 << 4 | funct3) {
      case 0x000: str = "add"; break;
      case 0x200: str = "sub"; break;
      case 0x001: str = "sll"; break;
      case 0x002: str = "slt"; break;
      case 0x003: str = "sltu"; break;
      case 0x004: str = "xor"; break;
      case 0x005: str = "srl"; break;
      case 0x205: str = "sra"; break;
      case 0x006: str = "or"; break;
      case 0x007: str = "and"; break;
      // M extension
      case 0x010: str = "mul"; break;
      case 0x011: str = "mulh"; break;
      case 0x012: str = "mulhsu"; break;
      case 0x013: str = "mulhu"; break;
      case 0x014: str = "div"; break;  // unimplemented
      case 0x015: str = "divu"; break; // unimplemented
      case 0x016: str = "rem"; break;  // unimplemented
      case 0x017: str = "remu"; break; // unimplemented
      default: str = "invalid"; break;
      }
      break;
    case 0x0f: str = "fence"; break; // unimplemented, imprecise 
    case 0x73:
      switch (funct3) {
      case 0b000:
        // unimplemented, somewhat inaccurate :(
        switch (funct12) {
        case 0x000: str = "ecall"; break;
        case 0x001: str = "ebreak"; break;
        case 0x105: str = "wfi"; break; // we just mostly care about this
        default: str = "system"; break;
        }
        break;
      case 0b001: str = "csrrw"; break;
      case 0b010: str = "csrrs"; break;
      case 0b011: str = "csrrc"; break;
      case 0b101: str = "csrrwi"; break;
      case 0b110: str = "csrrsi"; break;
      case 0b111: str = "csrrci"; break;
      default: str = "invalid"; break;
      }
      break;
    default: str = "invalid"; break;
    }
  }

  if (ppfile_connected != NULL)
    fprintf(ppfile_connected, "%8s \t ", str);
}



void print_close_connected()
{
  fprintf(ppfile_connected, "\n");
  fclose(ppfile_connected);
  ppfile_connected = NULL;
}


void print_ROB(int inst, int Preg, int Preg_ready_bit, int Preg_old)
{

  if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");
  print_stage_connected(inst,1);
  fprintf(ppfile_connected, " | \t %3d \t| \t %3d \t | \t %3d \t|                ",Preg, Preg_ready_bit, Preg_old);
  //fprintf(ppfile, "  \t %3d \t| \t %3d \t| \t %3d \t | \t %3d \t \n",inst,Preg, Preg_ready_bit, Preg_old);
}

void print_RS(int inst, int p_rd, int preg1, int preg2 , int preg1_ready,int preg2_ready ,int busy)
{

  if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");
  print_stage_connected(inst,1);
  fprintf(ppfile_connected, "| \t %3d \t | \t %3d \t | \t %3d \t| \t %3d \t| \t %3d \t| \t %3d \t \n", 
    p_rd, preg1, preg2 , preg1_ready, preg2_ready , busy);

}


void print_IS(int inst,int p_dest_reg_idx,int valid){
  if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");
  print_stage_connected(inst,1);
  fprintf(ppfile_connected, "| \t %3d \t | \t %3d \t                  \t ",  p_dest_reg_idx, valid);
}

void print_Freelist(int i, int Preg)
{

  if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");
  fprintf(ppfile_connected, "\t %3d \t | \t %3d \t \n", i,Preg);

}

void print_RAT(int i, int Preg, int ready_bit)
{

  if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");
  fprintf(ppfile_connected, "\t %3d \t | \t %3d \t | \t %3d \t |                              ", i,Preg,ready_bit);

}


void print_RRAT(int i, int Preg, int ready_bit)
{

  if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");
  fprintf(ppfile_connected, "\t %3d \t | \t %3d \t | \t %3d \t  \n", i,Preg,ready_bit);

}



print_CDB(int i,int Rd_Preg_CDB,int Preg_result,int valid,int rob_tail)
{
  if (ppfile_connected == NULL)
    ppfile_connected = fopen("print_connected_ROB_RS.out", "w");
  fprintf(ppfile_connected, "\t %3d \t | \t %3d \t | \t %3d \t| \t %3d \t | \t %3d \t  \n", i,Rd_Preg_CDB,Preg_result,valid,rob_tail);
}



//-----------------------------others print
void print_reg(int wb_reg_wr_data_out_hi, int wb_reg_wr_data_out_lo,
                  int wb_reg_wr_idx_out, int wb_reg_wr_en_out)
{
  if (ppfile == NULL)
    return;

  if(wb_reg_wr_en_out)
    if((wb_reg_wr_data_out_hi==0)||
       ((wb_reg_wr_data_out_hi==-1)&&(wb_reg_wr_data_out_lo<0)))
      fprintf(ppfile, "r%d=%d  ",wb_reg_wr_idx_out,wb_reg_wr_data_out_lo);
    else 
      fprintf(ppfile, "r%d=0x%x%x  ",wb_reg_wr_idx_out,
              wb_reg_wr_data_out_hi,wb_reg_wr_data_out_lo);

}

void print_membus(int proc2mem_command, int mem2proc_response,
                  int proc2mem_addr_hi, int proc2mem_addr_lo,
                  int proc2mem_data_hi, int proc2mem_data_lo)
{
  if (ppfile == NULL)
    return;

  switch(proc2mem_command)
  {
    case 1: fprintf(ppfile, "BUS_LOAD  MEM["); break;
    case 2: fprintf(ppfile, "BUS_STORE MEM["); break;
    default: return; break;
  }
  
  if((proc2mem_addr_hi==0)||
     ((proc2mem_addr_hi==-1)&&(proc2mem_addr_lo<0)))
    fprintf(ppfile, "%d",proc2mem_addr_lo);
  else
    fprintf(ppfile, "0x%x%x",proc2mem_addr_hi,proc2mem_addr_lo);
  if(proc2mem_command==1)
  {
    fprintf(ppfile, "]");
  } else {
    fprintf(ppfile, "] = ");
    if((proc2mem_data_hi==0)||
       ((proc2mem_data_hi==-1)&&(proc2mem_data_lo<0)))
      fprintf(ppfile, "%d",proc2mem_data_lo);
    else
      fprintf(ppfile, "0x%x%x",proc2mem_data_hi,proc2mem_data_lo);
  }
  if(mem2proc_response) {
    fprintf(ppfile, " accepted %d",mem2proc_response);
  } else {
    fprintf(ppfile, " rejected");
  }
}

//------connected LSQ MSHR print-----------------------------------------------------------------------------
void print_header_lsq_dcache(char* str)
{
  if (ppfile_lsq_dcache == NULL)
    ppfile_lsq_dcache = fopen("print_connected_lsq_dcache.out", "w");

  fprintf(ppfile_lsq_dcache, "%s\n", str);
}

void print_cycles_lsq_dcache()
{
  /* we'll enforce the printing of a header */
  if (ppfile_lsq_dcache == NULL)
    ppfile_lsq_dcache = fopen("print_connected_lsq_dcache.out", "w");
  fprintf(ppfile_lsq_dcache, "cycle: %5d \n", cycle_count-1);
}


void print_stage_lsq_dcache(int inst, int valid_inst)
{
  int opcode, funct3, funct7, funct12;
  char *str;
  
  if(!valid_inst)
    str = "-";
  else if(inst==NOOP_INST)
    str = "nop";
  else {
    opcode = inst & 0x7f;
    funct3 = (inst>>12) & 0x7;
    funct7 = inst>>25;
    funct12 = inst>>20; // for system instructions
    // See the RV32I base instruction set table
    switch (opcode) {
    case 0x37: str = "lui"; break;
    case 0x17: str = "auipc"; break;
    case 0x6f: str = "jal"; break;
    case 0x67: str = "jalr"; break;
    case 0x63: // branch
      switch (funct3) {
      case 0b000: str = "beq"; break;
      case 0b001: str = "bne"; break;
      case 0b100: str = "blt"; break;
      case 0b101: str = "bge"; break;
      case 0b110: str = "bltu"; break;
      case 0b111: str = "bgeu"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x03: // load
      switch (funct3) {
      case 0b000: str = "lb"; break;
      case 0b001: str = "lh"; break;
      case 0b010: str = "lw"; break;
      case 0b100: str = "lbu"; break;
      case 0b101: str = "lhu"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x23: // store
      switch (funct3) {
      case 0b000: str = "sb"; break;
      case 0b001: str = "sh"; break;
      case 0b010: str = "sw"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x13: // immediate
      switch (funct3) {
      case 0b000: str = "addi"; break;
      case 0b010: str = "slti"; break;
      case 0b011: str = "sltiu"; break;
      case 0b100: str = "xori"; break;
      case 0b110: str = "ori"; break;
      case 0b111: str = "andi"; break;
      case 0b001:
        if (funct7 == 0x00) str = "slli";
        else str = "invalid";
        break;
      case 0b101:
        if (funct7 == 0x00) str = "srli";
        else if (funct7 == 0x20) str = "srai";
        else str = "invalid";
        break;
      }
      break;
    case 0x33: // arithmetic
      switch (funct7 << 4 | funct3) {
      case 0x000: str = "add"; break;
      case 0x200: str = "sub"; break;
      case 0x001: str = "sll"; break;
      case 0x002: str = "slt"; break;
      case 0x003: str = "sltu"; break;
      case 0x004: str = "xor"; break;
      case 0x005: str = "srl"; break;
      case 0x205: str = "sra"; break;
      case 0x006: str = "or"; break;
      case 0x007: str = "and"; break;
      // M extension
      case 0x010: str = "mul"; break;
      case 0x011: str = "mulh"; break;
      case 0x012: str = "mulhsu"; break;
      case 0x013: str = "mulhu"; break;
      case 0x014: str = "div"; break;  // unimplemented
      case 0x015: str = "divu"; break; // unimplemented
      case 0x016: str = "rem"; break;  // unimplemented
      case 0x017: str = "remu"; break; // unimplemented
      default: str = "invalid"; break;
      }
      break;
    case 0x0f: str = "fence"; break; // unimplemented, imprecise 
    case 0x73:
      switch (funct3) {
      case 0b000:
        // unimplemented, somewhat inaccurate :(
        switch (funct12) {
        case 0x000: str = "ecall"; break;
        case 0x001: str = "ebreak"; break;
        case 0x105: str = "wfi"; break; // we just mostly care about this
        default: str = "system"; break;
        }
        break;
      case 0b001: str = "csrrw"; break;
      case 0b010: str = "csrrs"; break;
      case 0b011: str = "csrrc"; break;
      case 0b101: str = "csrrwi"; break;
      case 0b110: str = "csrrsi"; break;
      case 0b111: str = "csrrci"; break;
      default: str = "invalid"; break;
      }
      break;
    default: str = "invalid"; break;
    }
  }

  if (ppfile_lsq_dcache != NULL)
    fprintf(ppfile_lsq_dcache, "%8s \t ", str);
}

void print_dcache(int i,int block_data_hi,int block_data_lo,int tag,int LRU_num,int dirty,int block_valid){
  if (ppfile_lsq_dcache == NULL)
    ppfile_lsq_dcache = fopen("print_connected_lsq_dcache.out", "w");
  fprintf(ppfile_lsq_dcache, " \t %3d \t  | \t %8x%8x \t   | \t %6x \t  | \t %3d \t | \t  %3d \t   | \t %3d \t 	                ",  i, block_data_hi,block_data_lo, tag, LRU_num, dirty, block_valid);

}

void print_mshr_state(int MSHR_state ){
  char *str;
  switch(MSHR_state){
    case 0: str = "IDLE";break;
    case 1: str = "LOAD_MISS_WAITTING_BUS";break;
    case 2: str = "STORE_MISS_WAITTING_BUS";break;
    case 3: str = "LOAD_MISS_IN_USE";break;
    case 4: str = "STORE_MISS_IN_USE";break;
    case 5: str = "LOAD_COMPLETE";break;
    case 6: str = "STORE_COMPLETE";break;
    case 7: str = "WAIT_EVICT";break;
    case 8: str = "EVICTING";break;
    case 9: str = "EVICT_COMPLETE";break;
    case 10: str = "INDEX_DEPEND";break;
    case 11: str = "ADDR_DEPEND";break;
    default: str = "IDLE";break;
  }
  if (ppfile_lsq_dcache != NULL)
    fprintf(ppfile_lsq_dcache, "| %25s \t ", str);
}

void print_LSQ(int inst,int store_address,int value_hi,int value_lo,int address_value_valid,int ROB_pointer,int Retire_enable){
  if (ppfile_lsq_dcache == NULL)
    ppfile_lsq_dcache = fopen("print_connected_lsq_dcache.out", "w");
  print_stage_lsq_dcache(inst,1);
  fprintf(ppfile_lsq_dcache, "| \t %8x \t   | \t %8x%8x \t  | \t %3d \t | \t  %3d \t   | \t %3d \t \n",  store_address, value_hi,value_lo, address_value_valid, ROB_pointer, Retire_enable);
}

void print_MSHR(int inst,int MSHR_state,int link_entry,int MSHR_addr,int MSHR_data_hi,int MSHR_data_lo,int st_data,int linked_idx_en,int linked_addr_en,int ld_rd_preg,int mem_tag){
  if (ppfile_lsq_dcache == NULL)
    ppfile_lsq_dcache = fopen("print_connected_lsq_dcache.out", "w");
  print_stage_lsq_dcache(inst,1);
  print_mshr_state(MSHR_state);
  fprintf(ppfile_lsq_dcache, "| \t %3d \t  | \t %8x \t      | \t %8x%8x \t   | \t %8x \t| \t %3d \t     | \t %3d 	        | \t %3d \t | \t %3d \t \n",   link_entry,MSHR_addr,MSHR_data_hi,MSHR_data_lo,st_data,linked_idx_en,linked_addr_en,ld_rd_preg,mem_tag);
}

void print_close_lsq_dcache()
{
  fprintf(ppfile_lsq_dcache, "\n");
  fclose(ppfile_lsq_dcache);
  ppfile_lsq_dcache = NULL;
}


static FILE* ppfile_icache = NULL;

void print_header_icache(char* str)
{
  if (ppfile_icache == NULL)
    ppfile_icache = fopen("print_icache.out", "w");

  fprintf(ppfile_icache, "%s\n", str);
}

void print_cycles_icache()
{
  /* we'll enforce the printing of a header */
  if (ppfile_icache == NULL)
    ppfile_icache = fopen("print_icache.out", "w");
  fprintf(ppfile_icache, "cycle: %5d \n", cycle_count);
}


void print_stage_icache(int inst, int valid_inst)
{
  int opcode, funct3, funct7, funct12;
  char *str;
  
  if(!valid_inst)
    str = "-";
  else if(inst==NOOP_INST)
    str = "nop";
  else {
    opcode = inst & 0x7f;
    funct3 = (inst>>12) & 0x7;
    funct7 = inst>>25;
    funct12 = inst>>20; // for system instructions
    // See the RV32I base instruction set table
    switch (opcode) {
    case 0x37: str = "lui"; break;
    case 0x17: str = "auipc"; break;
    case 0x6f: str = "jal"; break;
    case 0x67: str = "jalr"; break;
    case 0x63: // branch
      switch (funct3) {
      case 0b000: str = "beq"; break;
      case 0b001: str = "bne"; break;
      case 0b100: str = "blt"; break;
      case 0b101: str = "bge"; break;
      case 0b110: str = "bltu"; break;
      case 0b111: str = "bgeu"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x03: // load
      switch (funct3) {
      case 0b000: str = "lb"; break;
      case 0b001: str = "lh"; break;
      case 0b010: str = "lw"; break;
      case 0b100: str = "lbu"; break;
      case 0b101: str = "lhu"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x23: // store
      switch (funct3) {
      case 0b000: str = "sb"; break;
      case 0b001: str = "sh"; break;
      case 0b010: str = "sw"; break;
      default: str = "invalid"; break;
      }
      break;
    case 0x13: // immediate
      switch (funct3) {
      case 0b000: str = "addi"; break;
      case 0b010: str = "slti"; break;
      case 0b011: str = "sltiu"; break;
      case 0b100: str = "xori"; break;
      case 0b110: str = "ori"; break;
      case 0b111: str = "andi"; break;
      case 0b001:
        if (funct7 == 0x00) str = "slli";
        else str = "invalid";
        break;
      case 0b101:
        if (funct7 == 0x00) str = "srli";
        else if (funct7 == 0x20) str = "srai";
        else str = "invalid";
        break;
      }
      break;
    case 0x33: // arithmetic
      switch (funct7 << 4 | funct3) {
      case 0x000: str = "add"; break;
      case 0x200: str = "sub"; break;
      case 0x001: str = "sll"; break;
      case 0x002: str = "slt"; break;
      case 0x003: str = "sltu"; break;
      case 0x004: str = "xor"; break;
      case 0x005: str = "srl"; break;
      case 0x205: str = "sra"; break;
      case 0x006: str = "or"; break;
      case 0x007: str = "and"; break;
      // M extension
      case 0x010: str = "mul"; break;
      case 0x011: str = "mulh"; break;
      case 0x012: str = "mulhsu"; break;
      case 0x013: str = "mulhu"; break;
      case 0x014: str = "div"; break;  // unimplemented
      case 0x015: str = "divu"; break; // unimplemented
      case 0x016: str = "rem"; break;  // unimplemented
      case 0x017: str = "remu"; break; // unimplemented
      default: str = "invalid"; break;
      }
      break;
    case 0x0f: str = "fence"; break; // unimplemented, imprecise 
    case 0x73:
      switch (funct3) {
      case 0b000:
        // unimplemented, somewhat inaccurate :(
        switch (funct12) {
        case 0x000: str = "ecall"; break;
        case 0x001: str = "ebreak"; break;
        case 0x105: str = "wfi"; break; // we just mostly care about this
        default: str = "system"; break;
        }
        break;
      case 0b001: str = "csrrw"; break;
      case 0b010: str = "csrrs"; break;
      case 0b011: str = "csrrc"; break;
      case 0b101: str = "csrrwi"; break;
      case 0b110: str = "csrrsi"; break;
      case 0b111: str = "csrrci"; break;
      default: str = "invalid"; break;
      }
      break;
    default: str = "invalid"; break;
    }
  }

  if (ppfile_icache != NULL)
    fprintf(ppfile_icache, " %8s \t |", str);
}

void print_icache(int i,int block_data_hi,int block_data_lo,int tag,int LRU_num,int block_valid){
  if (ppfile_icache == NULL)
    ppfile_icache = fopen("print_icache.out", "w");
  print_stage_icache(block_data_hi,1);
  print_stage_icache(block_data_lo,1);
  fprintf(ppfile_icache, " \t %3d \t  | \t %8x  %8x \t   | \t %6x \t  | \t %3d \t | \t %3d \t 	                ",  i, block_data_hi, block_data_lo,tag, LRU_num, block_valid);

}

void print_icache_mshr_state(int MSHR_state ){
  char *str;
  switch(MSHR_state){
    case 0: str = "      IDLE       ";break;
    case 1: str = "MISS_WAITTING_BUS";break;
    case 2: str = "   MISS_IN_USE   ";break;
    case 3: str = "     COMPLETE    ";break;
    default: str = "      IDLE       ";break;
  }
  if (ppfile_icache != NULL)
    fprintf(ppfile_icache, " %10s \t |", str);
}


void print_icache_MSHR(int MSHR_state,int MSHR_addr,int MSHR_data_hi,int MSHR_data_lo,int mem_tag){
  if (ppfile_icache == NULL)
    ppfile_icache = fopen("print_icache.out", "w");
  
  print_icache_mshr_state(MSHR_state);
  print_stage_icache(MSHR_data_hi,1);
  print_stage_icache(MSHR_data_lo,1);
  fprintf(ppfile_icache, " \t %8x \t      | \t %8x  %8x \t   | \t %3d 	   \n",   MSHR_addr,MSHR_data_hi,MSHR_data_lo,mem_tag);
}

void print_close_icache()
{
  fprintf(ppfile_icache, "\n");
  fclose(ppfile_icache);
  ppfile_icache = NULL;
}
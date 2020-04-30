`timescale 1ns / 1ps

module edge_check_top(
    //------
    input       sys_clk                         ,
    input       sys_rst                         ,

    //------
    input       signal_in                       ,
    output wire signal_out                          

    );    
    
    //---------------------------------------------------------------
    //------signal_in  = 8kHz = 125us          = 125_000ns
    //------signal_out = signal_in * 1/2 * 1/2 =  31_250ns @50% duty
    //------signal_out = signal_in * 1/2 * 0.8 =  50_000ns @80% duty
    //---------------------------------------------------------------
    //------parameter
    parameter   CNT_NUM_50  =   32'd31_25       ;//3125 * 10ns = 31_250ns @100MHz
      
    parameter   CNT_NUM_80  =   32'd50_00       ;//5000 * 10ns = 50_000ns @100MHz     
    
    //---------------------------------------------------------------
    wire        edge_check                      ;
    wire        edge_rise                       ;
    wire        edge_down                       ;
    
    reg         edge_reg1                       ;
    reg         edge_reg2                       ;
    
    always@(posedge sys_clk or posedge sys_rst)  //------edge_check
    begin
        if(sys_rst)
        begin
            edge_reg1      <=  1'b0             ;
            edge_reg2      <=  1'b0             ;
        end
        else
        begin
            edge_reg1      <=  signal_in        ;
            edge_reg2      <=  edge_reg1        ;
        end
    end
    
    assign  edge_rise   =   (  (!edge_reg2) & (edge_reg1)  )? 1'b1:1'b0   ;
    assign  edge_down   =   (  (edge_reg2)  & (!edge_reg1) )? 1'b1:1'b0   ;
    
/*    
    assign  edge_rise   =   ( {edge_reg2,edge_reg1} ==2'b01)? 1'b1:1'b0   ;
    assign  edge_down   =   (({edge_reg2,edge_reg1} ==2'b10)? 1'b1:1'b0   ;
*/    
    assign  edge_check  =   edge_rise | edge_down                         ;
    
    //---------------------------------------------------------------cnt_start , cnt
    reg         cnt_start                       ;
    reg [31:00] cnt                             ;
    
    always@(posedge sys_clk or posedge sys_rst)  //------cnt_start
    begin
        if(sys_rst)
        begin
            cnt_start     <=  1'b0              ;
        end
        else if(cnt == CNT_NUM_80 - 1'b1)
        begin
            cnt_start     <=  1'b0              ;
        end
        else if( ({edge_reg1,signal_in}==2'b01) || ({edge_reg1,signal_in}==2'b10) )
//        else if( (edge_rise == 1'b1) || (edge_down == 1'b1) )
        begin
            cnt_start     <=  1'b1              ;
        end
        else
        begin
            cnt_start     <=  cnt_start         ;
        end
    end
    
    always@(posedge sys_clk or posedge sys_rst)  //------cnt
    begin
        if(sys_rst)
        begin
            cnt           <=  32'b0             ;
        end
        else if(cnt == CNT_NUM_80 - 1'b1)
        begin
            cnt           <=  32'b0             ;
        end
        else if(cnt_start)
        begin
            cnt           <=  cnt + 1'b1        ;
        end
        else
        begin
            cnt           <=  cnt               ;
        end
    end
    
    assign  signal_out  =   cnt_start           ;
    
    
endmodule

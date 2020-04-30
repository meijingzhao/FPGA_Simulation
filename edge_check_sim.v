`timescale 1ns / 1ps

module edge_check_sim(    );

    //------clk_rst_signals
    reg   sys_clk                   ;//100MHz
    reg   sys_rst                   ;
    //------input_signal
    wire  signal_in                 ;
    //------output_signal  
    wire  signal_out                ;
        
    //------trig signal
    reg   clk_8khz                  ;

    //------parameter
    parameter   PERIOD  =   10      ;//10ns     = 100MHz    
    parameter   TRIG    =   125000  ;//125us    =   8kHz
    
//--------------------------------------------------------------------

//------initial≥ı ºªØ
initial
begin
//    sys_clk     = 0                 ;   
    clk_8khz    = 0                 ;
    sys_rst     = 1                 ; 
  
    #100                            ;//start
    sys_rst     = 0                 ;
         
    
    #743000                         ;//stop
    sys_rst     = 1                 ;
    
//    forever #(PERIOD/2) sys_clk     = ~sys_clk      ;//100MHz = 10ns  
    
end

initial
begin
    sys_clk     = 0                 ;
    forever #(PERIOD/2) sys_clk     = ~sys_clk      ;//100MHz = 10ns   
end 
 
//	always	#(PERIOD/2) sys_clk	    = ~sys_clk	    ;//clk	ok
    
	always	#(TRIG/2)	clk_8khz    = ~clk_8khz	    ;//
	
	assign  signal_in   =   clk_8khz;
	
	
//-----------------------------------------------------	
//	always	#TRIG	clk_8khz    = ~clk_8khz	    ;//
//	always	#PERIOD	sys_clk     = ~sys_clk	    ;//
//-----------------------------------------------------

//--------------------------------------------------------------------	
//------instantiate 
    edge_check_top      u_edge_check_top(
    //------input signals    
    .sys_clk                (sys_clk                ),
    .sys_rst                (sys_rst                ),
    //------trig signals      
    .signal_in              (signal_in              ),
    .signal_out             (signal_out             )
    
    );
    
    
endmodule

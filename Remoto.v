module Remoto(clk,entrada,led,comando,su,sd,suB,sdB,led2);

parameter IDLE               = 2'b00;   
parameter GUIDANCE           = 2'b01;    
parameter DATAREAD           = 2'b10; 

parameter zera_A    = 3'b001;
parameter zera_B    = 3'b010;
parameter zera_tudo = 3'b011;
parameter soma      = 3'b100;
parameter sub       = 3'b101;
parameter muda_sinal= 3'b110;

parameter IDLE_HIGH_DUR      =  262143; 
parameter GUIDE_LOW_DUR      =  230000;  
parameter GUIDE_HIGH_DUR     =  210000;  
parameter DATA_HIGH_DUR      =  41500;
parameter BIT_AVAILABLE_DUR  =  20000;

input         clk;      
input         entrada;    
output reg led;
output reg [7:0] comando;
output reg[6:0] su;
output reg[6:0] sd;
output reg[6:0] suB;
output reg[6:0] sdB;
output reg led2;
reg [7:0] vetorA_1;
reg [7:0] vetorA_2;
reg [7:0] vetorB_1;
reg [7:0] vetorB_2;
reg [7:0]vetorA;
reg [2:0]operacao;
wire [6:0] su_1;
wire [6:0] sd_1;
reg a, a1,a11;


reg marca;
reg [7:0] pega_numero;
reg [7:0] comando_2;
reg [31:0]delay_on;
reg conta_on,on,dev;
reg    [31:0] oDATA;              
reg    [17:0] idle_count;            
reg           idle_count_flag;      
reg [32:0]delay;
reg [2:0]op;
reg [32:0]delay1;
reg    [17:0] state_count;           
reg           state_count_flag;    
reg    [17:0] data_count;           
reg           data_count_flag;     
reg     [5:0] bitcount;              
reg     [1:0] state;             
reg    [31:0] data;                
reg    [31:0] data_buf;           
reg           data_ready,a2;    
initial begin
	on = 0;
	a=1;
	led2=0;
	a1=0;
	a11=0;
	led =0;
	marca = 0;
	a2=0;
	dev<=0;
	conta_on = 0;
	vetorA_1<=8'b11111111;
	vetorA_2<=8'b11111111;
	vetorB_1<=8'b11111111;
	vetorB_2<=8'b11111111;
end
always @(posedge clk )
if ((state == IDLE) && !entrada)
			 idle_count <= idle_count + 1'b1;
		else                           
			 idle_count <= 0;	              		 	

always @(posedge clk)	
if ((state == GUIDANCE) && entrada)
			 state_count <= state_count + 1'b1;
		else  
			 state_count <= 0;	            		 	

always @(posedge clk )
if ((state == DATAREAD) && entrada)
			 data_count <= data_count + 1'b1;
		else
			 data_count <= 1'b0;        

always @(posedge clk)
if (state == DATAREAD)
		begin
			if (data_count == 20000)
					bitcount <= bitcount + 1'b1; 
		end   
	  else
	     bitcount <= 6'b0;

always @(posedge clk) 
			case (state)
 			    IDLE     : if (idle_count > GUIDE_LOW_DUR)  
			  	              state <= GUIDANCE; 
			    GUIDANCE : if (state_count > GUIDE_HIGH_DUR)
			  	              state <= DATAREAD;
			    DATAREAD : if ((data_count >= IDLE_HIGH_DUR) || (bitcount >= 33))
			  					      state <= IDLE;
	        default  : state <= IDLE; 
			 endcase

always @(posedge clk)
	  if (state == DATAREAD)
		begin
			 if (data_count >= DATA_HIGH_DUR) 
			    data[bitcount-1'b1] <= 1'b1;  
		end
		else
			 data <= 0;
always @(posedge clk) 
	  if (bitcount == 32) begin
			 if (data[31:24] == ~data[23:16])
			 begin		
					comando[7:0] <= data[23:16]; 
					data_buf <= data;
				  data_ready <= 1'b1;
			 end	
			 else
				  data_ready <= 1'b0 ;
		end
		else begin
			if (comando == 8'b00010010) begin
				comando <= 8'b11111111;
				on<=~on;
				led<=~led;
			end
			else if(comando == 00001111)begin // zera a
				comando <= 0;
				op<= zera_A;
			end
			else if(comando < 9 )begin
				comando <= 8'b11111111;
			end
			/*else begin
				case(comando)
					00001111:op <= zera_A;// 0x0F Zera A
					00010011:op <= zera_B;// 0x13 Zera B
					00010000:op <= zera_tudo;// 0x10 Zera tudo
					00011010:op <= soma;// 0x1A Soma
					00011110:op <= sub;// 0x1E Sub
					00000110:op <= muda_sinal;// 0x0C muda sinal
					default: op<=0;
				endcase
			end*/
			data_ready <= 1'b0 ;
		end



always @(posedge clk)

	  if (data_ready)
	     oDATA <= data_buf; 


always @(posedge clk) begin
	if(on && !marca)begin
		marca <= 1;
		vetorA_1<=8'b0;
		vetorA_2<=8'b0;
		vetorB_1<=8'b0;
		vetorB_2<=8'b0;
	end
	else if(!on) begin
		marca<=0;
		vetorA_1<=8'b11111111;
		vetorA_2<=8'b11111111;
		vetorB_1<=8'b11111111;
		vetorB_2<=8'b11111111;
	end
end
always @(posedge clk) begin
	if (a) begin
		
		
	end
end




always @(posedge clk) begin
		case(vetorA_1)
				0: 
					su = 7'b0000001;
	            1: 
					su = 7'b1001111;
	            2: 
					su = 7'b0010010;
	            3: 
					su = 7'b0000110;
	            4: 
					su = 7'b1001100;
	            5: 
					su = 7'b0100100;
	            6: 
					su = 7'b0100000;
	            7: 
					su = 7'b0001111;
	            8: 
					su = 7'b0000000;
	            9: 
					su = 7'b0000100;
				default:
					su = 7'b1111111;
        endcase
        
        case(vetorA_2)
	        	0: 
	        		sd = 7'b0000001;
		        1: 
		        	sd = 7'b1001111;
		        2: 
		        	sd = 7'b0010010;
		        3: 
		        	sd = 7'b0000110;
		        4: 
		        	sd = 7'b1001100;
		        5: 
		        	sd = 7'b0100100;
		        6: 
		        	sd = 7'b0100000;
		        7: 
		        	sd = 7'b0001111;
		        8: 
		        	sd = 7'b0000000;
		        9: 
		        	sd = 7'b0000100;
		        default:
					sd = 7'b1111111;

		endcase
	end	
	always @(posedge clk) begin
		case(vetorB_1)
				0: 
					suB = 7'b0000001;
	            1: 
					suB = 7'b1001111;
	            2: 
					suB = 7'b0010010;
	            3: 
					suB = 7'b0000110;
	            4: 
					suB = 7'b1001100;
	            5: 
					suB = 7'b0100100;
	            6: 
					suB = 7'b0100000;
	            7: 
					suB = 7'b0001111;
	            8: 
					suB = 7'b0000000;
	            9: 
					suB = 7'b0000100;
				default:
					suB = 7'b1111111;
        endcase
        
        case(vetorB_2)
	        	0: 
	        		sdB = 7'b0000001;
		        1: 
		        	sdB = 7'b1001111;
		        2: 
		        	sdB = 7'b0010010;
		        3: 
		        	sdB = 7'b0000110;
		        4: 
		        	sdB = 7'b1001100;
		        5: 
		        	sdB = 7'b0100100;
		        6: 
		        	sdB = 7'b0100000;
		        7: 
		        	sdB = 7'b0001111;
		        8: 
		        	sdB = 7'b0000000;
		        9: 
		        	sdB = 7'b0000100;
		        default:
					sdB = 7'b1111111;

		endcase
	end	
endmodule
module ula(clock,a,b,r,op,sb,sa);
	input [7:0]a;
	input [7:0]b;
	input op;
	input clock;
	output [8:0]r;
	output sa, sb;
	reg saa;
	reg sbb;
	reg sinal;
	reg enable;
	reg [6:0]aa;
	reg [6:0]bb;
	reg [7:0]rr;

	always @(posedge clock) begin
		saa = a[7];
		sbb = b[7];
		aa = a[6:0];
		bb = b[6:0];


		case(op)
			0: begin
				if(saa == 0 && sbb == 0)begin
					rr = aa + bb;
					sinal = 0;
				end
				if(saa == 1 && sbb == 0)begin
					if(aa > bb)begin
						rr = aa - bb;
						sinal = saa;
					end
					else begin
						rr = bb - aa;
						sinal = sbb;
					end
				end
				if(saa == 0 && sbb == 1)begin
					if(aa > bb)begin
						rr = aa - bb;
						sinal = saa;
					end
					else begin
						rr = bb - aa;
						sinal = sbb;
					end
				end
				if(saa == 1 && sbb == 1)begin
					rr = aa + bb;
					sinal = 1;
				end
			end	
			1: begin
			sbb = ~sbb;
			if(saa == 0 && sbb == 0)begin
					rr = aa + bb;
					sinal = 0;
				end
				if(saa == 1 && sbb == 0)begin
					if(aa > bb)begin
						rr = aa - bb;
						sinal = saa;
					end
					else begin
						rr = bb - aa;
						sinal = sbb;
					end
				end
				if(saa == 0 && sbb == 1)begin
					if(aa > bb)begin
						rr = aa - bb;
						sinal = saa;
					end
					else begin
						rr = bb - aa;
						sinal = sbb;
					end
				end
				if(saa == 1 && sbb == 1)begin
					rr = aa + bb;
					sinal = 1;
				end
			end	
		endcase


	end

	assign r[8] = sinal;
	assign r[7:0] = rr;
	assign sa = saa;
	assign sb = sbb;


endmodule
module bcdOut(a,b,c,d,e,f,g, a1, b1, c1, d1, e1, f1, g1, a2, b2, c2, d2, e2, f2, g2, in);
	input [8:0] in;
	output a, b, c, d, e, f, g;
	output a1, b1, c1, d1, e1, f1, g1;
	output a2, b2, c2, d2, e2, f2, g2;
	reg sinal;
	reg [7:0]uni;
	reg [7:0]dez;
	reg [7:0]dezz;
	reg [7:0]cen;
	reg [6:0] su, sd, sc;
	reg [7:0] aux;

	always begin
			sinal <= in[8];
			aux <= in[7:0];
			uni <= aux%10;
			dezz <= aux%100;
			dez <= dezz/10;
			cen <= aux/100;
			
			case(uni)
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
					su = 7'b11111110;
        endcase

        		case(dez)
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
					sd = 7'b11111110;
        endcase

        case(cen)
				0: 
					sc = 7'b0000001;
	            1: 
					sc = 7'b1001111;
				2: 
					sc = 7'b0010010;
				default:
					sc = 7'b11111110;
        endcase


	end

	assign {a, b, c, d, e, f, g} = su;
	assign {a1, b1, c1, d1, e1, f1, g1} = sd;
	assign {a2, b2, c2, d2, e2, f2, g2} = sc;

endmodule
module switch(input [3:0] Number, input RST, output  reg [3:0] num);
	always @*
	begin
	case (Number)
	4'b0001: num <= 4'b0001;
	4'b0010: num <= 4'b0010;
	4'b0100: num <= 4'b0011;
	4'b1000: num <= 4'b0100;
	default: num <= 4'b0000;
	endcase
	if (!RST)
	begin
	num <= 4'b0000;
	end
	end
endmodule
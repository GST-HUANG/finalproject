 module lab0103(
	input sysclk,check,p7,p6,p5,p4,p3,p2,p1,p0,
	output reg enable,beep,
	output reg [2:0] set,
	output reg [7:0] DATA_R,DATA_G,DATA_B,
	output reg [6:0] seg,
	output reg [2:0] COM
	
);
	byte str;
	bit clear;
	reg fail;
	reg [3:0] C_count,B_count,A_count;
	reg [2:0] cc;
	divfreq 	(sysclk ,clk_div);
	divfreq2	(sysclk ,clk_div2);
	reg [7:0] ans1,ans2,ans3;
	reg [6:0] seg1, seg2, seg3;
	BCD2Seg S0(A_count, A0,B0,C0,D0,E0,F0,G0);
	BCD2Seg S1(B_count, A1,B1,C1,D1,E1,F1,G1);
	BCD2Seg S2(C_count, A2,B2,C2,D2,E2,F2,G2);
	logic [7:0] c[7:0]=
	'{ 
		8'b11111100,
		8'b11111100,
		8'b11111100,
		8'b00000000,
		8'b00000000,
		8'b11111100,
		8'b11111100,
		8'b11111100
	};
	logic [7:0] f[7:0]=
	'{ 
		8'b11111111,
		8'b11111101,
		8'b11101101,
		8'b11101101,
		8'b11101101,
		8'b00000001,
		8'b11111111,
		8'b11111111
	};
initial 
	begin
		clear=0;
		fail=0;
		enable=1;
		ans1=8'b00000001;
		ans2=8'b00010000;
		ans3=8'b01011111;
		set=3'b000;
		DATA_B=8'b11111111;
		DATA_G=8'b11111111;
		DATA_R=8'b11111111;
		COM = 3'b000;
		cc=0;
		A_count=0;
		B_count=1;
		C_count=0;
	end	
always @(posedge check)//check answer
begin
	if(!p7==ans1[7]&&!p6==ans1[6]&&!p5==ans1[5]&&!p4==ans1[4]&&p3==ans1[3]&&p2==ans1[2]&&p1==ans1[1]&&p0==ans1[0])
		clear=1;
	else if(!p7==ans2[7]&&!p6==ans2[6]&&!p5==ans2[5]&&!p4==ans2[4]&&p3==ans2[3]&&p2==ans2[2]&&p1==ans2[1]&&p0==ans2[0])
		clear=1;
	else if(!p7==ans3[7]&&!p6==ans3[6]&&!p5==ans3[5]&&!p4==ans3[4]&&p3==ans3[3]&&p2==ans3[2]&&p1==ans3[1]&&p0==ans3[0])
		clear=1;
	beep=clear;
end

always @(posedge clk_div2)//show image
begin
	if(clear==1)
	begin
		if (set==3'b111)
			set=3'b000;
		else
			set=set+1;
		DATA_G=c[set];
		
	end
	else if(fail==1)
	begin
		if (set==3'b111)
			set=3'b000;
		else
			set=set+1;
		DATA_R=f[set];
	end
	else
	begin
		DATA_R=8'b11111111;
		DATA_G=8'b11111111;
		DATA_B=8'b11111111;
	end
end

 always@(posedge clk_div2)
	  begin
		seg1[0] = A0;
		seg1[1] = B0;
		seg1[2] = C0;
		seg1[3] = D0;
		seg1[4] = E0;
		seg1[5] = F0;
		seg1[6] = G0;
		
		seg2[0] = A1;
		seg2[1] = B1;
		seg2[2] = C1;
		seg2[3] = D1;
		seg2[4] = E1;
		seg2[5] = F1;
		seg2[6] = G1;
		
		seg3[0] = A2;
		seg3[1] = B2;
		seg3[2] = C2;
		seg3[3] = D2;
		seg3[4] = E2;
		seg3[5] = F2;
		seg3[6] = G2;
		
		if(cc == 0)
			begin
				seg <= seg1;
				COM[1] <= 1'b1;
				COM[2] <= 1'b1;
				COM[0] <= 1'b0;
				cc <= 1;
			end
		else if(cc == 1)
			begin
				seg <= seg2;
				COM[1] <= 1'b0;
				COM[0] <= 1'b1;
				COM[2] <= 1'b1;
				cc <= 2;
			end
		else if(cc == 2)
		   begin
				seg <= seg3;
				COM[1] <= 1'b1;
				COM[0] <= 1'b1;
				COM[2] <= 1'b0;
				cc <= 0;
			end
	  end
	
always@(posedge clk_div)
			begin
					if(A_count == 0 && B_count == 0 && C_count == 0)
							fail = 1;
					if(!fail&&!clear)
						begin
								if(A_count == 0)
									 begin
										 A_count <= 9;
										 B_count <= B_count - 1;
									 end
								else
									 A_count <= A_count - 1;
								if(B_count == 0 && A_count == 0) 
									 begin
										 B_count <= 5;
											if(C_count != 0)
												C_count <= C_count - 1;
									 end
						end
			 end
endmodule

//秒數轉7段顯示器
module BCD2Seg(input [3:0] D_count, output reg a,b,c,d,e,f,g);
  always @(D_count)
    case(D_count)
	      4'b0000:{a,b,c,d,e,f,g}=7'b0000001;
			4'b0001:{a,b,c,d,e,f,g}=7'b1001111;
			4'b0010:{a,b,c,d,e,f,g}=7'b0010010;
			4'b0011:{a,b,c,d,e,f,g}=7'b0000110;
			4'b0100:{a,b,c,d,e,f,g}=7'b1001100;
			4'b0101:{a,b,c,d,e,f,g}=7'b0100100;
			4'b0110:{a,b,c,d,e,f,g}=7'b1100000;
			4'b0111:{a,b,c,d,e,f,g}=7'b0001101;
			4'b1000:{a,b,c,d,e,f,g}=7'b0000000;
			4'b1001:{a,b,c,d,e,f,g}=7'b0001100;
			default:{a,b,c,d,e,f,g}=7'b1111111;
    endcase
endmodule

module divfreq(input sysclk, output reg clk_div);
	reg [24:0] Count;
	always @(posedge sysclk)
		begin
			if(Count > 25000000)
				begin
					Count <= 25'b0;
					clk_div <= ~clk_div;
				end
			else Count <= Count + 1'b1;
		end
endmodule 

module divfreq2(input sysclk, output reg clk_div2);
	reg [24:0] Count2;
	always @(posedge sysclk)
		begin
			if(Count2 > 10000)
				begin
					Count2 <= 25'b0;
					clk_div2 <= ~clk_div2;
				end
			else Count2 <= Count2 + 1'b1;
		end
endmodule
module rams_tdp_rf_rf
  (
   input wire 	     clka,
   input wire 	     clkb,
   input wire 	     ena,
   input wire 	     enb,
   input wire 	     wea,
   input wire 	     web,
   input wire [8:0]  addra,
   input wire [8:0]  addrb,
   input wire [7:0]  dia,
   input wire [7:0]  dib,
   output reg [7:0] doa,
   output reg [7:0] dob);
   
   
   reg[7:0] ram [511:0];

   parameter memfile = "";
   
always @(posedge clka)
begin 
  if (ena)
    begin
      if (wea)
        ram[addra] <= dia;
      doa <= ram[addra];
    end
end
always @(posedge clkb) 
begin 
  if (enb)
    begin
      if (web)
        ram[addrb] <= dib;
      dob <= ram[addrb];
    end
end

   initial
     if(|memfile) begin
	$display("Preloading %m from %s", memfile);
	$readmemh(memfile, ram);
     end

endmodule


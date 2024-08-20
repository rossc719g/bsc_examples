# pack_unpack

This example demonstrates "extra" logic that is inserted when copying from one
register to another when the datatype stored in the register has a custom Bits
instance.

In the generated verilog in code/mkPackUnpack.v, compare the implementation of
the `OneNoneAll t` registers and ports to those of the `Raw (OneNoneAll t)`.

```verilog
  // value method read
  assign read = r3[3] ? (r3[0] ? 4'd9 : 4'd8) : { 1'b0, r3[2:0] } ;

  // value method readRaw
  assign readRaw = raw3 ;

  // register r1
  assign r1$D_IN =
             write_1[3] ?
               (write_1[0] ? 4'd9 : 4'd8) :
               { 1'b0, write_1[2:0] } ;
  assign r1$EN = 1'd1 ;

  // register r2
  assign r2$D_IN = r1[3] ? (r1[0] ? 4'd9 : 4'd8) : { 1'b0, r1[2:0] } ;
  assign r2$EN = 1'd1 ;

  // register r3
  assign r3$D_IN = r2[3] ? (r2[0] ? 4'd9 : 4'd8) : { 1'b0, r2[2:0] } ;
  assign r3$EN = 1'd1 ;

  // register raw1
  assign raw1$D_IN = writeRaw_1 ;
  assign raw1$EN = 1'd1 ;

  // register raw2
  assign raw2$D_IN = raw1 ;
  assign raw2$EN = 1'd1 ;

  // register raw3
  assign raw3$D_IN = raw2 ;
  assign raw3$EN = 1'd1 ;
```

To replicate, execute `./compile.sh` in this dir.

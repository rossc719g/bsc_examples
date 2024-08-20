# pack_unpack

This example demonstrates "extra" logic that is inserted when copying from one
register to another when the datatype stored in the register has a custom Bits
instance.

In the generated verilog in code/mkPackUnpack.v, see the _read method, and the
implementation of the three registers. Since the values coming in on the_write_1
input are already packed, there is no need to unpack and then pack again when
copying from_write_1->r1, r1->r2, r2->r3, and r3->_read. Ideally, the code
should be something like:

```verilog
  // value method _read
  assign _read = r3 ;

  // register r1
  assign r1$D_IN = _write_1 ;
  assign r1$EN = 1'd1 ;

  // register r2
  assign r2$D_IN = r1 ;
  assign r2$EN = 1'd1 ;

  // register r3
  assign r3$D_IN = r2 ;
  assign r3$EN = 1'd1 ;
```

However, the generated verilog does unpack and pack again, introducing a mux
with extra logic gates, even though the values are never interpreted as anything
other than their packed form:

```verilog
  // value method _read
  assign _read = r3[3] ? (r3[0] ? 4'd9 : 4'd8) : { 1'b0, r3[2:0] } ;

  // register r1
  assign r1$D_IN =
             _write_1[3] ?
               (_write_1[0] ? 4'd9 : 4'd8) :
               { 1'b0, _write_1[2:0] } ;
  assign r1$EN = 1'd1 ;

  // register r2
  assign r2$D_IN = r1[3] ? (r1[0] ? 4'd9 : 4'd8) : { 1'b0, r1[2:0] } ;
  assign r2$EN = 1'd1 ;

  // register r3
  assign r3$D_IN = r2[3] ? (r2[0] ? 4'd9 : 4'd8) : { 1'b0, r2[2:0] } ;
  assign r3$EN = 1'd1 ;
```

To replicate, execute `./compile.sh` in this dir.

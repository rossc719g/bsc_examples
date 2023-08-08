# internal_error_1

This example demonstrates an "Internal Bluespec Compiler Error".

I am using the `bsc-2023.01-macos-12` version of the compiler downloaded from
https://github.com/B-Lang-org/bsc/releases/tag/2023.01

I am able to generate Verilog for `mkMyMuxThing` without error, but when
generating  the Verilog for `mkMyRawMuxThing`, I get the following error:

```
Internal Bluespec Compiler Error:
Please report this failure to the BSC developers, by opening a ticket
in the issue database: https://github.com/B-Lang-org/bsc/issues
The following internal error message should be included in your
correspondence along with any other relevant details:
Bluespec Compiler, version 2023.01 (build 52adafa)
chkADef mux_out :: ABSTRACT:  Prelude.Bit;
mux_out  = _if_ vMux_output_whas____d15 x__h1846 32'd0;
: (ADef {adef_objid = mux_out, adef_type = ATAbstract {ata_id = Prelude::Bit, ata_sizes = []}, adef_expr = APrim {ae_objid = Prelude::primIf, ae_type = ATBit {atb_size = 32}, aprim_prim = PrimIf, ae_args = [ASDef {ae_type = ATBit {atb_size = 1}, ae_objid = vMux_output_whas____d15[IdP_from_rhs]},ASDef {ae_type = ATBit {atb_size = 32}, ae_objid = x__h1846[IdP_keep]},ASInt {ae_objid = _, ae_type = ATBit {atb_size = 32}, ae_ival = 0}]}, adef_props = []}) ABSTRACT:  Prelude.Bit
 /= Bit 32
 ```

(Aside from the naming differences...) The modules `mkMyMuxThing` and
`mkMyRawMuxThing`, are identical except that `mkMyMuxThing` uses `mkVecMuxSel`
and `mkVecMuxSelRaw` uses `mkVecMuxSelRaw`.

`mkVecMuxSelRaw` is a wrapper around `mkVecMuxSel` that wraps the muxed type in
a `Raw` type.

The `Raw` type is defined in `Raw.bs`.

`Raw Foo` is roughly equivalent to `Bit (SizeOf Foo)` except that the `Foo` type
is recorded so that the value can be "`cooked`" back into a `Foo`.

To replicate, just execute `./compile.sh` in this dir.

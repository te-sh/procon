import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto k = n.bsr + 1;
  if (k % 2 == 0) {
    auto ma = 0L;
    foreach (_; 0..k/2)
      (ma <<= 2) |= 0b10;
    if (n < ma)
      writeln("Aoki");
    else
      writeln("Takahashi");
  } else {
    auto ma = 1L;
    foreach (_; 0..k/2)
      (ma <<= 2) |= 0b10;
    if (n < ma)
      writeln("Takahashi");
    else
      writeln("Aoki");
  }
}

pragma(inline) {
  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray
import std.math;      // math functions
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), l = rd[0], m = rd[1], n = rd[2];
  auto ai = readln.split.to!(int[]);
  auto bi = readln.split.to!(int[]);
  auto q = readln.chomp.to!int;

  calc2(n, ai, bi, q);
}

auto calc1(size_t n, int[] ai, int[] bi, int q)
{
  auto bai = BitArray(); bai.length = n+1;
  foreach (a; ai) bai[a] = true;
  auto bbi = BitArray(); bbi.length = n+1;
  foreach (b; bi) bbi[b] = true;

  foreach (_; 0..q) {
    auto bci = bai & bbi;
    writeln((cast(size_t[])(bci)).map!(i => i.popcnt).sum);
    bbi <<= 1;
  }
}

auto calc2(size_t n, int[] ai, int[] bi, int q)
{
  auto nf = (1 << ((n * 2).bsr + 1));
  auto cai = new double[](nf); cai[] = 0;
  foreach (a; ai) cai[a] = 1;
  auto cbi = new double[](nf); cbi[] = 0;
  foreach (b; bi) cbi[n-b] = 1;

  auto fai = fft(cai), fbi = fft(cbi);
  fai[] *= fbi[];

  auto ri = inverseFft(fai);
  foreach (r; ri[n..n+q])
    writeln(r.re.round.to!int);
}

pragma(inline) {
  import core.bitop;
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}

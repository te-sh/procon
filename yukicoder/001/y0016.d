import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;

const md = 1_000_003L;

version(unittest) {} else
void main()
{
  auto rd = readln.split, x = rd[0].to!long, n = rd[1].to!size_t;
  auto ai = readln.split.to!(long[]);

  auto xi = new long[](32);
  xi[0] = x;
  foreach (i; iota(1, 32))
    xi[i] = (xi[i - 1] ^^ 2) % md;

  auto r = ai.map!(a => pow(a, xi)).sum % md;
  writeln(r);
}

auto pow(long a, long[] xi)
{
  if (a == 0) return 1L;
  return reduce!((a, b) => (a * xi[b]) % md)(1L, bitsSet(a));
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto c = new int[](n);
  foreach (i; 0..n) c[i] = readln.chomp.to!int;

  auto r = real(0);

  foreach (i; 0..n) {
    auto d = 0;
    foreach (j; 0..n)
      if (i != j && c[i] % c[j] == 0) ++d;

    foreach (k; 0..d+1)
      if (k % 2 == 0) r += real(1) / (d+1);
  }

  writefln("%.7f", r);
}

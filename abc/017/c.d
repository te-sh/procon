import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto imos = new long[](m);
  foreach (_; 0..n) {
    auto rd2 = readln.split;
    auto l = rd2[0].to!size_t-1, r = rd2[1].to!size_t-1, s = rd2[2].to!int;
    imos[0] += s;
    imos[l] -= s;
    if (r < m-1) imos[r+1] += s;
  }

  foreach (i; 1..m) imos[i] += imos[i-1];

  writeln(imos.reduce!max);
}

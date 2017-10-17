import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ans = 0;

  foreach (_1; 0..n) {
    auto rd1 = readln.split.to!(int[]), x = rd1[0], y = rd1[1], z = rd1[2];
    auto m = readln.chomp.to!size_t;

    auto xma = 0, xmi = x-1, yma = 0, ymi = y-1, zma = 0, zmi = z-1;
    foreach (_2; 0..m) {
      auto rd2 = readln.split.to!(int[]), xi = rd2[0], yi = rd2[1], zi = rd2[2];
      xma = max(xma, xi); xmi = min(xmi, xi);
      yma = max(yma, yi); ymi = min(ymi, yi);
      zma = max(zma, zi); zmi = min(zmi, zi);
    }

    ans ^= xmi ^ (x-1-xma) ^ ymi ^ (y-1-yma) ^ zmi ^ (z-1-zma);
  }

  writeln(ans ? "WIN" : "LOSE");
}

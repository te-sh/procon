import std.algorithm, std.conv, std.range, std.stdio, std.string;
import core.bitop;    // bit operation

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), kr = rd[0], kb = rd[1];
  auto s = readln.chomp;

  auto bi = bitPos(s);

  auto maxL = 0.to!size_t;
  foreach (i; 0..(1 << 20)) {
    if (s.length - i.popcnt <= maxL) continue;
    string t;
    foreach (j; 0..30)
      if (!bitTest(i, bi[j])) t ~= s[j];
    if (valid(t, kr, kb))
      maxL = max(maxL, t.length);
  }

  writeln(maxL);
}

bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }

auto bitPos(string s)
{
  auto j = 0;
  auto bi = new size_t[](30);
  foreach (i, c; s) {
    if (c == 'W') bi[i] = 21;
    else bi[i] = j++;
  }
  return bi;
}

auto valid(T)(T[] s, int kr, int kb)
{
  foreach (i, c; s) {
    switch (c) {
    case 'R':
      if (i >= kr && s[i - kr] == 'R' || i + kr < s.length && s[i + kr] == 'R')
        return false;
      break;
    case 'B':
      if (i >= kb && s[i - kb] == 'B' || i + kb < s.length && s[i + kb] == 'B')
        return false;
      break;
    default:
    }
  }
  return true;
}

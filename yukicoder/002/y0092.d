import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1], k = rd1[2];

  int[][int][int] buf;
  foreach (_; m.iota) {
    auto rd2 = readln.split.to!(int[]), a = rd2[0] - 1, b = rd2[1] - 1, c = rd2[2];
    buf[c][a] ~= b;
    buf[c][b] ~= a;
  }

  auto di = readln.split.to!(int[]);

  auto ec = BitArray([]);
  ec.length = n;
  foreach (e; buf[di.front].keys) ec[e] = true;

  foreach (d; di.drop(1)) {
    auto en = BitArray([]);
    en.length = n;
    foreach (e; ec.bitsSet.map!(to!int))
      if (e in buf[d])
        foreach (e2; buf[d][e]) en[e2] = true;
    ec = en;
  }

  auto ri = ec.bitsSet.array;
  writeln(ri.length);
  writeln(ri.map!"a + 1".map!(to!string).join(" "));
}

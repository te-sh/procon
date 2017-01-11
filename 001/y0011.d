import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto w = readln.chomp.to!long;
  auto h = readln.chomp.to!long;
  auto n = readln.chomp.to!size_t;
  auto ski = n.iota.map!(_ => readln.split.to!(int[])).array;

  auto us = countUniq(ski.map!"a[0]");
  auto uk = countUniq(ski.map!"a[1]");

  writeln(us * h + w * uk - us * uk - n);
}

auto countUniq(Range)(Range ai)
  if (isInputRange!Range)
{
  bool[long] bi;
  foreach (a; ai) bi[a] = true;
  return bi.length;
}

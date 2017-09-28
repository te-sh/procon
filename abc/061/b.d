import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto r = new int[](n);
  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), a = rd2[0]-1, b = rd2[1]-1;
    ++r[a];
    ++r[b];
  }

  foreach (ri; r) writeln(ri);
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], q = rd1[1];
  auto b = new int[](n);
  foreach (_; 0..q) {
    auto rd2 = readln.split, l = rd2[0].to!size_t-1, r = rd2[1].to!size_t-1, t = rd2[2].to!int;
    b[l..r+1] = t;
  }
  foreach (bi; b) writeln(bi);
}

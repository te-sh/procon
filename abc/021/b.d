import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto rd = readln.split.to!(size_t[]), a = rd[0], b = rd[1];
  auto k = readln.chomp.to!size_t;
  auto p = readln.split.to!(size_t[]);

  auto buf = new bool[](n+1);
  buf[a] = buf[b] = true;

  foreach (pi; p) {
    if (buf[pi]) {
      writeln("NO");
      return;
    }
    buf[pi] = true;
  }

  writeln("YES");
}

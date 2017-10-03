import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;

  auto k = "ABXY";
  auto ans = s.length;

  foreach (i; 0..(1<<8)) {
    auto l = [k[(i>>6)&3], k[(i>>4)&3]];
    auto r = [k[(i>>2)&3], k[i&3]];
    auto t = s.replace(l, "L").replace(r, "R");
    ans = min(ans, t.length);
  }

  writeln(ans);
}

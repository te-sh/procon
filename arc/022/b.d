import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto a2 = a.dup;
  a2.sort();
  int[int] buf;
  foreach (a2i; a2.uniq.enumerate) buf[a2i[1]] = a2i[0].to!int;
  foreach (ref ai; a) ai = buf[ai];

  auto last = new int[](a2.back + 1);
  last[] = -1;
  auto s = 0, ans = 0;
  foreach (int i, ai; a) {
    if (last[ai] >= s) {
      s = last[ai] + 1;
    }
    ans = max(ans, i-s+1);
    last[ai] = i;  
  }

  writeln(ans);
}

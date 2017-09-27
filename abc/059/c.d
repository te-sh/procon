import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc072_a

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto calc(int fs)
  {
    auto t = 0, ans = 0L;
    foreach (i, ai; a) {
      auto s = i % 2 == 0 ? fs : -fs;
      t += ai;
      if (t * s <= 0) {
        ans += (s - t) * s;
        t = s;
      }
    }
    return ans;
  }

  writeln(min(calc(+1), calc(-1)));
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;

  foreach (_; t.iota) {
    auto s = readln.chomp;
    writeln(calc(s) ? "possible" : "impossible");
  }
}

auto calc(string s)
{
  auto r = 0, g = 0, w = 0;
  foreach_reverse (c; s) {
    switch (c) {
    case 'R':
      ++r;
      break;
    case 'G':
      if (g >= r) return false;
      ++g;
      break;
    case 'W':
      if (g == 0) return false;
      w = min(w + 1, g);
      break;
    default:
      assert(0);
    }
  }
  return r == g && g == w;
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto b = new long[](n);
  foreach (i; 0..n) b[i] = readln.chomp.to!long;

  auto a = new long[](n+1);

  auto calc(long a0)
  {
    a[0] = a0;
    foreach (i; 1..n+1) {
      a[i] = (i&1) ? b[i-1]-a[i-1] : a[i-1]-b[i-1];
      if (a[i] < 1)
        return (((i-1)/2)&1) ? -1 : 1;
      else if (a[i] > 10L^^18)
        return (((i-1)/2)&1) ? 1 : -1;
    }
    return 0;
  }

  auto bsearch = iota(1, 10L^^18).map!(a0 => tuple(a0, calc(a0))).assumeSorted!"a[1] < b[1]";
  auto r = bsearch.equalRange(tuple(0, 0));
  if (r.empty) {
    writeln(-1);
  } else {
    auto a0 = r.front[0];
    calc(a0);
    writeln(n+1);
    foreach (ai; a) writeln(ai);
  }
}

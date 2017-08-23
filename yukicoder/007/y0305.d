import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto r = new int[](10); r[] = -1;

  foreach (i; 0..10) {
    auto a = new int[](10);
    a[] = i;

    auto x = ask(a);
    if (x == 10) return;
    foreach (j; 0..10) {
      auto b = a.dup; b[j] = (b[j] + 1) % 10;
      auto y = ask(b);
      if (y == 10) return;
      if (y < x) r[j] = i;
    }
  }

  r.each!write; writeln; stdout.flush();
}

auto ask(int[] a)
{
  a.each!write; writeln; stdout.flush();
  auto rd = readln.split;
  return rd[0].to!int;
}

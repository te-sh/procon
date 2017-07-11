import std.algorithm, std.conv, std.range, std.stdio, std.string;

struct Res { int x, y; }

version(unittest) {} else
void main()
{
  auto d = new bool[](10);
  auto s = new int[](10);

  foreach (i; 3..10) {
    auto r = ask([0,1,2,i]);
    s[i] = r.x + r.y;
  }

  auto rm1 = s[3..10].maxElement;
  foreach (i; 3..10)
    if (s[i] == rm1)
      d[i] = true;

  if (d[3..10].count(true) == 1)
    d[0..3][] = true;

  if (d.count(true) < 4) {
    foreach (i; 0..3) {
      auto r = ask([3,4,5,i]);
      s[i] = r.x + r.y;
    }
    auto rm2 = s[0..3].maxElement;
    foreach (i; 0..3)
      if (s[i] == rm2)
        d[i] = true;
  }

  auto t = d.enumerate.filter!"a[1]".map!"a[0]".array.to!(int[]);

  do {
    ask(t);
  } while (t.nextPermutation);
}

auto ask(int[] n)
{
  import core.stdc.stdlib;
  writeln(n.to!(string[]).join(" "));
  stdout.flush();
  auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1];
  if (x == 4 && y == 0) exit(0);
  return Res(rd[0], rd[1]);
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;

struct XD { int x; bool d; }

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], l = rd[1];
  auto xd = new XD[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto x = rd2.front.to!int; rd2.popFront();
    auto d = rd2.front == "R";
    xd[i] = XD(x, d);
  }

  if (!xd[0].d) xd = [XD(0, true)] ~ xd;
  if (xd[$-1].d) xd ~= XD(l+1, false);

  auto g = xd.chunkBy!"a.d == b.d".array, ans = 0L;
  foreach (i; 0..g.length/2)
    ans += calc(g[i*2].map!"a.x".array, g[i*2+1].map!"a.x".array);

  writeln(ans);
}

auto calc(int[] r, int[] l)
{
  r.reverse();

  auto t = 0L;

  foreach (i; 1..r.length)
    t += r[0] - i - r[i];

  foreach (i; 1..l.length)
    t += l[i] - l[0] - i;

  t += max(l.length, r.length) * (l[0] - r[0] - 1);

  return t;
}

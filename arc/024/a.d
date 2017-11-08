import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), nl = rd[0], nr = rd[1];
  auto l = readln.split.to!(int[]);
  auto r = readln.split.to!(int[]);

  auto gl = l.sort().group.assocArray;
  auto gr = r.sort().group.assocArray;

  auto ans = 0;
  foreach (gli; gl.byKey)
    if (gli in gr) ans += min(gl[gli], gr[gli]);

  writeln(ans);
}

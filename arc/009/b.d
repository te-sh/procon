import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto b = readln.split.to!(int[]);
  auto n = readln.chomp.to!size_t;
  auto a = new int[][](n);
  foreach (i; 0..n) a[i] = readln.chomp.map!(c => cast(int)(c-'0')).array;

  auto s = new int[](10);
  foreach (int i, bi; b) s[bi] = i;

  auto comp(int[] a, int[] b)
  {
    if (a.length < b.length) return -1;
    else if (a.length > b.length) return 1;

    foreach (ai, bi; lockstep(a, b)) {
      if (s[ai] < s[bi]) return -1;
      else if (s[ai] > s[bi]) return 1;
    }

    return 0;
  }

  a.sort!((a, b) => comp(a, b) < 0);

  foreach (ai; a) writeln(ai.to!(string[]).join);
}

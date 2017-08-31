import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, k = rd[1].to!int;
  auto s = readln.chomp.dup, so = s.dup;
  sort(cast(ubyte[])s);

  auto countDiff(char[] a, char[] b)
  {
    auto r = 0;
    foreach (ai, bi; lockstep(a, b))
      if (ai != bi) ++r;
    return r;
  }

  auto countMinDiff(char[] a, char[] b)
  {
    auto r = 0;
    foreach (c; 'a'..'z'+1) {
      r += min(a.count(c), b.count(c));
    }
    return a.length - r;
  }

  char[] r;
  foreach (i; 0..n) {
    auto f = countDiff(r, so[0..i]);
    auto sn = s.length;
    foreach (j, c; s) {
      auto sr = s[0..j] ~ s[j+1..$];
      if (f + (c == so[$-sn] ? 0 : 1) + countMinDiff(sr, so[$-sn+1..$]) <= k) {
        s = sr;
        r ~= c;
        break;
      }
    }
  }

  writeln(r);
}

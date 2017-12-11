import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], s = rd[1], w = rd[2];
  auto a = readln.split.to!(int[]);

  auto aw = a[w] + 100*s;
  a = a.remove(w).array;
  a.sort!"a > b";

  auto st = new int[](n-1);
  foreach (i; 0..n-1) st[i] = 50*s + 500*s/(8+2*(i+1));
  st.reverse();

  auto ans = 1.0L;
  foreach (i; 0..n-1) {
    auto r = st.assumeSorted!"a <= b".lowerBound(aw - a[i]).length;
    if (r < i) {
      writeln(0);
      return;
    }
    ans *= (r-i).to!real / (n-i-1);
  }

  writefln("%.10f", ans);
}

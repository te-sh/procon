import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], d = rd1[1], k = rd1[2];
  auto l = new int[](d), r = new int[](d);
  foreach (i; 0..d) {
    auto rd2 = readln.split.to!(int[]), li = rd2[0], ri = rd2[1];
    l[i] = li; r[i] = ri;
  }
  auto s = new int[](k), t = new int[](k);
  foreach (i; 0..k) {
    auto rd3 = readln.split.to!(int[]), si = rd3[0], ti = rd3[1];
    s[i] = si; t[i] = ti;
  }

  auto ans = new int[](k);

  foreach (i; 0..d)
    foreach (j; 0..k)
      if (!ans[j] && s[j] >= l[i] && s[j] <= r[i]) {
        if (t[j] >= l[i] && t[j] <= r[i]) {
          ans[j] = i+1;
        } else {
          s[j] = t[j] > s[j] ? r[i] : l[i];
        }
      }
 
  foreach (i; 0..k) writeln(ans[i]);
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;
  foreach (_; 0..t) calc();
}

void calc()
{
  auto s = readln.chomp, sl = s.length;

  auto dg = new int[](sl-10), dp = new int[](sl-10);
  foreach (i; 0..sl-10) {
    dg[i] = dist(s[i..i+4], "good");
    dp[i] = dist(s[i+4..i+11], "problem");
  }

  auto fp = new int[](sl-6);
  foreach (i; 0..sl-6)
    fp[i] = s[i..i+7] == "problem" ? 1 : 0;
  foreach (i; 1..sl-6)
    fp[i] += fp[i-1];

  foreach (i; 1..sl-10) {
    dg[i] = min(dg[i-1], dg[i]);
    dp[$-i-1] = min(dp[$-i], dp[$-i-1]);
  }

  dg[] += dp[];

  auto r = dg[0];
  foreach (i; 1..sl-10)
    r = min(r, dg[i] + fp[i-1]);

  writeln(r);
}

int dist(string s, string t)
{
  return s.zip(t).count!"a[0] != a[1]".to!int;
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  struct CK { int s, t; }
  auto ck = new CK[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto s = rd2.front.to!int-1; rd2.popFront();
    auto t = rd2.front.to!int;
    ck[i] = CK(s, t);
  }

  auto r = new int[](n+1);
  foreach (cki; ck) {
    r[cki.s]++;
    r[cki.t]--;
  }

  foreach (i; 1..n) r[i] += r[i-1];

  foreach (i; 0..n) r[i] = r[i] == 1;

  auto rs = new int[](n+1);
  foreach (i; 0..n) rs[i+1] = rs[i] + r[i];

  int[] ans;
  foreach (int i, cki; ck)
    if (rs[cki.t]-rs[cki.s] == 0)
      ans ~= i+1;

  writeln(ans.length);
  ans.each!writeln;
}

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  struct Task { int a, b, i; }
  auto t = new Task[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    auto a = rd.front.to!int; rd.popFront();
    auto b = rd.front.to!int;
    t[i] = Task(a, b, i+1);
  }

  int[int] buf;
  auto tm = t.map!"a.a".chain(t.map!"a.b").array;
  tm.sort();
  foreach (i, tmi; tm.uniq.enumerate!int) buf[tmi] = i;

  foreach (ref ti; t) {
    ti.a = buf[ti.a];
    ti.b = buf[ti.b];
  }
  t.sort!"a.a < b.a";

  auto ma = t.map!"a.b".reduce!max;
  auto dp = new int[](ma+1), w = new Task[](ma+1);
  w[$-1] = Task(0, 0, 0);

  auto cur = n-1;
  foreach_reverse (i; 0..ma) {
    dp[i] = dp[i+1];
    w[i] = w[i+1];
    while (cur >= 0 && t[cur].a == i) {
      if (dp[i] == dp[t[cur].b]) {
        w[i] = t[cur];
        dp[i] = dp[t[cur].b] + 1;
      } else if (dp[i] == dp[t[cur].b] + 1 && t[cur].i < w[i].i) {
        w[i] = t[cur];
        dp[i] = dp[t[cur].b] + 1;
      }
      --cur;
    }
  }

  writeln(dp[0]);
  auto wc = w[0];
  for (;;) {
    write(wc.i);
    wc = w[wc.b];
    if (wc.i == 0) break;
    write(" ");
  }
  writeln;
}

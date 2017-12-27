import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], c = rd[1];
  struct Program { int s, t, c; }
  auto p = new Program[](n);
  bool[int][int] h;

  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto si = rd2.front.to!int; rd2.popFront();
    auto ti = rd2.front.to!int; rd2.popFront();
    auto ci = rd2.front.to!int;
    p[i] = Program(si, ti, ci);
    h[ci][ti] = true;
  }

  auto m = 10^^5*2+1;
  auto s = new int[](m);

  foreach (pi; p) {
    s[pi.s*2-(pi.c in h && pi.s in h[pi.c] ? 0 : 1)]++;
    s[pi.t*2]--;
  }

  foreach (i; 1..m) s[i] += s[i-1];

  writeln(s.reduce!max);
}
